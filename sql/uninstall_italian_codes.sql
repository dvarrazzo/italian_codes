--
-- italian_codes -- SQL uninstall script
--
-- Copyright (C) 2011 Daniele Varrazzo <daniele.varrazzo@gmail.com>
--

drop function _cf_check_digit(s text);
drop function _cf_int(s text);
drop function _cf_check_char(s text);
drop function _cf_error_11(s text);
drop function _cf_error_16(s text);
drop function partita_iva_error(s text);
drop function partita_iva(s text);
drop function partita_iva_normalize(s text);
drop domain partita_iva;
drop function _pi_check(s text);
drop function codice_fiscale_error(s text);
drop function codice_fiscale(s text);
drop function codice_fiscale_normalize(s text);
drop domain codice_fiscale;
drop function _cf_check(s text);
