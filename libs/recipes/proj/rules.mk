PROJ_VERSION = 9.2.0
PROJ_TARBALL = $(DOWNLOAD)/proj-$(PROJ_VERSION).tar.gz
PROJ_URL = https://github.com/OSGeo/PROJ/releases/download/$(PROJ_VERSION)/proj-$(PROJ_VERSION).tar.gz

.PHONY: proj
proj: $(PROJ_WASM_LIB)

$(PROJ_TARBALL):
	mkdir -p $(DOWNLOAD)
	wget -q -O $@ $(PROJ_URL)

# https://github.com/OSGeo/PROJ/blob/master/docs/source/install.rst

# Somehow `-DBUILD_APPS` doesn't work and we need to turn off each app
# individually.
$(PROJ_WASM_LIB): $(PROJ_TARBALL) $(SQLITE3_WASM_LIB) $(LIBTIFF_WASM_LIB)
	mkdir -p $(BUILD)/proj-$(PROJ_VERSION)/build
	tar -C $(BUILD) -xf $(PROJ_TARBALL)
	cd $(BUILD)/proj-$(PROJ_VERSION)/build && \
	  emcmake cmake \
	    -DCMAKE_BUILD_TYPE=Release \
	    -DCMAKE_CXX_FLAGS="$(CXXFLAGS)"' -UPROJ_DATA -DPROJ_DATA=\"/usr/share/proj\"' \
	    -DCMAKE_INSTALL_PREFIX:PATH="$(WASM)" \
	    -DSQLITE3_INCLUDE_DIR="$(WASM)/include" \
	    -DSQLITE3_LIBRARY="$(SQLITE3_WASM_LIB)" \
	    -DTIFF_INCLUDE_DIR="$(WASM)/include" \
	    -DTIFF_LIBRARY="$(LIBTIFF_WASM_LIB)" \
	    -DENABLE_CURL=OFF \
	    -DBUILD_APPS=OFF \
	    -DBUILD_CCT=OFF \
	    -DBUILD_CS2CS=OFF \
	    -DBUILD_GEOD=OFF \
	    -DBUILD_GIE=OFF \
	    -DBUILD_PROJ=OFF \
	    -DBUILD_PROJINFO=OFF \
	    -DBUILD_PROJSYNC=OFF \
	    -DBUILD_SHARED_LIBS=OFF \
	    -DBUILD_TESTING=OFF \
	    .. && \
	  emmake make install
