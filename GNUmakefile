.DEFAULT_GOAL  := qt5

%:
	MXE_COMPILE=ccache \
	MXE_LINK=ccache \
	MXE_TARGETS=i686-w64-mingw32.static \
	PATH="$(PATH):$(PWD)/usr/bin" \
	$(MAKE) $@ \
		--debug=b \
		--file=Makefile \
		--no-builtin-variable \
		--no-builtin-rules
