\set ECHO none
\t
\a
create function add_check_and_error(s text) returns text as
$$
    -- add the valid check character and return the error message if any
    select codice_fiscale_error($1 || _cf_check_char($1));
$$
language sql immutable strict;

\set ECHO all
--
-- Codice Fiscale Persone Fisiche
--

-- base usage
select 'MSSTRS53B19H892P'::codice_fiscale;
select codice_fiscale('MSSTRS53B19H892P');

-- normalization
-- note that with the naked literal in round brackets (above), the
-- parser prefers to interpret the expression as a literal with type.
select codice_fiscale(E'\tmss trs 53b19 h892 p '::text);

-- strict function
select codice_fiscale(NULL::text);

-- error
select codice_fiscale('MSSTRS53B19H892'::text);

-- error message for wrong length
select codice_fiscale_error(''::text);
select codice_fiscale_error('MSSTRS53B19H892'::text);
select codice_fiscale_error('MSSTRS53B19H892PP'::text);

-- error message for wrong char
select codice_fiscale_error('0SSTRS53B19H892P'::text);
select codice_fiscale_error('M0STRS53B19H892P'::text);
select codice_fiscale_error('MS0TRS53B19H892P'::text);
select codice_fiscale_error('MSS0RS53B19H892P'::text);
select codice_fiscale_error('MSST0S53B19H892P'::text);
select codice_fiscale_error('MSSTR053B19H892P'::text);
select codice_fiscale_error('MSSTRSA3B19H892P'::text);
select codice_fiscale_error('MSSTRS5AB19H892P'::text);
select codice_fiscale_error('MSSTRS53019H892P'::text);
select codice_fiscale_error('MSSTRS53BA9H892P'::text);
select codice_fiscale_error('MSSTRS53B1AH892P'::text);
select codice_fiscale_error('MSSTRS53B190892P'::text);
select codice_fiscale_error('MSSTRS53B19HA92P'::text);
select codice_fiscale_error('MSSTRS53B19H8A2P'::text);
select codice_fiscale_error('MSSTRS53B19H89AP'::text);
select codice_fiscale_error('MSSTRS53B19H8920'::text);

select codice_fiscale_error('MSSTRS-3B19H892P'::text);

-- all replacement characters for omocodia accepted
select add_check_and_error('MSSTRSL3B19H892');
select add_check_and_error('MSSTRSM3B19H892');
select add_check_and_error('MSSTRSN3B19H892');
select add_check_and_error('MSSTRSP3B19H892');
select add_check_and_error('MSSTRSQ3B19H892');
select add_check_and_error('MSSTRSR3B19H892');
select add_check_and_error('MSSTRSS3B19H892');
select add_check_and_error('MSSTRST3B19H892');
select add_check_and_error('MSSTRSU3B19H892');
select add_check_and_error('MSSTRSV3B19H892');

-- a few chars are not accepted instead
select add_check_and_error('MSSTRSA3B19H892');
select add_check_and_error('MSSTRSK3B19H892');
select add_check_and_error('MSSTRSO3B19H892');
select add_check_and_error('MSSTRSW3B19H892');
select add_check_and_error('MSSTRSZ3B19H892');

-- all numbers can be replaced
select add_check_and_error('MSSTRSR3B19H892');
select add_check_and_error('MSSTRS5PB19H892');
select add_check_and_error('MSSTRS53BM9H892');
select add_check_and_error('MSSTRS53B1VH892');
select add_check_and_error('MSSTRS53B19HU92');
select add_check_and_error('MSSTRS53B19H8V2');
select add_check_and_error('MSSTRS53B19H89N');

-- month lengths ok
select add_check_and_error('MSSTRS53A01H892');
select add_check_and_error('MSSTRS53A31H892');
select add_check_and_error('MSSTRS53B28H892');
select add_check_and_error('MSSTRS52B29H892');
select add_check_and_error('MSSTRS53C31H892');
select add_check_and_error('MSSTRS53D30H892');
select add_check_and_error('MSSTRS53E31H892');
select add_check_and_error('MSSTRS53H30H892');
select add_check_and_error('MSSTRS53L31H892');
select add_check_and_error('MSSTRS53M31H892');
select add_check_and_error('MSSTRS53P30H892');
select add_check_and_error('MSSTRS53R31H892');
select add_check_and_error('MSSTRS53S30H892');
select add_check_and_error('MSSTRS53T31H892');

-- women
select add_check_and_error('MSSTRS53A41H892');
select add_check_and_error('MSSTRS53A71H892');
select add_check_and_error('MSSTRS53B68H892');
select add_check_and_error('MSSTRS52B69H892');
select add_check_and_error('MSSTRS53C71H892');
select add_check_and_error('MSSTRS53D70H892');
select add_check_and_error('MSSTRS53E71H892');
select add_check_and_error('MSSTRS53H70H892');
select add_check_and_error('MSSTRS53L71H892');
select add_check_and_error('MSSTRS53M71H892');
select add_check_and_error('MSSTRS53P70H892');
select add_check_and_error('MSSTRS53R71H892');
select add_check_and_error('MSSTRS53S70H892');
select add_check_and_error('MSSTRS53T71H892');

-- month lengths wrong
select add_check_and_error('MSSTRS53A32H892');
select add_check_and_error('MSSTRS53B29H892');
select add_check_and_error('MSSTRS52B30H892');
select add_check_and_error('MSSTRS53C32H892');
select add_check_and_error('MSSTRS53D31H892');
select add_check_and_error('MSSTRS53E32H892');
select add_check_and_error('MSSTRS53H31H892');
select add_check_and_error('MSSTRS53L32H892');
select add_check_and_error('MSSTRS53M32H892');
select add_check_and_error('MSSTRS53P31H892');
select add_check_and_error('MSSTRS53R32H892');
select add_check_and_error('MSSTRS53S31H892');
select add_check_and_error('MSSTRS53T32H892');

-- other bad dates
select add_check_and_error('MSSTRS53A00H892');
select add_check_and_error('MSSTRS53F01H892');
select add_check_and_error('MSSTRS53U01H892');
select add_check_and_error('MSSTRS53A40H892');

-- control code
select codice_fiscale('MSSTRS53B19H892O');
select codice_fiscale('MSSTRS53B19H892Q');


--
-- Codice Fiscale Persone Giuridiche
--

-- base usage
select '94144670489'::codice_fiscale;
select codice_fiscale('94144670489');

-- normalization
select codice_fiscale(E'\t9414467 048 9 '::text);

-- error
select codice_fiscale('9414467048'::text);

-- error message for wrong length
select codice_fiscale_error('');
select codice_fiscale_error('94144670489');
select codice_fiscale_error('941446704899');

-- error message for wrong char
select codice_fiscale_error('A4144670489');
select codice_fiscale_error('9A144670489');
select codice_fiscale_error('94A44670489');
select codice_fiscale_error('941A4670489');
select codice_fiscale_error('9414A670489');
select codice_fiscale_error('94144A70489');
select codice_fiscale_error('941446A0489');
select codice_fiscale_error('9414467A489');
select codice_fiscale_error('94144670A89');
select codice_fiscale_error('941446704A9');
select codice_fiscale_error('9414467048A');

-- bad control digit
select codice_fiscale_error('94144670488');
select codice_fiscale_error('94144670480');
