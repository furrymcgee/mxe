# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libiconv
$(PKG)_WEBSITE  := https://www.gnu.org/software/libiconv/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15
$(PKG)_CHECKSUM := ccf536620a45458d26ba83887a983b96827001e92a13847b45e4925cc8913178
$(PKG)_SUBDIR   := libiconv-$($(PKG)_VERSION)
$(PKG)_FILE     := libiconv-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/libiconv/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.gnu.org/software/libiconv/' | \
    grep 'libiconv-' | \
    $(SED) -n 's,.*libiconv-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's, sed , $(SED) ,g' '$(1)/windows/windres-options'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls
    $(MAKE) -C '$(1)/libcharset' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/lib'        -j '$(JOBS)' install
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/include/iconv.h.inst' '$(PREFIX)/$(TARGET)/include/iconv.h'

    # charset.alias is redundant on mingw and modern glibc systems
    rm -f '$(PREFIX)/$(TARGET)/lib/charset.alias'
endef

define $(PKG)_BUILD_NATIVE
    # build and install the library
    cd '$(SOURCE_DIR)' && autoreconf --install && \
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_DOCS)
endef

define $(PKG)_BUILD_DARWIN
    # required for glib but causes issues with other packages
    # (e.g. gcc) so use different prefix
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --prefix='$(PREFIX)/$(TARGET).gnu'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_DOCS)
endef

define $(PKG)_BUILD_$(BUILD)
    $(if $(findstring darwin, $(BUILD)), \
        $($(PKG)_BUILD_DARWIN), \
        $($(PKG)_BUILD_NATIVE))

    # charset.alias is redundant on mingw and modern glibc systems
    rm -f '$(PREFIX)/$(TARGET)/lib/charset.alias'
endef
