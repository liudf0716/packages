#
# Copyright (C) 2018 Dengfeng Liu
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=x-portal
PKG_VERSION:=main
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://liudf0716: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@github.com/liudf0716/WrtPortal.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_MIRROR_HASH:=97f46a3f9a144546705846a8d39d7d581f761d6d10b1598f9210d907e92d30e4

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/x-portal
  SUBMENU:=Captive Portals
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+zlib +ipset +iptables +libip4tc +libevent2 +libuci
  TITLE:=captive portal without auth
  URL:=https://github.com/liudf0716/WrtPortal
endef

define Package/x-portal/description
  captive portal without auth
  only show portal page when user connect wifi
endef

define Package/x-portal/conffiles
/etc/config/xportal
endef

define Package/x-portal/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/x-portal $(1)/usr/bin/x-portal
endef

$(eval $(call BuildPackage,x-portal))
