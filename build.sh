#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf hardware/lineage/compat
rm -rf .repo/local_manifests
rm -rf system/core
rm -rf system/update_engine
rm -rf bootable/recovery
#rm -rf vendor/yaap
#rm -rf packages/apps/OpenDelta
#rm -rf prebuilts/clang/host/linux-x86

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/yaap/manifest.git -b sixteen --git-lfs
echo "-----------------REPO INITIALISED------------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b yaap-16 .repo/local_manifests
echo "--------------CLONED local manifest----------------"

#Resync
/opt/crave/resync.sh
echo "---------------------RESYNCED----------------------"
#Build Environment
. build/envsetup.sh
echo "---------------BUILD ENVIRONMENT-------------------"

#Cherry-picks

#hardware_lineage_compat
cd hardware/lineage/compat
git fetch https://github.com/anchalsehrawat/android_hardware_lineage_compat.git && git cherry-pick 4a3e05b445745110ec17b89e3976645744bcacf0
croot

#Stock ROM Reverting Patches
#system_update_engine
cd system/update_engine
git fetch https://github.com/anchalsehrawat/android_system_update_engine.git && git cherry-pick d804cc2a02e0e94c2d8e9ba47175f3946954306d && git cherry-pick d526f28031438c184746cfe6a038186598180fe6
croot

#system_core
cd system/core
git fetch https://github.com/anchalsehrawat/evox_system_core.git && git cherry-pick 978f6b40ba6531490a6c3588f7bb14aa10b279cf
croot

#bootable_recovery
cd bootable/recovery
git fetch https://github.com/anchalsehrawat/evox_bootable_recovery.git -t yaap-16 && git cherry-pick 12c3ea5723b3b7a831cf339c62cf1b067cbd40d7 && git cherry-pick a3444df8157552bc797d64cfcdfbca3e3abb1c79 && git cherry-pick 3ce47e031b0476c9d7a0e83346c984423351a71d
croot

#OTA Support
#For GMS 
#cd packages/apps/OpenDelta
#git fetch https://github.com/anchalsehrawat/packages_apps_OpenDelta.git && git cherry-pick d6347c0d71f7997d7b8a7de45db9fc7168a75674
#croot

#For Vanilla
#cd vendor/yaap
#git fetch https://github.com/anchalsehrawat/vendor_yaap.git && git cherry-pick 74eeddb39c9ccf66d0cf00dd21cfb44f7136f794 && git cherry-pick f20efeb17d78268f3b922af169f6de6b6070ba8e
#croot

echo "----------------CHERRY-PICKS DONE------------------"

#Lunch
lunch yaap_ziti-userdebug

#Build GMS
export TARGET_BUILD_GAPPS=true
m yaap

cp -r out/target/product/ziti/YAAP-16* .
mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_gms.json
echo "---------------GMS BUILD COMPLETE--------------"

lunch yaap_ziti-userdebug
export TARGET_BUILD_GAPPS=false
m yaap

mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_vanilla.json
echo "---------------VANILLA BUILD COMPLETE------------------"
