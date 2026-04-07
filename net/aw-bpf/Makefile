#
# Copyright (C) 2025 Dengfeng Liu
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=aw-bpf
PKG_VERSION:=main
PKG_RELEASE:=1

PKG_SOURCE:=aw-bpf-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/liudf0716/$(PKG_NAME)/tar.gz/$(PKG_VERSION)?
PKG_HASH:=skip
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=bpf-headers

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk
include $(INCLUDE_DIR)/bpf.mk
include $(INCLUDE_DIR)/kernel.mk

define Package/aw-bpf
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ApFree eBPF programs and tools
  DEPENDS:=+libbpf +libjson-c +libevent2 +libuci +libmnl +libnftnl +tc-full $(BPF_DEPENDS)
  URL:=https://github.com/liudf0716/aw-bpf
endef

define Package/aw-bpf/description
  ApFree eBPF provides eBPF programs for session tracking, xDPI, DNS monitoring
  and related user-space tools (aw-bpfctl, event_daemon, dns-monitor).
endef

define Package/aw-bpf/conffiles
/etc/config/aw-bpf
endef

define Build/Compile
	cd $(PKG_BUILD_DIR) && cmake -DCMAKE_BUILD_TYPE=Release . && make -j$(CPU_COUNT)
endef

define Package/aw-bpf/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/aw-bpfctl $(1)/usr/bin/aw-bpfctl
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/event_daemon $(1)/usr/bin/event_daemon
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dns-monitor $(1)/usr/bin/dns-monitor
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/aw-bpf.init $(1)/etc/init.d/aw-bpf
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/aw-bpf.conf $(1)/etc/config/aw-bpf
	$(INSTALL_DIR) $(1)/lib/bpf
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/aw-bpf.o $(1)/lib/bpf/aw-bpf.o
endef

$(eval $(call BuildPackage,aw-bpf))
