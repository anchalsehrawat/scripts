#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf hardware/lineage/compat
rm -rf packages/apps/Updater
rm -rf .repo/local_manifests

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.2 --git-lfs
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b axion-16.2 .repo/local_manifests
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

cd packages/apps/Updater
git fetch https://github.com/anchalsehrawat/evox_packages_apps_Updater.git lineage-23.2 && git cherry-pick f69ef4232aa0ef3c701a577807f35831e2c286c7
croot

echo "----------------CHERRY-PICKS DONE-----------------"

#Generate Private keys
gk -s
echo "-------------------generated ax--------------------"
cd vendor/lineage-priv/
rm -rf keys/
wget https://github.com/anchalsehrawat/scripts/releases/download/axk/axk-20260409.zip 
unzip ax-20260409.zip
rm ax-20260409.zip
croot
#echo "-------------Cloned-------------------"

#For OPcam
export UNSAFE_DISABLE_HIDDENAPI_FLAGS=true

#Build GMS
axion ziti userdebug gms core
ax -b -j$(nproc --all) userdebug

mv out/target/product/ziti/*.zip .
#mv out/target/product/ziti/boot.img .
#mv out/target/product/ziti/dtbo.img .
#mv out/target/product/ziti/vendor_boot.img .
#mv out/target/product/ziti/super_empty.img .
#mv out/target/product/ziti/vbmeta.img .
mv out/target/product/ziti/GMS/ziti.json .
mv ziti.json ax_gms.json
echo "--------------MOVED GAPPS BUILD TO ROOT DIRECTORY--------------"

#Vanilla
#axion ziti userdebug va
#ax -b -j$(nproc --all) userdebug

#mv out/target/product/ziti/*.zip .
#mv out/target/product/ziti/VANILLA/ziti.json .
#mv ziti.json ax_vanilla.json
#echo "--------------MOVED VANILLA BUILD TO ROOT DIRECTORY--------------"
