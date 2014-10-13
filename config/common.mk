PRODUCT_BRAND ?= cyanogenmod

SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.cyanogenmod.superuser

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/ldroid/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/ldroid/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/ldroid/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

ifdef LDROID_NIGHTLY
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=ldroid
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=ldroid
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.dun.override=0 \
    ro.adb.secure=3 \
    persist.sys.root_access=3 \
    ro.build.selinux=1

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/ldroid/CHANGELOG.mkdn:system/etc/CHANGELOG-CM.txt

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/ldroid/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/ldroid/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/ldroid/prebuilt/common/bin/50-ldroid.sh:system/addon.d/50-ldroid.sh \
    vendor/ldroid/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/ldroid/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/ldroid/prebuilt/common/etc/backup.conf:system/etc/backup.conf
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/ldroid/prebuilt/common/bin/otasigcheck.sh:system/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/ldroid/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/ldroid/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/ldroid/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# Copy libgif for Nova Launcher 3.0
PRODUCT_COPY_FILES += \
    vendor/ldroid/prebuilt/common/lib/libgif.so:system/lib/libgif.so

# LDROID-specific init file
PRODUCT_COPY_FILES += \
    vendor/ldroid/prebuilt/common/etc/init.local.rc:root/init.ldroid.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/ldroid/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/ldroid/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is LDROID!
PRODUCT_COPY_FILES += \
    vendor/ldroid/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# T-Mobile theme engine
include vendor/ldroid/config/themes_common.mk

# Required LDROID packages
PRODUCT_PACKAGES += \
    Development \
    LatinIME \
    BluetoothExt

# init.d support
PRODUCT_COPY_FILES += \
    vendor/ldroid/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/ldroid/prebuilt/common/etc/helpers.sh:system/etc/helpers.sh \
    vendor/ldroid/prebuilt/common/etc/init.d.cfg:system/etc/init.d.cfg \
    vendor/ldroid/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/ldroid/prebuilt/common/etc/init.d/01check:system/etc/init.d/01check \
    vendor/ldroid/prebuilt/common/etc/init.d/02zipalign:system/etc/init.d/02zipalign \
    vendor/ldroid/prebuilt/common/etc/init.d/03sysctl:system/etc/init.d/03sysctl \
    vendor/ldroid/prebuilt/common/etc/init.d/04firstboot:system/etc/init.d/04firstboot \
    vendor/ldroid/prebuilt/common/etc/init.d/05freemem:system/etc/init.d/05freemem \
    vendor/ldroid/prebuilt/common/etc/init.d/06removecache:system/etc/init.d/06removecache \
    vendor/ldroid/prebuilt/common/etc/init.d/07fixperms:system/etc/init.d/07fixperms \
    vendor/ldroid/prebuilt/common/etc/init.d/09cron:system/etc/init.d/09cron \
    vendor/ldroid/prebuilt/common/etc/init.d/10sdboost:system/etc/init.d/10sdboost \
    vendor/ldroid/prebuilt/common/etc/init.d/11battery:system/etc/init.d/11battery \
    vendor/ldroid/prebuilt/common/etc/init.d/12touch:system/etc/init.d/12touch \
    vendor/ldroid/prebuilt/common/etc/init.d/13minfree:system/etc/init.d/13minfree \
    vendor/ldroid/prebuilt/common/etc/init.d/14gpurender:system/etc/init.d/14gpurender \
    vendor/ldroid/prebuilt/common/etc/init.d/15sleepers:system/etc/init.d/15sleepers \
    vendor/ldroid/prebuilt/common/etc/init.d/16journalism:system/etc/init.d/16journalism \
    vendor/ldroid/prebuilt/common/etc/init.d/17sqlite3:system/etc/init.d/17sqlite3 \
    vendor/ldroid/prebuilt/common/etc/init.d/18wifisleep:system/etc/init.d/18wifisleep \
    vendor/ldroid/prebuilt/common/etc/init.d/19iostats:system/etc/init.d/19iostats \
    vendor/ldroid/prebuilt/common/etc/init.d/20setrenice:system/etc/init.d/20setrenice \
    vendor/ldroid/prebuilt/common/etc/init.d/21tweaks:system/etc/init.d/21tweaks \
    vendor/ldroid/prebuilt/common/etc/init.d/24speedy_modified:system/etc/init.d/24speedy_modified \
    vendor/ldroid/prebuilt/common/etc/init.d/25loopy_smoothness_tweak:system/etc/init.d/25loopy_smoothness_tweak \
    vendor/ldroid/prebuilt/common/etc/init.d/98tweaks:system/etc/init.d/98tweaks

# Optional packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji

