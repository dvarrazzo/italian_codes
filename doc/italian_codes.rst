italian_codes
=============

``italian_codes`` is a PostgreSQL package containing validation domains for
Italian fiscal codes.

It can currently validate *Codice Fiscale* (Italian Fiscal Code) for both
physical person (16 characters) and juridical person (11 digits) and *Partita
IVA* (VAT Number). It only contains data type and functions to validate the
codes and it doesn't contain code to generate it from the person's data: the
practice of generating a Fiscal Code is fundamentally flawed as it doesn't
account for *omocodia* (people whose Fiscal Code would match). In such case,
the *Agenzia delle Entrate* (Revenue Service) provides an alternative code for
either person.  **The only valid Fiscal Code is the one provided from the
Revenue Service**, and each program trying to calculate it, or worse, enforce
it after its calculation, is doing wrong.


Domains
-------

The domains are based on the ``text`` data type and ensure only valid codes
are stored. Provided domains are:

- ``codice_fiscale``: a valid Italian Fiscal Code, either 16 or 11 characters
  long;
- ``partita_iva``: a valid Italian VAT Number.


Functions
---------

Available functions are:

``codice_fiscale(s text) -> codice_fiscale``
    Normalize the input string *s* and return it cast to a *Codice Fiscale*.
    If the string is not a valid code, raise a violation check error.

    Example::

        =# select codice_fiscale('mss trs 53b19 h892p'::text);
        MSSTRS53B19H892P

    Note that the function doesn't work as expected on a "naked" literal, as
    the parser prefers to interpret the expression ``codice_fiscale('X')`` as
    the typed literal ``'X'::codice_fiscale``, bypassing the normalization. If
    the function argument is an expression, such as the name of the field or a
    typed string as above, the function works as expected.

``codice_fiscale_normalize(s text) -> text``
    Return a normalized version of the input string *s*. The normalized
    output is uppercase and has all the whitespaces stripped. No check is
    performed on the content of the string.

``codice_fiscale_error(s text) -> text``
    Return ``NULL`` if the input string *s* contains a valid *Codice
    Fiscale*; otherwise return a string with an informative error message.
    *s* must be already normalized.


``partita_iva(s text) -> partita_iva``
    Normalize the input string *s* and return it cast to a *Partita IVA*.
    If the string is not a valid code, raise a violation check error.

    Example::

        =# select partita_iva('0575346 048 3'::text);
        05753460483

    Note that the function doesn't work as expected on a "naked" literal, see
    the ``codice_fiscale()`` function.

``partita_iva_normalize(s text) -> text``
    Returns a normalized version of the input string *s*. The normalized
    output has all the whitespaces stripped. No check is performed on the
    content of the string.

``partita_iva_error(s text) -> text``
    Return ``NULL`` if the input string *s* contains a valid *Partita IVA*;
    otherwise return a string with an informative error message.  *s* must be
    already normalized.


