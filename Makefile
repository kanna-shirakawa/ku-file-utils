# based on KU packages template 1.3 (2012/10)

# default, preprocess control files
#
controls:
	ku/install.sh make_controls

build: build_man

install: build
	DESTDIR=$(DESTDIR) ku/install.sh

clean:
	rm -rf $(DESTDIR)

doc:

mrproper: clean clean_controls

clean_controls:
	for file in `ls debian.in 2>/dev/null`; do rm -f debian/$$file; done
	for file in `ls fedora.in 2>/dev/null`; do rm -f fedora/$$file; done


# custom builds

build_man: man1/ftpsync.1.gz

man1/ftpsync.1.gz: bin/ftpsync
	pod2man bin/ftpsync >man1/ftpsync.1
	rm-f man1/ftpsync.1.gz; gzip man1/ftpsync.1
