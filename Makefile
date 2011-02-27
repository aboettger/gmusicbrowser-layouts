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

all: locale
clean:
	rm -rf dist/
distclean: clean
	rm -rf locale/

po/gmusicbrowser-art.pot : layouts/*.layout
	perl po/create_pot.pl --quiet

po/%.po : po/gmusicbrowser.pot
	msgmerge -s -U -N $@ po/gmusicbrowser.pot

locale/%/LC_MESSAGES/gmusicbrowser-art.mo : po/%.po po/gmusicbrowser-art.pot
	mkdir -p locale/$*/LC_MESSAGES/
	msgfmt --statistics -c -o $@ $<

locale: $(foreach l,$(LINGUAS),locale/$l/LC_MESSAGES/gmusicbrowser-art.mo)


install: all
	install -pd "$(datadir)/gmusicbrowser/pix/awoken/"
	install -pd "$(datadir)/gmusicbrowser/layouts/"
	install -pm 644 layouts/*.layout  "$(datadir)/gmusicbrowser/layouts/"
	install -pm 644 icons/awoken/*.png    "$(datadir)/gmusicbrowser/pix/awoken/"
	for lang in $(LINGUAS) ; \
	do \
		install -pd "$(localedir)/$$lang/LC_MESSAGES/"; \
		install -pm 644 locale/$$lang/LC_MESSAGES/gmusicbrowser-art.mo	"$(localedir)/$$lang/LC_MESSAGES/"; \
	done

postinstall:

uninstall:
	rm -rf "$(datadir)/gmusicbrowser/layouts" "$(docdir)"
	rm -f "$(localedir)/*/LC_MESSAGES/gmusicbrowser-art.mo"

postuninstall:
	#clean_menus
	update-menus

prepackage : all
	perl -pi -e 's!Version:.*!Version: '$(VERSION)'!' gmusicbrowser-art.spec
	mkdir -p dist/

dist: prepackage
	tar -czf dist/$(PACKAGE)-$(VERSION).tar.gz . --transform=s/^[.]/$(PACKAGE)-$(VERSION)/ --exclude=\*~ --exclude=.git\* --exclude=.\*swp --exclude=./dist && echo wrote dist/$(PACKAGE)-$(VERSION).tar.gz

# release : same as dist, but exclude debian/ folder
release: prepackage
	tar -czf dist/$(PACKAGE)-$(VERSION).tar.gz . --transform=s/^[.]/$(PACKAGE)-$(VERSION)/ --exclude=\*~ --exclude=.git\* --exclude=.\*swp --exclude=./dist --exclude=./debian && echo wrote dist/$(PACKAGE)-$(VERSION).tar.gz

