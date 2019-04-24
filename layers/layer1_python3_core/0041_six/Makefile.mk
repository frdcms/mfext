include ../../../adm/root.mk
include ../../package.mk

export NAME=six
export VERSION=1.11.0
export EXTENSION=tar.gz
export CHECKTYPE=MD5
export CHECKSUM=d12789f9baf7e9fb2524c0c64f1773f8
DESCRIPTION=\
Six is a Python 2 and 3 compatibility library. It provides utility functions for smoothing \
over the differences between the Python versions with the goal of writing Python code \
that is compatible on both Python versions.
WEBSITE=https://pypi.python.org/pypi/six/
LICENSE=MIT

all:: $(PYTHON3_SITE_PACKAGES)/$(NAME)-$(VERSION)-py$(PYTHON3_SHORT_VERSION).egg/six.py
$(PYTHON3_SITE_PACKAGES)/$(NAME)-$(VERSION)-py$(PYTHON3_SHORT_VERSION).egg/six.py:
	$(MAKE) --file=../../Makefile.standard download uncompress python3build python3install
