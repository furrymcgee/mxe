# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sfml
$(PKG)_WEBSITE  := https://www.sfml-dev.org/
$(PKG)_DESCR    := SFML
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.2
$(PKG)_CHECKSUM := 8ba04f6fde6a7b42527d69742c49da2ac529354f71f553409f9f821d618de4b6
$(PKG)_SUBDIR   := SFML-$($(PKG)_VERSION)
$(PKG)_FILE     := SFML-$($(PKG)_VERSION)-sources.zip
$(PKG)_URL      := https://sfml-dev.org/download/sfml/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glew jpeg libsndfile openal

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.sfml-dev.org/download.php' | \
    $(SED) -n 's,.*download/sfml/\([^"]\+\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' .. \
        -DSFML_BUILD_EXAMPLES=FALSE \
        -DSFML_BUILD_DOC=FALSE \
        -DSFML_INSTALL_PKGCONFIG_FILES=TRUE 

    # build and install libs
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1
    
    # build a sfml test program
    '$(PREFIX)/bin/$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sfml.exe' \
        `$(PREFIX)/bin/$(TARGET)-pkg-config --cflags --libs sfml-all` -lgdi32 -lws2_32 -lwinmm
endef

$(PKG)_BUILD_SHARED =