# Screen recorder
PRODUCT_PACKAGES += \
    ScreenRecorder \
    libscreenrecorder

# Custom LDROID packages
PRODUCT_PACKAGES += \
    Trebuchet \
    DSPManager \
    libcyanogen-dsp \
    audio_effects.conf \
    CMWallpapers \
    CMFileManager \
    LockClock \
    CMHome \
    CMAccount \
    KernelTweaker

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# HFM Files
PRODUCT_COPY_FILES += \
    vendor/ldroid/prebuilt/etc/hosts.alt:system/etc/hosts.alt \
    vendor/ldroid/prebuilt/etc/hosts.og:system/etc/hosts.og

# Extra tools in LDROID
PRODUCT_PACKAGES += \
    libsepol \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# rsync
PRODUCT_PACKAGES += \
    rsync

# Workaround for NovaLauncher zipalign fails
PRODUCT_COPY_FILES += \
    vendor/ldroid/prebuilt/common/app/NovaLauncher.apk:system/app/NovaLauncher.apk

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

# Required packages
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    Superuser \
    su

PRODUCT_COPY_FILES += \
    external/koush/Superuser/init.superuser.rc:root/init.superuser.rc

# Terminal Emulator
PRODUCT_COPY_FILES +=  \
    vendor/ldroid/proprietary/Term.apk:system/app/Term.apk \
    vendor/ldroid/proprietary/lib/armeabi/libjackpal-androidterm4.so:system/lib/libjackpal-androidterm4.so

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/ldroid/overlay/common

# Set LDROID_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef LDROID_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "LDROID_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^LDROID_||g')
        LDROID_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(LDROID_BUILDTYPE)),)
    LDROID_BUILDTYPE :=
endif

ifdef LDROID_BUILDTYPE
    ifneq ($(LDROID_BUILDTYPE), SNAPSHOT)
        ifdef LDROID_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            LDROID_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from LDROID_EXTRAVERSION
            LDROID_EXTRAVERSION := $(shell echo $(LDROID_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to LDROID_EXTRAVERSION
            LDROID_EXTRAVERSION := -$(LDROID_EXTRAVERSION)
        endif
    else
        ifndef LDROID_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            LDROID_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from LDROID_EXTRAVERSION
            LDROID_EXTRAVERSION := $(shell echo $(LDROID_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to LDROID_EXTRAVERSION
            LDROID_EXTRAVERSION := -$(LDROID_EXTRAVERSION)
        endif
    endif
else
    # If LDROID_BUILDTYPE is not defined, set to UNOFFICIAL
    LDROID_BUILDTYPE := UNOFFICIAL
    LDROID_EXTRAVERSION :=
endif

ifeq ($(LDROID_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        LDROID_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

# Versioning System
PRODUCT_VERSION_MAJOR = 4
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0-cm
ifdef LDROID_BUILD_EXTRA
    LDROID_POSTFIX := -$(LDROID_BUILD_EXTRA)

endif
ifndef LDROID_BUILD_TYPE
    LDROID_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
    LDROID_POSTFIX := -$(shell date +"%Y%m%d")
endif

# Set all versions
LDROID_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)
LDROID_MOD_VERSION := L-Droid$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(LDROID_BUILD)-$(LDROID_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ldroid.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.ldroid.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.modversion=$(LDROID_MOD_VERSION) \
    ro.ldroid.buildtype=$(LDROID_BUILD_TYPE) \
    ro.ldroid.releasetype=$(LDROID_BUILD_TYPE) \
    ro.cmlegal.url=http://www.cyanogenmod.org/docs/privacy

-include vendor/cm-priv/keys/keys.mk

LDROID_DISPLAY_VERSION := $(LDROID_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
  ifneq ($(LDROID_BUILDTYPE), UNOFFICIAL)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
      ifneq ($(LDROID_EXTRAVERSION),)
        # Remove leading dash from LDROID_EXTRAVERSION
        LDROID_EXTRAVERSION := $(shell echo $(LDROID_EXTRAVERSION) | sed 's/-//')
        TARGET_VENDOR_RELEASE_BUILD_ID := $(LDROID_EXTRAVERSION)
      else
        TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
      endif
    else
      TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
    endif
    LDROID_DISPLAY_VERSION=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
  endif
endif
endif

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

PRODUCT_PROPERTY_OVERRIDES += \
  ro.ldroid.display.version=$(LDROID_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

ifeq ($(USE_PREBUILT_CHROMIUM),1)
ifeq ($(PRODUCT_PREBUILT_WEBVIEWCHROMIUM),yes)

$(call inherit-product-if-exists, prebuilts/chromium/$(TARGET_DEVICE)/chromium_prebuilt.mk)

endif
endif
