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
	install -pd "$(datadir)/gmusicbrowser/pix/gmb-art - awoken/"
	install -pd "$(datadir)/gmusicbrowser/pix/gmb-art - faenza/"
	install -pd "$(datadir)/gmusicbrowser/pix/gmb-art - faenza darkest/"
	install -pd "$(datadir)/gmusicbrowser/pix/gmb-art - elementary/"
	install -pd "$(datadir)/gmusicbrowser/layouts/"
	install -pd "$(datadir)/gmusicbrowser/layouts/gmb-art_skins/"
	install -pm 644 layouts/gmb-art*.layout  "$(datadir)/gmusicbrowser/layouts/"
	install -pm 644 layouts/gmb-art*.png  "$(datadir)/gmusicbrowser/layouts/"
	cp -rp layouts/gmb-art_skins/* "$(datadir)/gmusicbrowser/layouts/gmb-art_skins/"
	install -pm 644 icons/gmb-art\ -\ awoken/*.png    "$(datadir)/gmusicbrowser/pix/gmb-art - awoken/"
	install -pm 644 icons/gmb-art\ -\ faenza/*.png    "$(datadir)/gmusicbrowser/pix/gmb-art - faenza/"
	install -pm 644 icons/gmb-art\ -\ faenza darkest/*.png    "$(datadir)/gmusicbrowser/pix/gmb-art - faenza darkest/"	
	install -pm 644 icons/gmb-art\ -\ elementary/*.png    "$(datadir)/gmusicbrowser/pix/gmb-art - elementary/"

postinstall:

uninstall:
	rm -rf "$(datadir)/gmusicbrowser/layouts/gmb-art_skins"
	rm -rf "$(datadir)/gmusicbrowser/pix/gmb-art - awoken"
	rm -rf "$(datadir)/gmusicbrowser/pix/gmb-art - faenza"
	rm -rf "$(datadir)/gmusicbrowser/pix/gmb-art - faenza darkest"
	rm -rf "$(datadir)/gmusicbrowser/pix/gmb-art - elementary"
	rm -f $(datadir)/gmusicbrowser/layouts/gmb-art*

postuninstall:

prepackage :
	perl -pi -e 's!Version:.*!Version: '$(VERSION)'!' gmusicbrowser-art.spec
	mkdir -p dist/

dist: prepackage
	tar -czf dist/$(PACKAGE)-$(VERSION).tar.gz . --transform=s/^[.]/$(PACKAGE)-$(VERSION)/ --exclude=\*~ --exclude=.git\* --exclude=.\*swp --exclude=./dist && echo wrote dist/$(PACKAGE)-$(VERSION).tar.gz

# release : same as dist, but exclude debian/ folder
release: prepackage
	tar -czf dist/$(PACKAGE)-$(VERSION).tar.gz . --transform=s/^[.]/$(PACKAGE)-$(VERSION)/ --exclude=\*~ --exclude=.git\* --exclude=.\*swp --exclude=./dist --exclude=./debian && echo wrote dist/$(PACKAGE)-$(VERSION).tar.gz

