# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2025 Dengfeng Liu <liudf0716@gmail.com>
#

include $(TOPDIR)/rules.mk

PKG_NAME:=go-shadowsocks2
PKG_VERSION:=0.1.5
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/shadowsocks/go-shadowsocks2/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=skip

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/shadowsocks/go-shadowsocks2
GO_PKG_BUILD_PKG:=$(GO_PKG)

include $(INCLUDE_DIR)/package.mk
include ../../lang/golang/golang-package.mk

define Package/go-shadowsocks2
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=Modern Shadowsocks in Go
  URL:=https://github.com/shadowsocks/go-shadowsocks2
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/go-shadowsocks2/description
  A fresh implementation of Shadowsocks in Go.
  
  Features:
  - SOCKS5 proxy
  - Support for Netfilter TCP redirect (IPv6 support)
  - UDP tunneling (e.g. relay DNS!)
  - TCP tunneling (e.g. benchmark with iperf3!)
endef

define Package/go-shadowsocks2/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/go-shadowsocks2 $(1)/usr/bin/go-ss2
endef

$(eval $(call GoBinPackage,go-shadowsocks2))
$(eval $(call BuildPackage,go-shadowsocks2))
