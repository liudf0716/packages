include $(TOPDIR)/rules.mk

PKG_NAME:=opencv
PKG_VERSION:=4.12.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/opencv/opencv.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_MIRROR_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
CMAKE_SOURCE_SUBDIR:=.
CMAKE_BINARY_SUBDIR:=build

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

PKG_FIXUP:=cmake
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/opencv/Default
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=Hailo
  TITLE:=OpenCV - Open Source Computer Vision Library
  URL:=https://opencv.org/
  DEPENDS:=+libstdcpp +libpthread +zlib +libjpeg +libpng
endef

define Package/opencv
  $(call Package/opencv/Default)
  TITLE+= (all modules)
  DEPENDS+= +libopencv-core +libopencv-imgproc +libopencv-imgcodecs
endef

define Package/libopencv-core
  $(call Package/opencv/Default)
  TITLE+= (core module)
endef

define Package/libopencv-imgproc
  $(call Package/opencv/Default)
  TITLE+= (imgproc module)
  DEPENDS+=+libopencv-core
endef

define Package/libopencv-imgcodecs
  $(call Package/opencv/Default)
  TITLE+= (imgcodecs module)
  DEPENDS+=+libopencv-core +libopencv-imgproc
endef

define Package/opencv/description
  OpenCV (Open Source Computer Vision Library) is an open source computer
  vision and machine learning software library. OpenCV was built to provide
  a common infrastructure for computer vision applications.
endef

CMAKE_OPTIONS += \
	-DBUILD_SHARED_LIBS=ON \
	-DBUILD_STATIC_LIBS=OFF \
	-DBUILD_opencv_apps=OFF \
	-DBUILD_opencv_calib3d=OFF \
	-DBUILD_opencv_dnn=OFF \
	-DBUILD_opencv_features2d=OFF \
	-DBUILD_opencv_flann=OFF \
	-DBUILD_opencv_gapi=OFF \
	-DBUILD_opencv_highgui=OFF \
	-DBUILD_opencv_ml=OFF \
	-DBUILD_opencv_objdetect=OFF \
	-DBUILD_opencv_photo=OFF \
	-DBUILD_opencv_python3=OFF \
	-DBUILD_opencv_stitching=OFF \
	-DBUILD_opencv_ts=OFF \
	-DBUILD_opencv_video=OFF \
	-DBUILD_opencv_videoio=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_TESTS=OFF \
	-DBUILD_PERF_TESTS=OFF \
	-DBUILD_DOCS=OFF \
	-DWITH_CUDA=OFF \
	-DWITH_FFMPEG=OFF \
	-DWITH_GSTREAMER=OFF \
	-DWITH_GTK=OFF \
	-DWITH_IPP=OFF \
	-DWITH_JPEG=ON \
	-DWITH_PNG=ON \
	-DWITH_TIFF=OFF \
	-DWITH_WEBP=OFF \
	-DWITH_OPENEXR=OFF \
	-DWITH_JASPER=OFF \
	-DWITH_V4L=OFF \
	-DWITH_OPENCL=OFF \
	-DENABLE_NEON=ON \
	-DCPU_BASELINE=NEON

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/opencv4 $(1)/usr/include/
	
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libopencv*.so* $(1)/usr/lib/
	
	$(INSTALL_DIR) $(1)/usr/lib/cmake/opencv4
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/cmake/opencv4/* $(1)/usr/lib/cmake/opencv4/
	
	# Generate opencv4.pc file since OpenCV 4.x doesn't provide one
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	( \
		echo 'prefix=/usr'; \
		echo 'exec_prefix=$$$${prefix}'; \
		echo 'libdir=$$$${prefix}/lib'; \
		echo 'includedir=$$$${prefix}/include/opencv4'; \
		echo ''; \
		echo 'Name: OpenCV'; \
		echo 'Description: Open Source Computer Vision Library'; \
		echo 'Version: $(PKG_VERSION)'; \
		echo 'Libs: -L$$$${libdir} -lopencv_core -lopencv_imgproc -lopencv_imgcodecs'; \
		echo 'Cflags: -I$$$${includedir}'; \
	) > $(1)/usr/lib/pkgconfig/opencv4.pc
endef

define Package/libopencv-core/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libopencv_core.so* $(1)/usr/lib/
endef

define Package/libopencv-imgproc/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libopencv_imgproc.so* $(1)/usr/lib/
endef

define Package/libopencv-imgcodecs/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libopencv_imgcodecs.so* $(1)/usr/lib/
endef

define Package/opencv/install
	# Meta-package, no files to install
	# All files are provided by libopencv-* sub-packages
	true
endef

$(eval $(call BuildPackage,libopencv-core))
$(eval $(call BuildPackage,libopencv-imgproc))
$(eval $(call BuildPackage,libopencv-imgcodecs))
$(eval $(call BuildPackage,opencv))
