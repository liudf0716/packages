#
# Copyright (C) 2025 Dengfeng Liu
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xkcptun
PKG_VERSION:=master
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/liudf0716/xkcptun/tar.gz/$(PKG_VERSION)?
PKG_HASH:=skip
PKG_BUILD_DIR:=$(BUILD_DIR)/xkcptun-$(PKG_VERSION)

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/xkcptun
  SUBMENU:=Web Servers/Proxies
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libevent2
  TITLE:=C language fast kcp tunnel
  URL:=https://github.com/liudf0716/xkcptun
endef

define Package/xkcptun/description
  xkcptun is C language fast kcp tunnel
  compare with golang version kcptun
  xkcptun can run in almost all openwrt device
endef

define Package/xkcptun/conffiles
/etc/config/xkcptun
endef

define Package/xkcptun/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/xkcp_client $(1)/usr/bin/xkcp_client
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/xkcptun.init $(1)/etc/init.d/xkcptun
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./files/xkcptun.conf $(1)/etc/config/xkcptun
endef

$(eval $(call BuildPackage,xkcptun))
