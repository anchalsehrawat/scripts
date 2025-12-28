#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf hardware/lineage/compat
rm -rf .repo/local_manifests
rm -rf system/core
rm -rf system/update_engine
rm -rf packages/apps/Updater
#rm -rf prebuilts/clang/host/linux-x86
#rm -rf bootable/recovery

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.1 --git-lfs
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b axion-16.1 .repo/local_manifests
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
#git fetch https://github.com/anchalsehrawat/evox_bootable_recovery.git lineage-23.0 && git cherry-pick e65c158410d3e7b3d8cc733c6479472126c12cec && git cherry-pick 156301ca7ee62a1e01c14b1beaa99b838892d981 && git cherry-pick 65f6022dd5da75631a53c7b7b0462a86a2863bff
#croot

#system_core
cd system/core
git fetch https://github.com/anchalsehrawat/evox_system_core.git && git cherry-pick 978f6b40ba6531490a6c3588f7bb14aa10b279cf
croot

#system_update_engine
cd system/update_engine
git fetch https://github.com/anchalsehrawat/android_system_update_engine.git && git cherry-pick d804cc2a02e0e94c2d8e9ba47175f3946954306d && git cherry-pick d526f28031438c184746cfe6a038186598180fe6
croot

#For OTA Updates
#Apps Updater
cd packages/apps/Updater
git fetch https://github.com/anchalsehrawat/evox_packages_apps_Updater.git lineage-23.0 && git cherry-pick 706c87119a6871f20e40c8f638cc267c78910e7d
croot

echo "----------------CHERRY-PICKS DONE-----------------"

#Generate Private keys
gk -s
echo "-------------------generated ax--------------------"
rm -rf vendor/lineage-priv/keys
echo "-------------------Removed ax----------------------"
git clone https://github.com/anchalsehrawat/scripts.git -b ax vendor/lineage-priv/keys
echo "-------------Cloned-------------------"

#For OPcam
export UNSAFE_DISABLE_HIDDENAPI_FLAGS=true

#Build GMS
axion ziti userdebug gms pico
ax -b -j$(nproc --all) userdebug

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/GMS/ziti.json .
mv ziti.json ax_gms.json
echo "--------------MOVED GAPPS BUILD TO ROOT DIRECTORY--------------"

#Vanilla
axion ziti userdebug va
ax -b -j$(nproc --all) userdebug

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/VANILLA/ziti.json .
mv ziti.json ax_vanilla.json
echo "--------------MOVED VANILLA BUILD TO ROOT DIRECTORY--------------"
