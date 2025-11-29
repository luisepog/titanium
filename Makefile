ARCHS := arm64
TARGET := iphone:clang:16.5:14.2
INSTALL_TARGET_PROCESSES = Titanium
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = Titanium

Titanium_FILES = $(wildcard *.mm *.m *.c *.cpp)

Titanium_FRAMEWORKS = UIKit CoreGraphics QuartzCore AVFoundation Security
Titanium_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-module-import-in-extern-c
Titanium_CFLAGS += -framework Foundation -framework CoreServices -framework Security
Titanium_CFLAGS += -Iinclude
Titanium_CCFLAGS += -std=c++14 -fno-rtti -fno-exceptions -DNDEBUG
Titanium_CFLAGS += -arch arm64 -arch arm64e -isysroot $(shell xcrun --sdk iphoneos --show-sdk-path)
Titanium_PRIVATE_FRAMEWORKS = AppSupport BackBoardServices GraphicsServices IOKit SpringBoardServices

ifeq ($(TARGET_CODESIGN),ldid)
Titanium_CODESIGN_FLAGS += -Sent.plist
else
Titanium_CODESIGN_FLAGS += --entitlements ent.plist $(TARGET_CODESIGN_FLAGS)
endif


include $(THEOS_MAKE_PATH)/application.mk

after-stage::
	@echo "Running after-stage commands"
	$(ECHO_NOTHING)mkdir -p packages $(THEOS_STAGING_DIR)/Payload$(ECHO_END)
	$(ECHO_NOTHING)cp -rp $(THEOS_STAGING_DIR)/Applications/Titanium.app $(THEOS_STAGING_DIR)/Payload$(ECHO_END)
	$(ECHO_NOTHING)cp $(THEOS_STAGING_DIR)/../../Info.plist $(THEOS_STAGING_DIR)/Payload/Titanium.app$(ECHO_END)
	$(ECHO_NOTHING)cd $(THEOS_STAGING_DIR); zip -qr Titanium.tipa Payload; cd -;$(ECHO_END)
	$(ECHO_NOTHING)mv $(THEOS_STAGING_DIR)/Titanium.tipa packages/Titanium.tipa $(ECHO_END)
