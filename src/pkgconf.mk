# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pkgconf
$(PKG)_WEBSITE  := https://github.com/pkgconf/pkgconf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := da179fd
$(PKG)_CHECKSUM := 91b2e5d7ce06583d5920c373b61d7d6554cd085cbd61ed176c7ff7ff3032523d
$(PKG)_GH_CONF  := pkgconf/pkgconf/branches/master
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package pkgconf.' >&2;
    echo $(pkgconf_VERSION)
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./autogen.sh
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        --build='$(BUILD)' \
        --target='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/pkgconf.exe' '$(PREFIX)/bin/$(TARGET)-pkg-config.exe'
endef

