Estensione "Codici Italiani"
============================

``italian_codes`` è un'estensione per PostgreSQL contenente domini per
validare codici fiscali italiani.

Usando l'estensione si possono correntemente validare *Codice Fiscale* sia per
persone fisiche (16 caratteri) che giuridiche (11 caratteri) e *Partita IVA*.

L'estensione contiene solo tipi di dati e funzioni per validare i codici e non
contiene algoritmi per generare i codici a partire dai dati personali: la
pratica di generare da sé il Codice Fiscale è fondamentalmente sbagliata in
quanto non tiene conto di omocodie_ (persone il cui Codice Fiscale
combacerebbe), nel qual caso l'Agenzia delle Entrate provvede a fornire codici
alternativi. **L'unico Codice Fiscale valido è quello fornito dall'Agenzia
delle Entrate**, e qualunque programma cerchi di calcolarlo, o peggio cerchi
di obbligare l'utilizzo della versione calcolata, non ha un comportamento
corretto.

Tutti i messaggi di errore generati dalle funzioni di validazione sono in
lingua italiana.

.. _omocodie: http://it.wikipedia.org/wiki/Omocodia


Domini
------

I domini sono basati sul tipo di dato ``text`` e verificano che solo codici
validi vengano memorizzati. I domini forniti sono:

- ``codice_fiscale``: un Codice Fiscale italiano valido, sia di 16 che di 11
  caratteri;
- ``partita_iva``: una Partita IVA italiana valida.


Funzioni
--------

Le funzioni disponibili sono:

``codice_fiscale(s text) -> codice_fiscale``
    Normalizza la stringa di input *s* e la restituisce convertita nel dominio
    di un Codice Fiscale. Se la stringa non è un Codice Fiscale valido,
    solleva un'eccezione di tipo ``violation_check``.

    Esempio::

        =# select codice_fiscale('mss trs 53b19 h892p'::text);
        MSSTRS53B19H892P

    Si noti che la funzione non si comporta come atteso su un letterale
    stringa, in quanto il parser preferisce interpretare l'espressione
    ``codice_fiscale('X')`` come il letterale ``'X'::codice_fiscale``,
    saltando la fase di normalizzazione. Se l'argomento della funzione è
    un'espressione, quale il nome di un campo o un letterale tipizzato come
    nell'esempio, la funzione si comporta come atteso.

``codice_fiscale_normalize(s text) -> text``
    Restituisce una versione normalizzata della stringa di input *s*. L'output
    normalizzato è in maiuscolo e tutti gli spazi sono eliminati. La funzione
    non effettua alcun controllo sul contenuto della stringa.

``codice_fiscale_error(s text) -> text``
    Restituisce ``NULL`` se la stringa di input *s* contiene un Codice Fiscale
    valido, altrimenti restituisce una stringa con un messaggio di errore
    informativo. *s* dev'essere già normalizzata.

``partita_iva(s text) -> partita_iva``
    Normalizza la stringa di input *s* e la restituisce convertita nel dominio
    di una Partita IVA. Se la stringa non è una Partita IVA valida, solleva
    un'eccezione di tipo ``violation_check``.

    Esempio::

        =# select partita_iva('0575346 048 3'::text);
        05753460483

    Si noti che la funzione non si comporta come atteso su un letterale
    stringa: vedi funzione ``codice_fiscale()``.

``partita_iva_normalize(s text) -> text``
    Restituisce una versione normalizzata della stringa di input *s*. L'output
    ha tutti gli spazi eliminati. La funzione non effettua alcun controllo sul
    contenuto della stringa.

``partita_iva_error(s text) -> text``
    Restituisce ``NULL`` se la stringa di input *s* contiene una Partita IVA
    valida, altrimenti restituisce una stringa con un messaggio di errore
    informativo. *s* dev'essere già normalizzata.
