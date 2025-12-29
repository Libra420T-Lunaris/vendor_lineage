# Lunaris packages
PRODUCT_PACKAGES += \
    AxionWidgets \
    BatteryStatsViewer \
    GameSpace \
    BtHelper \
    LMOFreeform \
    LMOFreeformSidebar \
    OmniJaws \
    OmniStyle

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

# Enable blur
TARGET_ENABLE_BLUR ?= true
ifeq ($(TARGET_ENABLE_BLUR),true)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.blur.enable=true \
    persist.sysui.disableBlur=false \
    ro.surface_flinger.supports_background_blur=1
else
PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.blur.enable=false \
    persist.sysui.disableBlur=true \
    ro.surface_flinger.supports_background_blur=0
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

# Disable touch video heatmap to reduce latency, motion jitter, and CPU usage
# on supported devices with Deep Press input classifier HALs and models
PRODUCT_PRODUCT_PROPERTIES += \
    ro.input.video_enabled=false

# Dexopt
ART_BUILD_HOST_DEBUG := false
ART_BUILD_TARGET_DEBUG := false

ifeq ($(TARGET_BUILD_VARIANT),user)
    PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false
    WITH_DEXPREOPT_DEBUG_INFO := false
endif

PRODUCT_PRODUCT_PROPERTIES += \
    pm.dexopt.downgrade_after_inactive_days=10 \
    dalvik.vm.enable_pr_dexopt=true \
    dalvik.vm.finalizer-timeout-ms=40000 \
    dalvik.vm.ps-min-first-save-ms=150000

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.minidebuginfo=false \
    dalvik.vm.dex2oat-minidebuginfo=false

# Always preopt extracted APKs to prevent extracting out of the APK for gms
# modules.
PRODUCT_ALWAYS_PREOPT_EXTRACTED_APK := true

# Do not generate libartd.
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
USE_DEX2OAT_DEBUG := false
OVERRIDE_DISABLE_DEXOPT_ALL := false

# Speed profile services and wifi-service to reduce RAM and storage.
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile

TARGET_OPTIMIZED_DEXOPT ?= false
ifeq ($(TARGET_OPTIMIZED_DEXOPT),true)
    PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := speed-profile
    PRODUCT_SYSTEM_PROPERTIES += \
        pm.dexopt.post-boot=speed-profile \
        pm.dexopt.first-boot=verify \
        pm.dexopt.boot-after-ota=verify \
        pm.dexopt.boot-after-mainline-update=verify \
        pm.dexopt.install=speed-profile \
        pm.dexopt.install-fast=speed-profile \
        pm.dexopt.install-bulk=speed-profile \
        pm.dexopt.install-bulk-secondary=speed \
        pm.dexopt.install-bulk-downgraded=speed \
        pm.dexopt.install-bulk-secondary-downgraded=speed \
        pm.dexopt.bg-dexopt=speed \
        pm.dexopt.ab-ota=speed-profile \
        pm.dexopt.inactive=verify \
        pm.dexopt.cmdline=speed \
        pm.dexopt.first-use=speed-profile \
        pm.dexopt.secondary=speed-profile \
        pm.dexopt.shared=speed \
        dalvik.vm.dex2oat-filter=speed \
        dalvik.vm.image-dex2oat-filter=speed \
        dalvik.vm.foreground-heap-growth-multiplier=1.3 \
        dalvik.vm.dex2oat-cpu-set=0,1,2,3,4,5,6 \
        dalvik.vm.dex2oat-threads=6

    PRODUCT_DEX_PREOPT_DEFAULT_FLAGS += \
        --compiler-filter=speed \
        --no-watch-dog

    $(call add-product-dex-preopt-module-config,services,--compiler-filter=speed)
    $(call add-product-dex-preopt-module-config,wifi-service,--compiler-filter=speed)

endif

# ColumbusService
ifneq ($(TARGET_SUPPORTS_QUICK_TAP),false)
PRODUCT_PACKAGES += \
    ColumbusService
endif

# Use a generic profile based boot image by default
PRODUCT_USE_PROFILE_FOR_BOOT_IMAGE := true
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := frameworks/base/boot/boot-image-profile.txt

