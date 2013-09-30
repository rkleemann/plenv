build:
	echo "Nothing to build."

install: 
	echo "Installing to ${DESTDIR}"
	mkdir -p ${DESTDIR}/etc/profile.d/../../opt/plenv
	rsync -a bash-profile/* ${DESTDIR}/etc/profile.d
	rsync -a bin libexec plenv.d completions ${DESTDIR}/opt/plenv

copy-from-rbenv:
	bash ./author/copy-from-rbenv.sh

