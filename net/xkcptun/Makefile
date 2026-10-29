#
# Copyright (C) 2026 Dengfeng Liu <liudf0716@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xkcptun
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/liudf0716/xkcptun.git
PKG_SOURCE_DATE:=2026-10-25
PKG_SOURCE_VERSION:=e5ec5ed74a20a75e9c3b22221d7f07346ffa0d1e
PKG_MIRROR_HASH:=babd55383b6a5f7b6dbef7364cbf16a0afd584afd1bb20703a15f6261e552550

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/xkcptun
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=KCP-based Secure Tunnel in C
  URL:=https://github.com/liudf0716/xkcptun
  DEPENDS:=+libevent2
endef

define Package/xkcptun/description
  xkcptun is a lightweight and high-performance C language implementation of kcptun.
  This package contains the client and server binaries as well as the
  xkcp_spy monitoring tool.
endef

define Package/xkcptun/conffiles
/etc/config/xkcptun
endef

CMAKE_OPTIONS += \
	-DAUTO_INSTALL_DEPS=OFF

define Package/xkcptun/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/xkcp_client $(1)/usr/bin/xkcp_client
	$(LN) xkcp_client $(1)/usr/bin/xkcptun-client
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/xkcp_server $(1)/usr/bin/xkcp_server
	$(LN) xkcp_server $(1)/usr/bin/xkcptun-server
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/xkcp_spy $(1)/usr/bin/xkcp_spy
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/xkcptun.config $(1)/etc/config/xkcptun
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/xkcptun.init $(1)/etc/init.d/xkcptun
endef

$(eval $(call BuildPackage,xkcptun))
