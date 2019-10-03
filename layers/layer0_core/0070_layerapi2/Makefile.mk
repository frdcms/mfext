include ../../../adm/root.mk
include ../../package.mk

export NAME=layerapi2
export VERSION=0.0.3
export EXTENSION=tar.gz
export CHECKTYPE=MD5
export CHECKSUM=3f0b6685a4ddde45136de50e61581e9f
DESCRIPTION=\
layerapi2 lib
WEBSITE=https://github.com/metwork-framework/layerapi2
LICENSE=BSD
ARCHIVE_FILE=$(NAME)-$(VERSION).$(EXTENSION)

all:: $(PREFIX)/bin/layer_wrapper $(PREFIX)/bin/bootstrap_layer.sh

$(PREFIX)/bin/bootstrap_layer.sh: bootstrap_layer.sh
	cp -f $< $@
	chmod +x $@

$(PREFIX)/bin/layer_wrapper: Makefile Makefile.mk sources
	rm -Rf build ; mkdir build
	cd build && ../../../_download_helper.sh $(ARCHIVE_FILE) ../sources $(CHECKTYPE) $(CHECKSUM)
	cd build && ../../../_uncompress_helper.sh $(ARCHIVE_FILE) $(EXTENSION)
	cd build/$(NAME)-$(VERSION) && make PREFIX=$(PREFIX) FORCE_RPATH=$(PREFIX)/lib
	cd build/$(NAME)-$(VERSION) && make PREFIX=$(PREFIX) install
