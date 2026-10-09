#
# Copyright (C) 2026 Dengfeng Liu <liudf0716@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=chawrt-bpf-dispatcher
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/liudf0716/$(PKG_NAME)/tar.gz/$(PKG_VERSION)?
PKG_HASH:=bc8bea01bc259e21727c291fe5ecb725d03d3c5910f1d1139b2d82ba318ee974
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=bpf-headers

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk
include $(INCLUDE_DIR)/bpf.mk

define Package/chawrt-bpf-dispatcher
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Routing and Redirection
  TITLE:=Unified Kernel eBPF TC Pipeline Dispatcher for ChaWrt
  DEPENDS:=+libbpf +tc-full $(BPF_DEPENDS)
  URL:=https://github.com/liudf0716/chawrt-bpf-dispatcher
endef

define Package/chawrt-bpf-dispatcher/description
  chawrt-bpf-dispatcher provides a unified kernel-level eBPF TC pipeline dispatcher
  ensuring conflict-free, deterministic execution ordering across all modular BPF components.
endef

define Package/chawrt-bpf-dispatcher/conffiles
/etc/config/chawrt-bpf-dispatcher
endef

define Package/chawrt-bpf-dispatcher/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/chawrt-bpf-dispatcher $(1)/usr/bin/chawrt-bpf-dispatcher

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/chawrt-bpf-dispatcher.init $(1)/etc/init.d/chawrt-bpf-dispatcher

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/chawrt-bpf-dispatcher.config $(1)/etc/config/chawrt-bpf-dispatcher
endef

$(eval $(call BuildPackage,chawrt-bpf-dispatcher))
