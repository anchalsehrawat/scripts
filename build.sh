#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf hardware/lineage/compat
rm -rf .repo/local_manifests

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/crdroidandroid/android.git -b 16.0 --git-lfs --no-clone-bundle --depth 1
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b cr-16.2 .repo/local_manifests
echo "-----------------CLONED local manifest-------------------"

#Resync
/opt/crave/resync.sh
echo "---------------RESYNCED-----------------"

#Build Environment
. build/envsetup.sh
echo "---------------BUILD ENVIRONMENT------------------"

rm -rf packages/apps/DolbyAtmos
#Cherry-picks
#hardware_lineage_compat
cd hardware/lineage/compat
git fetch https://github.com/anchalsehrawat/android_hardware_lineage_compat.git -t sixteen && git cherry-pick 6f6bbb4a686ac367383584a183ebe31ee5d4b0e1 6a8ac15383a76806b807aaf70b3f6d98b907ec02
croot

#Sign Priv Keys
rm -rf vendor/lineage-priv/keys
#git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/lineage-priv/keys
#cd vendor/lineage-priv/keys
#./keys.sh
#croot

#rm -rf vendor/lineage-priv/keys
#echo "-------------------Removed ex----------------------"
#git clone https://github.com/anchalsehrawat/scripts.git -b ex-qp2 vendor/evolution-priv/keys
echo "-------------Cloned-------------------"
export TARGET_SUPPORTS_BLUR=true
export TARGET_HAS_UDFPS=true
export UNSAFE_DISABLE_HIDDENAPI_FLAGS=true
brunch ziti

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/boot.img .
mv out/target/product/ziti/dtbo.img .
mv out/target/product/ziti/vbmeta.img .
mv out/target/product/ziti/vendor_boot.img .
mv out/target/product/ziti/super_empty.img .
mv out/target/product/ziti/ziti.json .

echo "--------------MOVED GAPPS BUILD TO ROOT DIRECTORY--------------"
