build:
	echo "Nothing to build."

install: 
	echo "Installing to ${DESTDIR}"
	mkdir -p ${DESTDIR}/etc/profile.d/../../opt/plenv
	rsync -a bash-profile/* ${DESTDIR}/etc/profile.d
	rsync -a bin libexec plenv.d completions ${DESTDIR}/opt/plenv

list-targets-dummy: ;#No opt
list-targets:
	make -rqp list-targets-dummy | grep -v '^# ' | grep -v '^[[:space:]]' | grep --only-matching '^.*:' | grep -v '\.' | grep -v '%' | grep -v 'list-targets-dummy' | egrep --color '^[^ ]*:'

build-deb-package:
	PACKAGE_NAME=$( grep 'Package:' debian/control | cut -d ':' -f 2 | tr -d ' ' )
	VERSION=$(grep $PACKAGE_NAME debian/changelog | head -n 1 | perl -pE '/\(([0-9.-]+)-\d+\)/; $_=$1')
	tar -zcvf ../${PACKAGE_NAME}_${VERSION}.orig.tar.gz --exclude=.git --exclude='.*.swp' .
	debuild -us -uc

/opt/plenv/plugins/perl-build:
	sudo git clone git://github.com/tokuhirom/Perl-Build.git /opt/plenv/plugins/perl-build
	sudo sh -l -c 'plenv rehash'	

install-perl-build: /opt/plenv/plugins/perl-build

copy-from-rbenv:
	bash ./author/copy-from-rbenv.sh

