#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf hardware/lineage/compat
rm -rf .repo/local_manifests
rm -rf prebuilts/clang/host/linux-x86
rm -rf hardware/qcom-caf/sm8350/audio

echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/yaap/manifest.git -b sixteen --git-lfs
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b yaap-16 .repo/local_manifests
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

echo "----------------CHERRY-PICKS DONE-----------------"

#Lunch
lunch yaap_ziti-userdebug

#Build GMS
export WITH_GMS=true
m yaap

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_gms.json
echo "--------------MOVED GAPPS BUILD TO ROOT DIRECTORY--------------"

export WITH_GMS=false
m yaap

mv out/target/product/ziti/*.zip .
mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_vanilla.json
echo "--------------MOVED VANILLA BUILD TO ROOT DIRECTORY--------------"
