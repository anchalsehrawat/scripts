#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf hardware/lineage/compat
rm -rf system/core
rm -rf system/update_engine
rm -rf bootable/recovery
rm -rf packages/apps/Updater
rm -rf .repo/local_manifests
echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/crdroidandroid/android.git -b 15.0 --git-lfs --depth 1
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b cr-15 .repo/local_manifests
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
git fetch https://github.com/anchalsehrawat/evox_packages_apps_Updater.git 15.0 && git cherry-pick f55016bd222aa5c32b4b12ac294911103d5e4a88
croot

system_core
cd system/core
git fetch https://github.com/anchalsehrawat/evox_system_core.git && git cherry-pick d3b3d0a378a8af6d79ab0e0abeb78f7f788d804a
croot

#bootable_recovery
cd bootable/recovery
git fetch https://github.com/anchalsehrawat/evox_bootable_recovery.git && git cherry-pick 7f64946ca76279ef31e455c9d742b8fa12567377
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

#Build
export TARGET_HAS_UDFPS=true 
export TARGET_ENABLE_BLUR=true 
brunch ziti

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/ziti.json .
mv out/target/product/ziti/boot.img .
mv out/target/product/ziti/vendor_boot.img .
mv out/target/product/ziti/dtbo.img .
mv out/target/product/ziti/vbmeta.img .
mv out/target/product/ziti/super_empty.img .
echo "--------------MOVED BUILD TO ROOT DIRECTORY--------------"