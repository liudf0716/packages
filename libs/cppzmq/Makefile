include $(TOPDIR)/rules.mk

PKG_NAME:=cppzmq
PKG_VERSION:=4.10.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/zeromq/cppzmq.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_MIRROR_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=OpenWrt Community

PKG_FIXUP:=cmake
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/cppzmq
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=Hailo
  TITLE:=cppzmq - C++ binding for ZeroMQ
  URL:=https://github.com/zeromq/cppzmq
  DEPENDS:=+libzmq-nc
  BUILDONLY:=1
endef

define Package/cppzmq/description
  Header-only C++ binding for libzmq.
  cppzmq provides a high-level C++11 wrapper for the ZeroMQ C API.
  This is a header-only library.
endef

CMAKE_OPTIONS += \
	-DCPPZMQ_BUILD_TESTS=OFF

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/zmq*.hpp $(1)/usr/include/
	
	$(INSTALL_DIR) $(1)/usr/share/cmake/cppzmq
	$(CP) $(PKG_INSTALL_DIR)/usr/share/cmake/cppzmq/* $(1)/usr/share/cmake/cppzmq/ 2>/dev/null || \
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/cmake/cppzmq/* $(1)/usr/share/cmake/cppzmq/ 2>/dev/null || true
endef

$(eval $(call BuildPackage,cppzmq))
