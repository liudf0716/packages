include $(TOPDIR)/rules.mk

PKG_NAME:=hailort
PKG_VERSION:=4.23.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/hailo-ai/hailort.git
PKG_SOURCE_VERSION:=hailo8
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_MIRROR_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

PKG_FIXUP:=cmake
HOST_BUILD_DEPENDS:=ninja/host
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_SOURCE_SUBDIR:=.
CMAKE_BINARY_DIR:=$(PKG_BUILD_DIR)/build

define Package/hailort
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Hailo-8 Runtime library
  URL:=https://github.com/hailo-ai/hailort
  DEPENDS:=+libstdcpp +libpthread +zlib +libyaml +libusb-1.0
endef

define Package/hailort/description
Hailo-8 runtime user-space library for AI accelerator devices
endef

# Build options from HailoRT CMakeLists
CMAKE_OPTIONS += \
	-DENABLE_PCIE=ON \
	-DENABLE_EMBEDDED=ON \
	-DBUILD_SHARED=ON \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_TESTING=OFF \
	-DCMAKE_GENERATOR="Ninja"

# Override Build/Install to ensure DESTDIR is correct
define Build/Install
	DESTDIR="$(PKG_INSTALL_DIR)" $(NINJA) -C $(PKG_BUILD_DIR)/build install
endef

# Development files install (for building TAPPAS)
define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/hailo
	$(CP) -r $(PKG_INSTALL_DIR)/usr/include/hailo/* $(1)/usr/include/hailo/

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libhailort.so* $(1)/usr/lib/

	$(INSTALL_DIR) $(1)/usr/lib/cmake/HailoRT
	$(CP) -r $(PKG_INSTALL_DIR)/usr/lib/cmake/HailoRT/* $(1)/usr/lib/cmake/HailoRT/
endef

define Package/hailort/install
	# Libraries
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libhailort.so* $(1)/usr/lib/

	# CLI tool
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/hailortcli $(1)/usr/bin/

	# CMake configuration
	$(INSTALL_DIR) $(1)/usr/lib/cmake/HailoRT
	$(CP) -r $(PKG_INSTALL_DIR)/usr/lib/cmake/HailoRT/* $(1)/usr/lib/cmake/HailoRT/
endef

$(eval $(call BuildPackage,hailort))
