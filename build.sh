#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf hardware/lineage/compat
rm -rf .repo/local_manifests
rm -rf prebuilts/clang/host/linux-x86
#rm -rf vendor/lineage
#rm -rf system/core
#rm -rf bootable/recovery
#rm -rf system/update_engine
#rm -rf packages/apps/Updater

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.0 --git-lfs
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b axion-16 .repo/local_manifests
echo "-----------------CLONED local manifest-------------------"

#Resync
/opt/crave/resync.sh
echo "---------------RESYNCED-----------------"
#Build Environment
. build/envsetup.sh
echo "---------------BUILD ENVIRONMENT------------------"

#Cherry-picks
#hardware_lineage_compat
cd hardware/lineage/compat
git fetch https://github.com/anchalsehrawat/android_hardware_lineage_compat.git && git cherry-pick 4a3e05b445745110ec17b89e3976645744bcacf0
croot

#Stock Reverting patches
#bootable_recovery
#cd bootable/recovery
#git fetch https://github.com/anchalsehrawat/evox_bootable_recovery.git && git cherry-pick fc8c79dafadb7176b9b962ab02fcec5b5175c51b && git cherry-pick 62e74cc196b3ce6d1b41a9e11499e46e4ff8aa6e && git cherry-pick 52bbdfbc7e27aecfd5dbd21c571bdbca998d4011
#croot

#system_core
#cd system/core
#git fetch https://github.com/anchalsehrawat/evox_system_core.git && git cherry-pick 978f6b40ba6531490a6c3588f7bb14aa10b279cf
#croot

#system_update_engine
#cd system/update_engine
#git fetch https://github.com/anchalsehrawat/android_system_update_engine.git && git cherry-pick d804cc2a02e0e94c2d8e9ba47175f3946954306d && git cherry-pick d526f28031438c184746cfe6a038186598180fe6
#croot

#For OTA Updates
#Apps Updater
#cd packages/apps/Updater
#git fetch https://github.com/anchalsehrawat/evox_packages_apps_Updater.git && git cherry-pick 13f622049a1818e0f5449180e4de51c47afcb2df
#croot

#Vanilla Updater urls
#cd vendor/lineage
#git fetch https://github.com/anchalsehrawat/vendor_evolution.git && git cherry-pick 587744521b5af1293dff08f602087f41b9be2add
#croot

echo "----------------CHERRY-PICKS DONE-----------------"

#Generate Private keys
gk -s

#Build GMS
axion ziti userdebug gms pico
ax -b -j$(nproc --all) userdebug

mv out/target/product/ziti/*.zip .
#mv out/target/product/ziti/GMS/ziti.json .
#mv ziti.json ax_gms.json
echo "--------------MOVED GAPPS BUILD TO ROOT DIRECTORY--------------"

#Vanilla
axion ziti userdebug va
ax -b -j$(nproc --all) userdebug

mv out/target/product/ziti/*.zip .
#mv out/target/product/ziti/VANILLA/ziti.json .
#mv ziti.json ax_vanilla.json
echo "--------------MOVED VANILLA BUILD TO ROOT DIRECTORY--------------"
