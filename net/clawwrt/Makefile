include $(TOPDIR)/rules.mk

PKG_NAME:=clawwrt
PKG_VERSION:=main
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/liudf0716/$(PKG_NAME)/tar.gz/$(PKG_VERSION)?
PKG_HASH:=d59650ce2159c524dbfc6deacbc1f4b258c92931bfde8ad1344cd7ee17876f50

PKG_MAINTAINER:=Dengfeng Liu <liudf0716@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/liudf0716/clawwrt
GO_PKG_BUILD_PKG:=github.com/liudf0716/clawwrt/cmd/clawwrt
GO_PKG_LDFLAGS_X:=github.com/liudf0716/clawwrt/internal/version.Version=$(PKG_VERSION)
GO_PKG_LDFLAGS:=-s -w

include $(INCLUDE_DIR)/package.mk
include ../../lang/golang/golang-package.mk

define Package/clawwrt
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Remote Management
  TITLE:=ClawWRT - OpenWrt Remote Management Agent
  URL:=https://github.com/liudf0716/clawwrt
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/clawwrt/description
  ClawWRT is a lightweight remote management agent for OpenWrt routers.
  It connects to OpenClaw platform via WebSocket for full router management
  including system info, firmware upgrade, WiFi, VPN, BPF flow control,
  and trusted domain/MAC management.
endef

define Package/clawwrt/conffiles
/etc/config/clawwrt
endef

define Package/clawwrt/install
	$(call GoPackage/Package/Install/Bin,$(1))
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/clawwrt.init $(1)/etc/init.d/clawwrt
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./files/clawwrt.conf $(1)/etc/config/clawwrt
endef

$(eval $(call GoBinPackage,clawwrt))
$(eval $(call BuildPackage,clawwrt))
