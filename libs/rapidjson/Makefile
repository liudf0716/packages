include $(TOPDIR)/rules.mk

PKG_NAME:=rapidjson
PKG_VERSION:=1.1.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Tencent/rapidjson.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_MIRROR_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=license.txt
PKG_MAINTAINER:=OpenWrt Community

PKG_FIXUP:=cmake
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/rapidjson
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=Hailo
  TITLE:=rapidjson - Fast JSON parser/generator for C++
  URL:=https://github.com/Tencent/rapidjson
  BUILDONLY:=1
endef

define Package/rapidjson/description
  RapidJSON is a fast JSON parser/generator for C++ with both SAX/DOM style API.
  Features:
   - Fast: High performance parsing and generation
   - Memory-friendly: Compact data structures
   - Header-only: No linking required
   - Standards compliant: Fully supports JSON standard
  This is a header-only library.
endef

CMAKE_OPTIONS += \
	-DRAPIDJSON_BUILD_DOC=OFF \
	-DRAPIDJSON_BUILD_EXAMPLES=OFF \
	-DRAPIDJSON_BUILD_TESTS=OFF \
	-DRAPIDJSON_BUILD_CXX11=ON

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/rapidjson $(1)/usr/include/
	
	$(INSTALL_DIR) $(1)/usr/lib/cmake/RapidJSON
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/cmake/RapidJSON/* $(1)/usr/lib/cmake/RapidJSON/ 2>/dev/null || \
	$(CP) $(PKG_INSTALL_DIR)/usr/share/cmake/RapidJSON/* $(1)/usr/lib/cmake/RapidJSON/ 2>/dev/null || true
	
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/RapidJSON.pc $(1)/usr/lib/pkgconfig/ 2>/dev/null || \
	$(CP) $(PKG_INSTALL_DIR)/usr/share/pkgconfig/RapidJSON.pc $(1)/usr/lib/pkgconfig/ 2>/dev/null || true
endef

$(eval $(call BuildPackage,rapidjson))
