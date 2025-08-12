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
rm -rf vendor/lineage

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/Evolution-X/manifest -b bka --depth 1 --git-lfs
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b evox-16 .repo/local_manifests
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
git fetch https://github.com/anchalsehrawat/evox_packages_apps_Updater.git && git cherry-pick 13f622049a1818e0f5449180e4de51c47afcb2df
croot

#Vanilla Updater urls
cd vendor/lineage
git fetch https://github.com/anchalsehrawat/vendor_evolution.git && git cherry-pick 587744521b5af1293dff08f602087f41b9be2add
croot

#system_core
cd system/core
git fetch https://github.com/anchalsehrawat/evox_system_core.git && git cherry-pick d3b3d0a378a8af6d79ab0e0abeb78f7f788d804a
croot

#bootable_recovery
cd bootable/recovery
git fetch https://github.com/anchalsehrawat/evox_bootable_recovery.git && git cherry-pick 611906a69e81ed03f6a2b3137257d952f7869b20 && git cherry-pick be79661dfd509f0ff47b0663d097c3ae79e6f666 && git cherry-pick 92eb57ab11fad248257c1cf01d642ed38ae2c888
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
lunch lineage_ziti-bp2a-userdebug

#ADB 
#export WITH_ADB_INSECURE=true

#Build GMS
export WITH_GMS=true
m evolution

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_gms.json
echo "--------------MOVED GAPPS BUILD TO ROOT DIRECTORY--------------"

export WITH_GMS=false
m evolution

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_vanilla.json
echo "--------------MOVED VANILLA BUILD TO ROOT DIRECTORY--------------"
