#
# Copyright (C) 2022 Dengfeng Liu
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xfrpc
PKG_VERSION:=master
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/liudf0716/xfrpc/tar.gz/$(PKG_VERSION)?
PKG_HASH:=fec55cee9f7215d555c6fb2c53bf6ebccae64068edf5c8b2c310f46e25cbfff8
PKG_BUILD_DIR:=$(BUILD_DIR)/xfrpc-$(PKG_VERSION)

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/xfrpc
  SUBMENU:=Web Servers/Proxies
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+zlib +libjson-c +libevent2 +libevent2-openssl
  TITLE:= C language fast reverse proxy client
  URL:=https://github.com/liudf0716/xfrpc
endef

define Package/xfrpc/description
  xfrpc is C language fast reverse proxy client
  compare with golang version frpc
  xfrpc can run in almost all openwrt device
endef

define Package/xfrpc/conffiles
/etc/config/xfrpc
endef

define Package/xfrpc/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/xfrpc $(1)/usr/bin/xfrpc
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/xfrpc.init $(1)/etc/init.d/xfrpc
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./files/xfrpc.conf $(1)/etc/config/xfrpc
endef

$(eval $(call BuildPackage,xfrpc))
