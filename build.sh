#!/bin/bash

#Build Script for ziti (OPNCE3)
#Remove files
rm -rf .repo/local_manifests
rm -rf hardware/lineage/compat
rm -rf hardware/qcom-caf/sm8350/audio
rm -rf frameworks/base
rm -rf packages/apps/Settings/YASP
rm -rf vendor/themes
rm -rf vendor/yaap
rm -rf packages/apps/Settings
rm -rf frameworks/av
rm -rf packages/apps/OpenDelta

#echo "----------------DELETED DIRECTORIES----------------"

#Initialise repos
repo init -u https://github.com/yaap/manifest.git -b sixteen --git-lfs --depth 1
echo "-----------------REPO INITIALISED------------------"

#Local Manifest
git clone https://github.com/anchalsehrawat/local_manifests --depth 1 -b yaap-16.2 .repo/local_manifests
echo "--------------CLONED local manifest----------------"

#Resync
/opt/crave/resync.sh
#echo "---------------------RESYNCED----------------------"
#Build Environment
. build/envsetup.sh
echo "---------------BUILD ENVIRONMENT-------------------"

#Cherry-picks
cd hardware/lineage/compat
git fetch https://github.com/anchalsehrawat/android_hardware_lineage_compat.git -t sixteen && git cherry-pick 6f6bbb4a686ac367383584a183ebe31ee5d4b0e1 6a8ac15383a76806b807aaf70b3f6d98b907ec02
croot

cd hardware/qcom-caf/sm8350/audio
git fetch https://github.com/anchalsehrawat/hardware_qcom-caf_sm8350_audio.git && git cherry-pick f7180029ac6507243fc5d594933a53a31d67918d
croot

cd frameworks/base
git fetch https://github.com/anchalsehrawat/frameworks_base.git --depth 5 && git cherry-pick 5aed5b38b5b6e0d5a6755d4d2729127ad4fddb78
git fetch https://github.com/mvimal2607/frameworks_base.git --depth 4 && git cherry-pick aa688eeb432c9279db86e684c9af586e39aba1e3
git fetch https://github.com/F6-test/frameworks_base_yaap.git && git cherry-pick 0cdd5842df667c1d0b77049f3cf2f066606e51d0 e07aecaba95ea4a10fbbdf7956f55ac5e5c83f71 a218152c6efc803126e1c48981ce13acea12a89c 0cb37d34d846aaf885376041935ed658648aba94 fb548d7e12014daaecec89395e6b8319c77d698b aeeffa1e2c62a4f81e3da5103242db93a7b9f056 && git cherry-pick cf5eb51461a356f29679b909f20ade01d28ea151^..e4a568caf2c60ade66a07837de17a0ab6bf50e98
croot

cd packages/apps/Settings/YASP
git fetch https://github.com/F6-test/packages_apps_YASP.git --depth 4 && git cherry-pick afa28fe17d914b5680e51c8ecfb98553cc00c3ff
croot

cd vendor/themes
git fetch https://github.com/F6-test/yaap-vendor_themes.git --depth 5 && git cherry-pick 62dee48a402808ed8b117f8208b015a15ca75ae6
croot

cd vendor/yaap
git fetch https://github.com/anchalsehrawat/vendor_yaap.git && git cherry-pick 74eeddb39c9ccf66d0cf00dd21cfb44f7136f794 f20efeb17d78268f3b922af169f6de6b6070ba8e
git fetch https://github.com/F6-test/vendor_yaap.git --depth 10 && git cherry-pick 9fcb4d5ac273eb466a3392c2dc4e05338a4556f2
croot

cd packages/apps/Settings
git fetch https://github.com/F6-test/yaap_apps_Settings.git --depth 10 && git cherry-pick 05da52a7792824f67fe2e660f278a5b0d2fe7f52^..0e6359599fc63c65c4e669ae1941186f87b98582
croot

cd frameworks/av
git fetch https://github.com/F6-test/yaap_frameworks_av.git --depth 20 && git cherry-pick 14acca79f4da7a9725a44fb306ffb3efbe6a4e12^..b43ba24a75c855fc10d61594997a55601cf011f7
croot

cd packages/apps/OpenDelta
git fetch https://github.com/anchalsehrawat/packages_apps_OpenDelta.git && git cherry-pick d6347c0d71f7997d7b8a7de45db9fc7168a75674
croot

#echo "----------------CHERRY-PICKS DONE------------------"

rm -rf vendor/yaap/signing/keys
git clone https://github.com/anchalsehrawat/scripts.git -b yp vendor/yaap/signing/keys

lunch yaap_ziti-user
export UNSAFE_DISABLE_HIDDENAPI_FLAGS=true
export TARGET_BUILD_GAPPS=true
m yaap

cp -r out/target/product/ziti/YAAP-16* .
mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_gms.json
echo "---------------GMS BUILD COMPLETE--------------"

lunch yaap_ziti-user
export UNSAFE_DISABLE_HIDDENAPI_FLAGS=true
export TARGET_BUILD_GAPPS=false
m yaap

mv out/target/product/ziti/ziti.json .
mv ziti.json ziti_vanilla.json
echo "---------------VANILLA BUILD COMPLETE------------------"
