#
# Copyright (C) 2026 Dengfeng Liu <liudf0716@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xdns-bpf
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/liudf0716/xdns-bpf.git
PKG_SOURCE_DATE:=2026-11-15
PKG_SOURCE_VERSION:=1d43296870ce7186ca87dcb2bb003b47fe90737f
PKG_MIRROR_HASH:=b4ca54e96de85a7cfcd4f4dfd9d04121acc9beae045b9200ec29f6a63d2fe7c8

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
/etc/xdns/proxy_domains.txt
/etc/xdns/static_ips.txt
endef

define Build/Compile
	$(call Build/Compile/Default)
	$(call CompileBPF,$(PKG_BUILD_DIR)/src/xdns_bpf.c,-DXDNS_MODE_GATEWAY=1)
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
	$(INSTALL_DATA) ./files/proxy_domains.txt $(1)/etc/xdns/proxy_domains.txt
	$(INSTALL_DATA) ./files/static_ips.txt $(1)/etc/xdns/static_ips.txt
endef

$(eval $(call BuildPackage,xdns-bpf))
