include ../../../adm/root.mk
include ../../package.mk

export NAME=openresty
export VERSION=1.13.6.2
export EXTENSION=tar.gz
export CHECKTYPE=MD5
export CHECKSUM=d95bc4bbe15e4b045a0593b4ecc0db38
DESCRIPTION=\
OPENRESTY est une distribution nginx qui ajoute des modules supplémentaires
WEBSITE=http://openresty.org
LICENSE=BSD
PCRE_SOURCE_PATH=$(LAYER_DIR)/pcre/build/pcre-8.36

all:: $(PREFIX)/bin/resty
$(PREFIX)/bin/resty: $(PCRE_SOURCE_PATH)
	$(MAKE) --file=../../Makefile.standard PREFIX=$(PREFIX) OPTIONS="--with-pcre=$(PCRE_SOURCE_PATH) --without-lua_resty_memcached --without-lua_resty_mysql --without-http_scgi_module --without-http_uwsgi_module --http-fastcgi-temp-path=/tmp --without-http_ssi_module --with-http_dav_module --with-http_sub_module --with-http_realip_module --with-http_stub_status_module --http-client-body-temp-path=/tmp/nginx_clientbody_temp --http-proxy-temp-path=/tmp/nginx_proxy_temp --with-threads" download uncompress configure build install
	if ! test -d $(PREFIX)/config; then mkdir -p $(PREFIX)/config; fi
	rm -f $(PREFIX)/config/mime.types && ln -s $(PREFIX)/nginx/conf/mime.types $(PREFIX)/config/mime.types

$(PCRE_SOURCE_PATH):
	cd ../pcre ; make downloadonly

clean::
	cd ../pcre ; make clean
