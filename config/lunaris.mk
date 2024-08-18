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