\set ECHO none
\t
\a
\set ECHO all

--
-- Partita IVA
--

-- base usage
select '05753460483'::partita_iva;
select partita_iva('05753460483');

-- normalization
select partita_iva(E'\t0575346 048 3 '::text);

-- strict function
select partita_iva(NULL::text);

-- error
select partita_iva('0575346048'::text);

-- error message for wrong length
select partita_iva_error('');
select partita_iva_error('0575346048');
select partita_iva_error('057534604833');

-- error message for wrong char
select partita_iva_error('A5753460483');
select partita_iva_error('0A753460483');
select partita_iva_error('05A53460483');
select partita_iva_error('057A3460483');
select partita_iva_error('0575A460483');
select partita_iva_error('05753A60483');
select partita_iva_error('057534A0483');
select partita_iva_error('0575346A483');
select partita_iva_error('05753460A83');
select partita_iva_error('057534604A3');
select partita_iva_error('0575346048A');

-- bad control digit
select partita_iva_error('05753460482');
select partita_iva_error('05753460484');
