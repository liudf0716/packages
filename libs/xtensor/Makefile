include $(TOPDIR)/rules.mk

PKG_NAME:=xtensor
PKG_VERSION:=0.25.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/xtensor-stack/xtensor.git
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

define Package/xtensor
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=xtensor - C++ tensors with broadcasting and lazy computing
  URL:=https://github.com/xtensor-stack/xtensor
  DEPENDS:=+xtl
  BUILDONLY:=1
endef

define Package/xtensor/description
  xtensor is a C++ library meant for numerical analysis with multi-dimensional 
  array expressions.
  xtensor provides:
   - an extensible expression system enabling lazy broadcasting.
   - an API following the idioms of the C++ standard library.
   - tools to manipulate array expressions and build upon xtensor.
  This is a header-only library.
endef

CMAKE_OPTIONS += \
	-DBUILD_TESTS=OFF \
	-DBUILD_BENCHMARK=OFF \
	-DDOWNLOAD_GTEST=OFF \
	-DDOWNLOAD_GBENCHMARK=OFF \
	-DXTENSOR_USE_XSIMD=OFF

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/xtensor $(1)/usr/include/
	
	$(INSTALL_DIR) $(1)/usr/lib/cmake/xtensor
	$(CP) $(PKG_INSTALL_DIR)/usr/share/cmake/xtensor/* $(1)/usr/lib/cmake/xtensor/
	
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/share/pkgconfig/xtensor.pc $(1)/usr/lib/pkgconfig/
endef

$(eval $(call BuildPackage,xtensor))
