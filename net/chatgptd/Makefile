#
# Copyright (C) 2022 Dengfeng Liu
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=chatgptd
PKG_VERSION:=0.2.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/chatgptd
  SUBMENU:=Web Servers/Proxies
  SECTION:=net
  CATEGORY:=Network
  TITLE:= Chatgpt Tunnel client
endef

define Package/chatgptd/description
  Chatgpt Tunnel is a tunneling daemon 
  that proxies traffic from the openai.com 
  to permit access to the chatgpt service.
endef

define Build/Compile
endef

define Package/chatgptd/conffiles
/etc/config/chatgptd
endef

define Package/chatgptd/install
	$(INSTALL_DIR) $(1)/usr/bin
ifeq ($(ARCH),arm)
	$(INSTALL_BIN) ./files/chatgptd_linux_arm7 $(1)/usr/bin/chatgptd
else
	$(INSTALL_BIN) ./files/chatgptd_linux_amd64 $(1)/usr/bin/chatgptd
endif
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/chatgptd.init $(1)/etc/init.d/chatgptd
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./files/chatgptd.conf $(1)/etc/config/chatgptd
endef

$(eval $(call BuildPackage,chatgptd))
