#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
#rm -rf bootable/recovery
rm -rf hardware/lineage/compat
#rm -rf system/core
#rm -rf system/update_engine
rm -rf packages/apps/Updater
rm -rf .repo/local_manifests
#rm -rf prebuilts/clang/host/linux-x86
#rm -rf vendor/lineage
#rm -rf vendor/oplus/camera

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/Evolution-X/manifest -b bq2 --depth 1 --git-lfs
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b evox-16.2 .repo/local_manifests
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
git fetch https://github.com/anchalsehrawat/android_hardware_lineage_compat.git -t sixteen && git cherry-pick 6f6bbb4a686ac367383584a183ebe31ee5d4b0e1 6a8ac15383a76806b807aaf70b3f6d98b907ec02
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
cd packages/apps/Updater
git fetch https://github.com/anchalsehrawat/evox_packages_apps_Updater.git && git cherry-pick 13f622049a1818e0f5449180e4de51c47afcb2df
croot

#Vanilla Updater urls
#cd vendor/lineage
#git fetch https://github.com/anchalsehrawat/vendor_evolution.git && git cherry-pick 587744521b5af1293dff08f602087f41b9be2add
#croot

#Sign Priv Keys
#rm -rf vendor/evolution-priv/keys
#git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/evolution-priv/keys
#cd vendor/evolution-priv/keys
#./keys.sh
#croot

rm -rf vendor/evolution-priv/keys
echo "-------------------Removed ex----------------------"
git clone https://github.com/anchalsehrawat/scripts.git -b ex-qp2 vendor/evolution-priv/keys
echo "-------------Cloned-------------------"

echo "----------------CHERRY-PICKS DONE-----------------"

#Lunch
lunch lineage_ziti-bp4a-userdebug

#ADB 
#export WITH_ADB_INSECURE=true
export TARGET_INCLUDE_ACCORD=true

#Crave
export BUILD_USERNAME=Loid
export BUILD_HOSTNAME=crave
export TZ=Asia/Kolkata
#For OPcam
export UNSAFE_DISABLE_HIDDENAPI_FLAGS=true

#Build GMS
export WITH_GMS=true
export TARGET_USES_MINI_GAPPS=true
#export TARGET_INCLUDE_LIVE_WALLPAPERS=true

m evolution

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/boot.img .
mv out/target/product/ziti/dtbo.img .
mv out/target/product/ziti/vbmeta.img .
mv out/target/product/ziti/vendor_boot.img .
mv out/target/product/ziti/super_empty.img .
mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_gms.json
echo "--------------MOVED GAPPS BUILD TO ROOT DIRECTORY--------------"

export WITH_GMS=false
m evolution

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_vanilla.json
echo "--------------MOVED VANILLA BUILD TO ROOT DIRECTORY--------------"
