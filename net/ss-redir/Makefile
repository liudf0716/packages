#
# Copyright (C) 2022 Dengfeng Liu
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ss-redir
PKG_VERSION:=0.1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/ss-redir
  SUBMENU:=Web Servers/Proxies
  SECTION:=net
  CATEGORY:=Network
  TITLE:= simplify ss-redir usage
  DEPENDS:=+shadowsocks-libev-ss-redir
endef

define Package/ss-redir/description
  simplify ss-redir usage
endef

define Build/Compile
endef

define Package/ss-redir/conffiles
/etc/config/ss-redir
endef

define Package/ss-redir/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/ss-redir.init $(1)/etc/init.d/ss-redir
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./files/ss-redir.conf $(1)/etc/config/ss-redir
endef

$(eval $(call BuildPackage,ss-redir))
