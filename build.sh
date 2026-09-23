#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf hardware/lineage/compat
rm -rf packages/apps/Updater
rm -rf .repo/local_manifests
rm -rf hardware/qcom/wlan

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/Evolution-X/manifest -b cnb --depth 1 --git-lfs
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b evox-17 .repo/local_manifests
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
git fetch https://github.com/anchalsehrawat/android_hardware_lineage_compat.git -t sixteen && git cherry-pick 6f6bbb4a686ac367383584a183ebe31ee5d4b0e1
croot

cd packages/apps/Updater
git fetch https://github.com/anchalsehrawat/evox_packages_apps_Updater.git && git cherry-pick 29144d48cfffbf5fb16e4d898ebb1d48ec9f9f3e
croot

cd hardware/qcom/wlan
git fetch https://github.com/ziti-resources/android_hardware_qcom_wlan.git && git cherry-pick 7f3966266d7afb91568234e2a3cd093609f7518c
croot

#Vanilla Updater urls
#cd vendor/lineage
#git fetch https://github.com/anchalsehrawat/vendor_evolution.git && git cherry-pick 587744521b5af1293dff08f602087f41b9be2add
#croot

echo "----------------CHERRY-PICKS DONE-----------------"

#Sign Priv Keys
#rm -rf vendor/evolution-priv/keys
#git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/evolution-priv/keys
#cd vendor/evolution-priv/keys
#./keys.sh
#croot

#rm -rf vendor/evolution-priv/keys/
#git clone https://github.com/anchalsehrawat/scripts.git -b exk vendor/evolution-priv/keys

cd vendor/
mkdir evolution-priv/
cd evolution-priv/
rm -rf keys/
wget https://github.com/anchalsehrawat/scripts/releases/download/exk17/exk17.zip
unzip exk.zip
rm exk.zip
croot
echo "-------------Cloned k-------------------"

#Lunch
lunch lineage_ziti-cp2a-userdebug

#ADB 
#export WITH_ADB_INSECURE=true
#For OPcam
export UNSAFE_DISABLE_HIDDENAPI_FLAGS=true

#Build GMS
export WITH_GMS=true
export TARGET_USES_MINI_GAPPS=true
#export TARGET_INCLUDE_LIVE_WALLPAPERS=true

m evolution

mv out/target/product/ziti/*.zip .
#mv out/target/product/ziti/boot.img .
#mv out/target/product/ziti/dtbo.img .
#mv out/target/product/ziti/vbmeta.img .
#mv out/target/product/ziti/vendor_boot.img .
#mv out/target/product/ziti/super_empty.img .
mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_gms.json
echo "--------------MOVED GAPPS BUILD TO ROOT DIRECTORY--------------"

#export WITH_GMS=false
#m evolution

#mv out/target/product/ziti/*.zip .
#mv out/target/product/ziti/ziti.json .
#mv ziti.json ziti_vanilla.json
#echo "--------------MOVED VANILLA BUILD TO ROOT DIRECTORY--------------"
