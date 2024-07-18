#
# Copyright (C) 2022 Dengfeng Liu
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=bypass
PKG_VERSION:=0.1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/bypass
  SECTION:=net
  CATEGORY:=Network
  TITLE:= Enable bypass mode of the device
  DEPENDS:=+apfree-wifidog
endef

define Package/bypass/description
  Enable bypass mode of the device
endef

define Build/Compile
endef


define Package/bypass/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/bypass.defaults.nftables $(1)/etc/uci-defaults/99-bypass-nftables
endef

$(eval $(call BuildPackage,bypass))
