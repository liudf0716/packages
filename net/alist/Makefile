#
# Copyright (C) 2015-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=alist
PKG_VERSION:=3.18.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING



include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)/Default
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=Web Servers/Proxies
	TITLE:=Alist - Main program
	URL:=https://alist-doc.nn.ci/
endef

define Package/$(PKG_NAME)/description
  A file list program that supports multiple storage
endef

define Package/$(PKG_NAME)
	$(call Package/alist/Default)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
ifeq ($(ARCH),arm)
	$(INSTALL_BIN) ./files/alist-linux-musl-arm $(1)/usr/bin/alist
else
	$(INSTALL_BIN) ./files/alist-linux-musl-amd64 $(1)/usr/bin/alist
endif
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/alist.init $(1)/etc/init.d/alist
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./files/alist.conf $(1)/etc/config/alist
	$(INSTALL_DIR) $(1)/etc/hotplug.d/block
	$(INSTALL_BIN) ./files/10-mount $(1)/etc/hotplug.d/block/10-mount
	$(INSTALL_DIR) $(1)/etc/alist
	$(CP) ./files/data.db $(1)/etc/alist/data.db
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
