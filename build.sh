#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf hardware/lineage/compat
rm -rf system/core
rm -rf system/update_engine
rm -rf bootable/recovery
rm -rf packages/apps/Updater
rm -rf .repo/local_manifests
rm -rf prebuilts/clang/host/linux-x86

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/RisingOS-Revived/android -b sixteen --git-lfs
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b rising-16 .repo/local_manifests
echo "-----------------CLONED local manifest-------------------"

#Resync
/opt/crave/resync.sh
echo "---------------RESYNCED-----------------"
#Build Environment
. build/envsetup.sh
echo "---------------BUILD ENVIRONMENT------------------"

#Cherry-picks

#Apps Updater
cd packages/apps/Updater
git fetch https://github.com/anchalsehrawat/evox_packages_apps_Updater.git sixteen && git cherry-pick 289501d946c0f875ba6992a9aefc0b6d16ac5200
croot

#system_core
cd system/core
git fetch https://github.com/anchalsehrawat/evox_system_core.git && git cherry-pick d3b3d0a378a8af6d79ab0e0abeb78f7f788d804a
croot

#bootable_recovery
cd bootable/recovery
git fetch https://github.com/anchalsehrawat/evox_bootable_recovery.git sixteen && git cherry-pick d15a2ce09a66de3c82e747b6ba2bd96e4ef893d2 && git cherry-pick 052cbbd7443b5a05d5c1cd4378eb44dff61477c1 && git cherry-pick 6fea4178fbde7dbcb139a0561b0b489514cb0601 && git cherry-pick ed03717d700974e9bbf974989ab2f7f671bd8e52
croot

#hardware_lineage_compat
cd hardware/lineage/compat
git fetch https://github.com/anchalsehrawat/android_hardware_lineage_compat.git && git cherry-pick 4a3e05b445745110ec17b89e3976645744bcacf0
croot

#system_update_engine
cd system/update_engine
git fetch https://github.com/anchalsehrawat/android_system_update_engine.git && git cherry-pick 0edfe05fdc2a3ebb387b827d6728496e2fa7e943 && git cherry-pick 7c48159420c99f1cfb846eebc7d7ee7b1eb167d3
croot

echo "----------------CHERRY-PICKS DONE-----------------"

#Lunch
riseup ziti userdebug

#Build GMS
export TARGET_ENABLE_BLUR=true
export WITH_GMS=true
rise b

mv out/target/product/ziti/*.zip .
echo "--------------MOVED GAPPS BUILD TO ROOT DIRECTORY--------------"

#Build Vanilla

export WITH_GMS=false
#export WITH_MICROG=true 
rise b

mv out/target/product/ziti/*.zip .
echo "--------------MOVED VANILLA BUILD TO ROOT DIRECTORY--------------"
