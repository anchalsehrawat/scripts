#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf .repo/local_manifests
rm -rf out/target/product/ziti
rm -rf hardware/lineage/compat
rm -rf system/core
rm -rf system/update_engine
rm -rf bootable/recovery
rm -rf hardware/qcom-caf/sm8350/audio
echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/PixelOS-AOSP/manifest.git -b fifteen --git-lfs
echo "--------------REPO INITIALISED---------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b aosp-15 .repo/local_manifests
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
git fetch https://github.com/anchalsehrawat/android_hardware_lineage_compat.git && git cherry-pick  9144e5ff7fc4b634e10d4916a3ff6a3ba746af39
croot

#system_core
cd system/core
git fetch https://github.com/anchalsehrawat/rising_android_system_core_new.git && git cherry-pick 34506a6916549d5c23fa1b1978059c558fafde2c
croot

#system_update_engine
cd system/update_engine
git fetch https://github.com/anchalsehrawat/rising_android_system_update_engine.git && git cherry-pick c43c0631ebce21cf4d6e1c9022978d1f937e9214 && git cherry-pick eee2b092e4a0cfcfd10466b376f4d6a7c85f87ca
croot

#bootable_recovery
cd bootable/recovery
git fetch https://github.com/anchalsehrawat/rising_android_bootable_recovery.git && git cherry-pick 106bbd05ac4640a1876cb7caca13172dcc82f250 && git cherry-pick 778a3bc4c6e56a939d05803ba5ed95280e9a505a
croot

#hardware_qcom_audio
cd hardware/qcom-caf/sm8350/audio
git fetch https://github.com/anchalsehrawat/android_hardware_qcom_audio.git && git cherry-pick 701891da604bd9293de528eda30ae474dbd081b7 && git cherry-pick 59e6db40bb02b439ddb8cfea6727f904bcd0197c
croot

#Lunch
breakfast ziti && make installclean && mka bacon -j$(nproc --all)
