#
# Copyright (C) 2026 Dengfeng Liu <liudf0716@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xdns-bpf
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/liudf0716/$(PKG_NAME)/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=13e876239dc9c2cfd123a75ed29aaefc6b0a61b6fd6e09d1e61d92c14ebe898e
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=bpf-headers

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk
include $(INCLUDE_DIR)/bpf.mk

define Package/xdns-bpf
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Routing and Redirection
  TITLE:=eBPF DNS Interception and Transparent Traffic Redirection
  DEPENDS:=+libbpf +tc-full $(BPF_DEPENDS)
  URL:=https://github.com/liudf0716/xdns-bpf
endef

define Package/xdns-bpf/description
  xdns-bpf provides kernel-level DNS interception, dynamic IP learning, and transparent
  TCP redirection using eBPF TC classifier for high-speed encrypted tunnels.
endef

define Package/xdns-bpf/conffiles
/etc/config/xdns
/etc/xdns/whitelist.txt
endef

define Build/Compile
	$(call Build/Compile/Default)
	$(call CompileBPF,$(PKG_BUILD_DIR)/src/xdns_bpf.c)
endef

define Package/xdns-bpf/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/xdns-ctl $(1)/usr/bin/xdns-ctl

	$(INSTALL_DIR) $(1)/usr/lib/bpf
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/src/xdns_bpf.o $(1)/usr/lib/bpf/xdns_bpf.o

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/xdns.config $(1)/etc/config/xdns

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/xdns.init $(1)/etc/init.d/xdns

	$(INSTALL_DIR) $(1)/etc/xdns
	$(INSTALL_DATA) ./files/whitelist.txt $(1)/etc/xdns/whitelist.txt
endef

$(eval $(call BuildPackage,xdns-bpf))
