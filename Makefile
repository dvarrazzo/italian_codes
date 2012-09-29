#
# italian_codes -- extension makefile
#
# Copyright (C) 2011 Daniele Varrazzo <daniele.varrazzo@gmail.com>
#

EXTENSION    = italian_codes
EXTVERSION   = $(shell grep default_version $(EXTENSION).control | sed -e "s/default_version[[:space:]]*=[[:space:]]*'\([^']*\)'/\1/")
EXT_LONGVER  = $(shell grep '"version":' META.json | head -1 | sed -e 's/\s*"version":\s*"\(.*\)",/\1/')

SQL          = $(filter-out $(wildcard sql/*--*.sql),$(wildcard sql/*.sql))
DOCS         = $(wildcard doc/*.rst)
TESTS        = $(wildcard test/sql/*.sql)
TESTS_OUT    = $(wildcard test/expected/*.out)
REGRESS      = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test --load-language=plpgsql
PG_CONFIG    = pg_config
PG91         = $(shell $(PG_CONFIG) --version | grep -qE " 8\.| 9\.0" && echo no || echo yes)

PKGFILES = COPYING README.rst Makefile \
	META.json $(EXTENSION).control \
	$(SQL) $(DOCS) $(TESTS) $(TESTS_OUT)

PKGNAME = $(EXTENSION)-$(EXT_LONGVER)
SRCPKG = $(SRCPKG_TGZ) $(SRCPKG_ZIP)
SRCPKG_TGZ = dist/$(PKGNAME).tar.gz
SRCPKG_ZIP = dist/$(PKGNAME).zip

ifeq ($(PG91),yes)
all: sql/$(EXTENSION)--$(EXTVERSION).sql

sql/$(EXTENSION)--$(EXTVERSION).sql: sql/$(EXTENSION).sql
	cp $< $@

DATA = $(wildcard sql/*--*.sql) sql/$(EXTENSION)--$(EXTVERSION).sql
EXTRA_CLEAN = sql/$(EXTENSION)--$(EXTVERSION).sql
else
DATA = sql/$(EXTENSION).sql sql/uninstall_$(EXTENSION).sql
endif

PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

sdist: $(SRCPKG)

$(SRCPKG): $(PKGFILES)
	ln -sf . $(PKGNAME)
	mkdir -p dist
	rm -f $(SRCPKG_TGZ)
	tar czvf $(SRCPKG_TGZ) $(addprefix $(PKGNAME)/,$^)
	rm -f $(SRCPKG_ZIP)
	zip -r $(SRCPKG_ZIP) $(addprefix $(PKGNAME)/,$^)
	rm $(PKGNAME)

