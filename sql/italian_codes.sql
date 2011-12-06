--
-- italian_codes -- SQL definitions
--
-- Copyright (C) 2011 Daniele Varrazzo <daniele.varrazzo@gmail.com>
--

create function _cf_error(s text) returns boolean as
$$
-- Return True if *s* is a valid Codice Fiscale
-- else raise a 'check_violation' exception with a description of the problem.
declare
    error text := codice_fiscale_error(s);
begin
    if error is null then
        return true;
    else
        raise 'Codice Fiscale non valido: %', error
            using errcode = 'check_violation';
    end if;
end
$$ immutable strict language plpgsql;

create domain codice_fiscale as text
    check (_cf_error(VALUE));

comment on domain codice_fiscale is
'A valid Italian Codice Fiscale.';


create function codice_fiscale_normalize(s text) returns text as
$$
select upper(regexp_replace($1, '[[:space:]]', '', 'g'));
$$
immutable strict language sql;

comment on domain codice_fiscale is
'Normalize a string representing a codice fiscale.';


create function codice_fiscale(s text) returns codice_fiscale as
$$
select codice_fiscale_normalize($1)::codice_fiscale;
$$
language sql immutable strict;

comment on function codice_fiscale(text) is
'Normalize and return a string into a codice_fiscale domain.';


create function codice_fiscale_error(s text) returns text as
$$
begin
    if length(s) = 16 then
        return _cf_error_16(s);

    elsif length(s) = 11 then
        return 'TODO';

    else
        return 'lunghezza errata: ' || length(s)::text
            || '; attesi 11 o 16 caratteri';
    end if;

    return null;
end
$$ immutable strict language plpgsql;

comment on function codice_fiscale_error(text) is
'Return the error message for a wrong Codice Fiscale, else NULL.';


create function _cf_error_16(s text) returns text as
$$
begin
    -- Check the basic pattern. If it doesn't match, slow check for errors.
    -- Note the final '|' char: if missing, in case of no match, the function
    -- returns no row, not null (because regexp_matches is a SRF). The result
    -- is that the if block is skipped altogether. Yes, it sucks. Big times.
    if regexp_matches(s,
        '[A-Z]{6}'
        '[0-9L-NP-V]{2}[A-Z][0-9L-NP-V]{2}'
        '[A-Z][0-9L-NP-V]{3}[A-Z]|')
            = array[''] then
        for i in 1 .. 16 loop
            declare
                t text := substring('CCCCCCNNCNNCNNNC', i, 1);
                c text := substring(s, i, 1);
            begin
                if t = 'C' then
                    if c not between 'A' and 'Z' then
                        return 'carattere non valido in posizione ' || i
                            || ': attesa una lettera';
                    end if;
                else
                    if 0 = position(c in '0123456789LMNPQRSTUV') then
                        return 'carattere non valido in posizione ' || i
                            || ': atteso un numero';
                            -- Not strictly true: it could be omocodia
                    end if;
                end if;
            end;
        end loop;

        -- You shouldn't be there
        raise 'assert failed in codice_fiscale_error with input %',
            s;
    end if;

    -- Check the date
    declare
        year integer := _cf_int(substring(s from 7 for 2));
        month integer := position(substring(s from 9 for 1)
            in 'ABCDEHLMPRST');
        day integer := _cf_int(substring(s from 10 for 2));
        month_lens constant integer[] :=
            array[31,28,31,30,31,30,31,31,30,31,30,31];
        month_len integer;
    begin
        if month = 0 then
            return 'carattere per il mese sbagliato in posizione 9';
        end if;

        month_len := month_lens[month];
        if month = 2 and year % 4 = 0 then
            -- we can't tell apart 1900 from 2000, so we consider
            -- all years divisible by 4 as leap.
            month_len := month_len + 1;
        end if;

        -- women add 40 to birth day
        if day > 40 then
            day := day - 40;
        end if;

        if day not between 1 and month_len then
            return 'giorno di nascita sbagliato in posizione 7-8';
        end if;
    end;

    -- Check the control code
    if _cf_check_char(substring(s from 1 for 15))
            != substring(s from 16 for 1) then
        return 'codice di controllo sbagliato';
    end if;

    -- All fine
    return null;
end
$$ immutable strict language plpgsql;

create function _cf_check_char(s text) returns text as
$$
-- Return the control char of a string.
-- Assume the string only contains chars valid in a Codice Fiscale.
declare
    acc int := 0;
    c text;
    odd_chars constant integer[] :=
        array[1,0,5,7,9,13,15,17,19,21,2,4,18,20,11,3,6,8,12,14,16,10,22,25,24,23];

begin
    -- Even chars
    for i in 2 .. length(s) by 2 loop
        c := substring(s from i for 1);
        if c between 'A' and 'Z' then
            acc := acc + (ascii(c) - ascii('A'));
        else
            acc := acc + (ascii(c) - ascii('0'));
        end if;
    end loop;

    -- Odd chars
    for i in 1 .. length(s) by 2 loop
        c := substring(s from i for 1);
        if c between 'A' and 'Z' then
            acc := acc + odd_chars[1+(ascii(c) - ascii('A'))];
        else
            acc := acc + odd_chars[1+(ascii(c) - ascii('0'))];
        end if;
    end loop;

    return chr(ascii('A') + acc % 26);
end
$$ immutable strict language plpgsql;

create function _cf_int(s text) returns integer as
$$
-- Convert a string of numberic chars or replacement chars into an integer.
-- Assume only valid characters in *s*.
declare
    acc integer := 0;
    c text;
    repl_chars text := 'LMNPQRSTUV';

begin
    for i in 1 .. length(s) loop
        acc := acc * 10;
        c := substring(s from i for 1);
        if c between '0' and '9' then
            acc := acc + (ascii(c) - ascii('0'));
        else
            acc := acc + (position(c in repl_chars) - 1);
        end if;
    end loop;

    return acc;
end
$$ immutable strict language plpgsql;

