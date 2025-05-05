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
repo init -u https://github.com/AxionAOSP/android.git -b lineage-22.2 --git-lfs --depth 1
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b axion-15 .repo/local_manifests
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
git fetch https://github.com/anchalsehrawat/evox_packages_apps_Updater.git lineage-22.2 && git cherry-pick d9cbb3ffd6c749dcb4a926cb44cc187ca84ce2ab
croot

system_core
cd system/core
git fetch https://github.com/anchalsehrawat/evox_system_core.git && git cherry-pick d3b3d0a378a8af6d79ab0e0abeb78f7f788d804a
croot

#bootable_recovery
cd bootable/recovery
git fetch https://github.com/anchalsehrawat/evox_bootable_recovery.git lineage-22.2 && git cherry-pick be4da6468f26e20f6bf30098033a1235cde0b145 && git cherry-pick 2705acd24bd6dd0898e3f4c04f4dd4f26c3bb006 && git cherry-pick 0d092dc403fae09ce8133a9c89c91d934c7f2f4b
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

#Build GMS
axion ziti userdebug gms pico
ax -b -j$(nproc --all) userdebug

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/GMS/ziti.json .
mv ziti.json ziti_gapps.json
echo "--------------MOVED GAPPS BUILD TO ROOT DIRECTORY--------------"
#Vanilla
axion ziti userdebug va
ax -b -j$(nproc --all) userdebug

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/VANILLA/ziti.json .
mv ziti.json ziti_vanilla.json
echo "--------------MOVED VANILLA BUILD TO ROOT DIRECTORY--------------"