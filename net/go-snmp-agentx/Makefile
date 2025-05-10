include $(TOPDIR)/rules.mk

PKG_NAME:=go-snmp-agentx
PKG_VERSION:=master
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/gigibox/$(PKG_NAME)/tar.gz/$(PKG_VERSION)?
PKG_HASH:=6bb648c8d9faec4a5b6cf373afd20bc0e3c0ee62b2e1f4fed998a445daf89cf9
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

PKG_MAINTAINER:=ZhangZengfei <zh.zengfei@gmail.com>
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=go-snmp-agentx
GOPROXY_URL:=https://goproxy.cn,direct
GO_PKG_BUILD_PKG:=go-snmp-agentx

include $(INCLUDE_DIR)/package.mk
include ../../lang/golang/golang-package.mk

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/$(PKG_NAME) $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/share/3ginfo-lite/
	$(INSTALL_BIN) ./files/modeminfo.sh $(1)/usr/share/3ginfo-lite/modeminfo.sh
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/go-snmp-agentx.init $(1)/etc/init.d/agentx
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/go-snmp-agentx.config $(1)/etc/config/agentx
endef

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Golang AgentX implementation for SNMP extension
  DEPENDS:=$(GO_ARCH_DEPENDS) +snmpd
endef

define Build/Compile
	export GOPROXY="https://goproxy.cn"; \
	$(call GoPackage/Build/Compile)
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
