include $(TOPDIR)/rules.mk

PKG_NAME:=tappas
PKG_VERSION:=5.1.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/hailo-ai/tappas.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_MIRROR_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE:=LGPL-2.1-only
PKG_LICENSE_FILES:=LICENSE

PKG_FIXUP:=meson
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/meson.mk

TARGET_CXXFLAGS += -Wno-error=class-memaccess -Wno-error=deprecated-declarations -I$(STAGING_DIR)/usr/include/opencv4 -I$(STAGING_DIR)/usr/include/gst-hailo

define Package/tappas
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=Hailo
  TITLE:=Hailo TAPPAS - Video Processing Pipeline Framework
  URL:=https://github.com/hailo-ai/tappas
  DEPENDS:=+libstdcpp +libpthread +hailort \
           +gstreamer1 +gst1-plugins-base \
           +opencv +libopencv-core +libopencv-imgproc +libopencv-imgcodecs \
           +libzmq-nc
endef

define Package/tappas/description
  Hailo TAPPAS is an infrastructure for building video processing applications
  with GStreamer and Hailo AI accelerators. It provides pipeline elements and
  pre-trained AI tasks for accelerating time to market.
endef

MESON_ARGS += \
	-Dinclude_python=false \
	-Dinclude_blas=false \
	-Dlibxtensor=$(STAGING_DIR)/usr/include \
	-Dlibrapidjson=$(STAGING_DIR)/usr/include \
	-Dtarget=plugins

define Build/Configure
	$(call Meson/CreateNativeFile,$(PKG_BUILD_DIR)/openwrt-native.txt)
	$(call Meson/CreateCrossFile,$(PKG_BUILD_DIR)/openwrt-cross.txt)
	cd $(PKG_BUILD_DIR)/core/hailo && \
	$(call Meson, \
		setup \
		--buildtype plain \
		--native-file $(PKG_BUILD_DIR)/openwrt-native.txt \
		--cross-file $(PKG_BUILD_DIR)/openwrt-cross.txt \
		-Ddefault_library=both \
		$(MESON_ARGS) \
		$(PKG_BUILD_DIR)/openwrt-build, \
		$(MESON_VARS))
endef


define Build/Compile
	+$(NINJA) -C $(PKG_BUILD_DIR)/openwrt-build
endef

define Build/Install
	+DESTDIR="$(PKG_INSTALL_DIR)" $(NINJA) -C $(PKG_BUILD_DIR)/openwrt-build install
endef

# Install only runtime files (libs + gstreamer plugins), skip headers
define Package/tappas/install
	$(INSTALL_DIR) $(1)/usr/lib/gstreamer-1.0
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/gstreamer-1.0/*.so* $(1)/usr/lib/gstreamer-1.0/ 2>/dev/null || true
	
	# Optional: copy shared resources if needed
	$(INSTALL_DIR) $(1)/usr/share/hailo
	$(CP) $(PKG_INSTALL_DIR)/usr/share/hailo/* $(1)/usr/share/hailo/ 2>/dev/null || true
endef

$(eval $(call BuildPackage,tappas))
