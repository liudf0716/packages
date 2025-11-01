include $(TOPDIR)/rules.mk

PKG_NAME:=xtl
PKG_VERSION:=0.7.7
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/xtensor-stack/xtl.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_MIRROR_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=OpenWrt Community

PKG_FIXUP:=cmake
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/xtl
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=xtl - Basic tools (containers, algorithms) used by xtensor
  URL:=https://github.com/xtensor-stack/xtl
  BUILDONLY:=1
endef

define Package/xtl/description
  xtl is a C++ library providing basic tools for xtensor (containers, algorithms).
  This is a header-only library.
endef

CMAKE_OPTIONS += \
	-DBUILD_TESTS=OFF

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/xtl $(1)/usr/include/
	
	$(INSTALL_DIR) $(1)/usr/lib/cmake/xtl
	$(CP) $(PKG_INSTALL_DIR)/usr/share/cmake/xtl/* $(1)/usr/lib/cmake/xtl/
	
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/share/pkgconfig/xtl.pc $(1)/usr/lib/pkgconfig/
endef

$(eval $(call BuildPackage,xtl))
