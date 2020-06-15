#
# Copyright (C) 2019 The Android Open Source Project
# Copyright (C) 2019 The TWRP Open Source Project
# Copyright (C) 2020 SebaUbuntu's TWRP device tree generator 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Specify phone tech before including full_phone
$(call inherit-product, vendor/omni/config/gsm.mk)

# Inherit some common Omni stuff.
$(call inherit-product, vendor/omni/config/common.mk)
$(call inherit-product, build/target/product/embedded.mk)

# Inherit Telephony packages
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit language packages
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# A/B updater
AB_OTA_UPDATER := false

# The following modules are included in debuggable builds only.
#PRODUCT_PACKAGES_DEBUG += \
#    bootctl \
#    update_engine_client

# Boot control HAL
##   bootctrl.msm8953

#PRODUCT_STATIC_BOOT_CONTROL_HAL := \
#    bootctrl.msm8953 \
#    libcutils \
#    libgptutils \
#    libz

# Time Zone data for recovery
PRODUCT_COPY_FILES += \
    system/timezone/output_data/iana/tzdata:recovery/root/system/usr/share/zoneinfo/tzdata

# Properties for decryption
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.keystore=msm8953 \
    ro.hardware.gatekeeper=msm8953 \
    ro.hardware.bootctrl=msm8953 \
    ro.build.system_root_image=true


# Device identifier. This must come after all inclusions
PRODUCT_DEVICE := surfna
PRODUCT_NAME := omni_surfna
PRODUCT_BRAND := motorola
PRODUCT_MODEL := e(6)
PRODUCT_MANUFACTURER := motorola
PRODUCT_RELEASE_NAME := moto e(6)
