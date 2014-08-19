Italian Codes Extension
=======================

The extension contains validation domains for Italian fiscal codes, such as
*Codice Fiscale* and *Partita IVA*. See included documentation (in Italian_
and English_) for instructions about the extension objects and their usage.

.. _Italian: doc/codici_italiani.rst
.. _English: doc/italian_codes.rst


Installation
------------

The easiest way to install the extension is to use the `PGXN Client`__ and
run::

    pgxn install italian_codes
    pgxn load -d mydb italian_codes

.. __: http://pgxnclient.projects.postgresql.org/

To build from source, just do this::

    make
    make installcheck
    make install

Once italian_codes is installed, you can add it to a database. If you're
running PostgreSQL 9.1.0 or greater, it's as simple as connecting to a
database as a super user and running::

    CREATE EXTENSION italian_codes;

For versions of PostgreSQL less than 9.1.0, you'll need to run the
installation script::

    psql -d mydb -f /path/to/pgsql/share/contrib/italian_codes.sql


Copyright and License
---------------------

Copyright (c) 2011 Daniele Varrazzo <daniele.varrazzo@gmail.com>.

The package is released under BSD license. See ``COPYING`` for details.

