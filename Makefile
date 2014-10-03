DUMMY_VERSION = $(PWD)/versions/dummy

PLENV_ROOT := $(PWD)
PATH := $(PWD)/bin:$(PATH)
SHELL := /bin/bash
export PLENV_ROOT PATH SHELL

PACKAGE_NAME := $(shell cat debian/control | grep 'Package:' | cut -d ':' -f 2 | tr -d ' ' )
VERSION := $(shell cat debian/changelog | grep $(PACKAGE_NAME) | head -n 1 | perl -pe '/\(([0-9.-]+)-\d+\)/; $$_=$$1')

build:
	@echo "Nothing to build. $(PACKAGE_NAME) -- $(VERSION) "

install: 
	echo "Installing to ${DESTDIR}"
	mkdir -p ${DESTDIR}/etc/profile.d/../../opt/plenv
	rsync -a bash-profile/ ${DESTDIR}/etc/profile.d/
	rsync -a bin completions libexec plenv.d ${DESTDIR}/opt/plenv

list-targets-dummy: ;#No opt
list-targets:
	make -rqp list-targets-dummy | grep -v '^# ' | grep -v '^[[:space:]]' | grep --only-matching '^.*:' | grep -v '\.' | grep -v '%' | grep -v 'list-targets-dummy' | egrep --color '^[^ ]*:'


build-deb-package:
	@echo "Building $(PACKAGE_NAME)_$(VERSION).orig.tar.gz"
	@echo "Clear out tools dir"
	rm -rf debian/tools/plenv-perl*
	tar -zcvf ../$(PACKAGE_NAME)_$(VERSION).orig.tar.gz --exclude=.git --exclude='.*.swp' --exclude=debian .
	debuild -us -uc

/opt/plenv/plugins/perl-build:
	git clone git://github.com/tokuhirom/Perl-Build.git /opt/plenv/plugins/perl-build
	sh -l -c 'plenv rehash'

install-perl-build: /opt/plenv/plugins/perl-build

copy-from-rbenv:
	bash ./author/copy-from-rbenv.sh

run_test: ext/test-simple-bash shims/perl _force
	( eval "$$(plenv init -)"; eval prove -v test/ )

ext/test-simple-bash:
	git clone https://github.com/ingydotnet/test-simple-bash.git $@

shims/perl:
	mkdir -p $(DUMMY_VERSION)/bin
	touch $(DUMMY_VERSION)/bin/perl
	( eval "$$(plenv init -)"; plenv rehash )
	rm -fr $(DUMMY_VERSION)
	[ -e $@ ] || exit 1

_force:
