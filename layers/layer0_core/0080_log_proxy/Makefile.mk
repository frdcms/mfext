include ../../../adm/root.mk
include ../../package.mk

export NAME=log_proxy
export VERSION=0.0.2
export EXTENSION=tar.gz
export CHECKTYPE=MD5
export CHECKSUM=d587345bc9e79fc4f1ae1de7ef9282b9
DESCRIPTION=\
log_proxy is a tiny C utility for log rotation for apps that write their logs to stdout
WEBSITE=https://github.com/metwork-framework/log_proxy
LICENSE=BSD
ARCHIVE_FILE=$(NAME)-$(VERSION).$(EXTENSION)

all:: $(PREFIX)/bin/log_proxy

$(PREFIX)/bin/log_proxy: Makefile Makefile.mk sources
	rm -Rf build ; mkdir build
	cd build && ../../../_download_helper.sh $(ARCHIVE_FILE) ../sources $(CHECKTYPE) $(CHECKSUM)
	cd build && ../../../_uncompress_helper.sh $(ARCHIVE_FILE) $(EXTENSION)
	cd build/$(NAME)-$(VERSION) && make PREFIX=$(PREFIX) FORCE_RPATH=$(PREFIX)/lib
	cd build/$(NAME)-$(VERSION) && make PREFIX=$(PREFIX) install