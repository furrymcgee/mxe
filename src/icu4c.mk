# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := icu4c
$(PKG)_WEBSITE  := http://site.icu-project.org/
$(PKG)_DESCR    := ICU4C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 56.1
$(PKG)_MAJOR    := $(word 1,$(subst ., ,$($(PKG)_VERSION)))
$(PKG)_CHECKSUM := 3a64e9105c734dcf631c0b3ed60404531bce6c0f5a64bfe1a6402a4cc2314816
$(PKG)_SUBDIR   := icu
$(PKG)_FILE     := $(PKG)-$(subst .,_,$($(PKG)_VERSION))-src.tgz
$(PKG)_URL      := http://download.icu-project.org/files/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    pwd
    stat $(1)/source/configure.ac
    cd $(1)/source
    pwd
    stat configure.ac || exit 1
    autoreconf -fi
    mkdir $(1).cross
    cd $(1).cross
    $(1)/source/configure --cache-file=/tmp/config.cache $(MXE_CONFIGURE_OPTS)
    $(MAKE) -j $(JOBS) install
endef
