#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf hardware/lineage/compat
rm -rf packages/apps/Updater
rm -rf .repo/local_manifests
#rm -rf prebuilts/clang/host/linux-x86

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/PixelOS-AOSP/android_manifest.git -b sixteen-qpr2 --git-lfs
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b aosp-16.2 .repo/local_manifests
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

#For OTA Updates
#Apps Updater
cd packages/apps/Updater
git fetch https://github.com/anchalsehrawat/android_packages_apps_Updater.git && git cherry-pick eaf3e38aa252fac7bf11ff74185eff63065d718e
croot

echo "----------------CHERRY-PICKS DONE-----------------"
#Sign Priv Keys
#rm -rf vendor/lineage-priv/keys
#echo "-------------------Removed pos----------------------"
#git clone https://github.com/anchalsehrawat/scripts.git -b aospk vendor/lineage-priv/keys
#cd vendor/lineage-priv/keys
#./gen_keys.py
#croot
rm -rf vendor/lineage-priv/keys
cd vendor
mkdir lineage-priv/
cd lineage-priv/
wget https://github.com/anchalsehrawat/scripts/releases/download/pix/pixkey.zip
unzip pixkey.zip
rm pixkey.zip
croot

echo "-------------Cloned-------------------"
#For OPcam
export UNSAFE_DISABLE_HIDDENAPI_FLAGS=true
breakfast ziti
m pixelos

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/boot.img .
mv out/target/product/ziti/dtbo.img .
mv out/target/product/ziti/vbmeta.img .
mv out/target/product/ziti/vendor_boot.img .
mv out/target/product/ziti/super_empty.img .

echo "--------------MOVED BUILD TO ROOT DIRECTORY--------------"
