# SPDX-License-Identifier: GPL-2.0-only
include $(TOPDIR)/rules.mk

# Package information
PKG_NAME:=bpfilter
PKG_VERSION:=main
PKG_RELEASE:=1
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz

PKG_SOURCE_URL:=https://codeload.github.com/liudf0716/bpfilter/tar.gz/$(PKG_VERSION)?
PKG_HASH:=b3a587678fbbacba115cc33f2729722a6f06b852b09aadb292d6b4c963c1daa7
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

# Build configuration
PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=USE_UCLIBC:argp-standalone USE_MUSL:argp-standalone
HOST_BUILD_DEPENDS:=HOST_OS_MACOS:argp-standalone/host

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

# Disable tests, docs, checks, and benchmarks for OpenWrt
CMAKE_OPTIONS += \
	-DNO_TESTS=1 \
	-DNO_DOCS=1 \
	-DNO_CHECKS=1 \
	-DNO_BENCHMARKS=1

define Package/bpfilter
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libbpf +libelf +libnl +flex +bison \
           +jq +bpftool $(BPF_DEPENDS)
  TITLE:=Bpfilter - BPF-based filtering framework
  URL:=https://github.com/facebook/bpfilter
endef

define Package/bpfilter/description
 Bpfilter is a BPF-based packet filtering tool designed to work with Netfilter hooks.
endef

# Prepare the configuration for OpenWrt
define Build/Prepare
	$(call Build/Prepare/Default)
endef

# Install files to OpenWrt's root filesystem
define Package/bpfilter/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/output/sbin/bpfilter $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/output/sbin/bfcli $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/output/lib/libbpfilter.so* $(1)/usr/lib/
endef

# Register the package
$(eval $(call BuildPackage,bpfilter))
