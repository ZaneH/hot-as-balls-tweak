include $(THEOS)/makefiles/common.mk

SDKVERSION = 9.0

TWEAK_NAME = HotAsBalls
HotAsBalls_FILES = Tweak.xm
ADDITIONAL_OBJCFLAGS = -fobjc-arc

BUNDLE_NAME = com.zanehelton.hotasballs
com.zanehelton.hotasballs_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Weather"
