PACKAGE = gmusicbrowser-art
VERSION = $(shell git tag)


prefix		= usr
bindir 		= ${DESTDIR}/${prefix}/bin
appdir		= ${DESTDIR}/${prefix}/share/applications
datadir		= ${DESTDIR}/${prefix}/share
mandir		= ${DESTDIR}/${prefix}/share/man
docdir		= ${DESTDIR}/${prefix}/share/doc/$(PACKAGE)-${VERSION}
localedir	= ${DESTDIR}/${prefix}/share/locale
menudir		= ${DESTDIR}/${prefix}/lib/menu
iconsdir	= ${DESTDIR}/${prefix}/share/icons
liconsdir	= $(iconsdir)/large
miconsdir	= $(iconsdir)/mini

DOCS=AUTHORS COPYING README NEWS INSTALL layout_doc.html
LINGUAS=$(shell for l in po/*po; do basename $$l .po; done)

clean:
	rm -rf dist/
distclean: clean
	rm -rf locale/

install:
	install -pd "$(datadir)/gmusicbrowser/pix/awoken/"
	install -pd "$(datadir)/gmusicbrowser/layouts-orig/"
	install -pd "$(datadir)/gmusicbrowser/layouts/"
	mv "$(datadir)/gmusicbrowser/layouts/" "$(datadir)/gmusicbrowser/layouts-orig/"
	install -pd "$(datadir)/gmusicbrowser/layouts/"
	install -pd "$(datadir)/gmusicbrowser/layouts/skins/"
	install -pm 644 layouts/*.layout  "$(datadir)/gmusicbrowser/layouts/"
	cp -rp layouts/skins/* "$(datadir)/gmusicbrowser/layouts/skins/"
	install -pm 644 icons/awoken/*.png    "$(datadir)/gmusicbrowser/pix/awoken/"

postinstall:

uninstall:
	rm -rf "$(datadir)/gmusicbrowser/layouts"
	rm -rf "$(datadir)/gmusicbrowser/layouts/skins"
	rm -rf "$(datadir)/gmusicbrowser/pix/awoken"
	mv "$(datadir)/gmusicbrowser/layouts-orig/layouts" "$(datadir)/gmusicbrowser/"

postuninstall:

prepackage :
	perl -pi -e 's!Version:.*!Version: '$(VERSION)'!' gmusicbrowser-art.spec
	mkdir -p dist/

dist: prepackage
	tar -czf dist/$(PACKAGE)-$(VERSION).tar.gz . --transform=s/^[.]/$(PACKAGE)-$(VERSION)/ --exclude=\*~ --exclude=.git\* --exclude=.\*swp --exclude=./dist && echo wrote dist/$(PACKAGE)-$(VERSION).tar.gz

# release : same as dist, but exclude debian/ folder
release: prepackage
	tar -czf dist/$(PACKAGE)-$(VERSION).tar.gz . --transform=s/^[.]/$(PACKAGE)-$(VERSION)/ --exclude=\*~ --exclude=.git\* --exclude=.\*swp --exclude=./dist --exclude=./debian && echo wrote dist/$(PACKAGE)-$(VERSION).tar.gz