# PIF values
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.pihooks_MANUFACTURER?=Google \
    persist.sys.pihooks_BRAND?=google \
    persist.sys.pihooks_PRODUCT?=comet_beta \
    persist.sys.pihooks_DEVICE?=comet \
    persist.sys.pihooks_ID?=BP41.250916.015 \
    persist.sys.pihooks_RELEASE?=16 \
    persist.sys.pihooks_SECURITY_PATCH?=2025-10-05 \
    persist.sys.pihooks_DEVICE_INITIAL_SDK_INT?=32 \
    persist.sys.pihooks_SDK_INT?=36 \
    persist.sys.pixelprops.gms=true

PRODUCT_BUILD_PROP_OVERRIDES += \
    PihooksGmsFp="google/comet_beta/comet:16/BP41.250916.015/14394230:user/release-keys" \
    PihooksGmsModel="Pixel 10 Pro Fold"

PRODUCT_PRODUCT_PROPERTIES += \
    remote_provisioning.enable_rkpd=true \
    remote_provisioning.hostname=remoteprovisioning.googleapis.com

# Feature
BYPASS_CHARGE_SUPPORTED ?= false
PERF_GOV_SUPPORTED ?= false
PERF_DEFAULT_GOV ?= schedutil
HBM_SUPPORTED ?= false
HBM_NODE ?= /sys/class/backlight/panel0-backlight/hbm_mode
TORCH_STR_SUPPORTED ?= false
TARGET_ENABLES_IMS_OVERRIDES ?= false
TARGET_TOUCH_BOOST_SUPPORTED ?= false
BYPASS_CHARGE_TOGGLE_PATH ?= /sys/class/power_supply/battery/input_suspend
BYPASS_CHARGE_LEVEL_PATH ?= /sys/devices/platform/google,charger/charge_stop_level

# optional
TARGET_USES_USLMK ?= false
TARGET_USLMK_DEBUG ?= false
TARGET_DISABLES_LIBPERF ?= false

# flags
PERF_ANIM_OVERRIDE ?= false
TARGET_NEEDS_DOZE_FIX ?= false

# FEATURES
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.battery_bypass_supported=$(BYPASS_CHARGE_SUPPORTED) \
    persist.sys.gs_charge_bypass_lvl_path=$(BYPASS_CHARGE_LEVEL_PATH) \
    persist.sys.gs_charge_bypass_toggle_path=$(BYPASS_CHARGE_TOGGLE_PATH) \
    persist.sys.dev_supports_perf_gov=$(PERF_GOV_SUPPORTED) \
    persist.sys.default_scaling_gov=$(PERF_DEFAULT_GOV) \
    persist.sys.hbmservice_support=$(HBM_SUPPORTED) \
    persist.sys.hbmservice_file=$(HBM_NODE) \
    persist.sys.torch_str_support=$(TORCH_STR_SUPPORTED) \
    persist.sys.axion_gpu_freqs_path=$(GPU_FREQS_PATH) \
    persist.sys.axion_gpu_minfreq_file=$(GPU_MIN_FREQ_PATH) \
    persist.sys.target_enables_ims_override=$(TARGET_ENABLES_IMS_OVERRIDES) \
    persist.sys.target_supports_touch_boost=$(TARGET_TOUCH_BOOST_SUPPORTED)

# sound
PRODUCT_PRODUCT_PROPERTIES += \
    audio.safemedia.bypass=1

# uclamp properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.surface_flinger.uclamp.min=165
    
# virtual ab properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.virtual_ab.compression.enabled=true \
    ro.virtual_ab.userspace.snapshots.enabled=true \
    ro.virtual_ab.batch_writes=true \
    ro.virtual_ab.io_uring.enabled=false \
    ro.virtual_ab.compression.xor.enabled=false \
    ro.virtual_ab.read_ahead_size=16 \
    ro.virtual_ab.o_direct.enabled=true \
    ro.virtual_ab.merge_thread_priority=19 \
    ro.virtual_ab.worker_thread_priority=0 \
    ro.virtual_ab.num_worker_threads=3 \
    ro.virtual_ab.num_merge_threads=1 \
    ro.virtual_ab.num_verify_threads=1 \
    ro.virtual_ab.cow_op_merge_size=16 \
    ro.virtual_ab.verify_threshold_size=1073741824 \
    ro.virtual_ab.verify_block_size=1048576 \
    ro.virtual_ab.compression.threads=true
