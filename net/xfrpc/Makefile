#
# Copyright (C) 2022 Dengfeng Liu
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xfrpc
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/liudf0716/xfrpc.git
PKG_SOURCE_DATE:=2026-11-25
PKG_SOURCE_VERSION:=5330aafc8c5f11d5bc387849d25e0a3a361b5886
PKG_MIRROR_HASH:=8f3fc4b3238d6063b44274fec76417d259a229d5675a6c8bc0963957a7513654

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
