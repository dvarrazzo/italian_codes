italian_codes
=============

The package contains validation domains for Italian codes, such as Codice
Fiscale and Partita IVA.

The best way to install the extension is to use the `PGXN Client`__ and run::

    pgxn install italian_codes
    pgxn load -d mydb italian_codes

.. __: pgxnclient.projects.postgresql.org

To build from source, just do this:

    make
    make installcheck
    make install

Once italian_codes is installed, you can add it to a database. If you're
running PostgreSQL 9.1.0 or greater, it's as simple as connecting to a
database as a super user and running:

    CREATE EXTENSION italian_codes;

For versions of PostgreSQL less than 9.1.0, you'll need to run the
installation script:

    psql -d mydb -f /path/to/pgsql/share/contrib/italian_codes.sql


Dependencies
------------

The ``italian_codes`` data type has no dependencies other than PostgreSQL.


Copyright and License
---------------------

Copyright (c) 2011 Daniele Varrazzo <daniele.varrazzo@gmail.com>.

The package is released under BSD license. See ``COPYING`` for details.

