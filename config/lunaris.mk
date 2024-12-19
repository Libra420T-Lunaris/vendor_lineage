# Lunaris packages
PRODUCT_PACKAGES += \
    GameSpace

ifeq ($(LUNARIS_BUILD_TYPE),OFFICIAL)
PRODUCT_PACKAGES += \
    Updater
endif

# Private keys
ifeq ($(LUNARIS_BUILD_TYPE),OFFICIAL)
    $(call inherit-product, vendor/lunaris-priv/keys/keys.mk)
endif

ifeq ($(WITH_GMS),false)
PRODUCT_PACKAGES += \
    UpdaterVanillaOverlay
endif

# Cloned app exemption
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/sysconfig/preinstalled-packages-platform-lunaris-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/preinstalled-packages-platform-lunaris-product.xml

# Face Unlock
TARGET_SUPPORTS_64_BIT_APPS := true
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
PRODUCT_PACKAGES += \
    FaceUnlock

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/android.hardware.biometrics.face.xml
endif

# DeviceAsWebcam
ifeq ($(TARGET_BUILD_DEVICE_AS_WEBCAM), true)
    PRODUCT_PACKAGES += \
        DeviceAsWebcam

    PRODUCT_VENDOR_PROPERTIES += \
        ro.usb.uvc.enabled=true
endif
