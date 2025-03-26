#!/bin/sh
#
# Downloads the latest artifacts from Collabora GitLab for the Radxa Rock 5B
# image build
#

# Refuse to overwrite already existing prebuilt directory
if [ -d "prebuilt" ] ; then
    echo "ERROR: prebuilt directory exists. Please remove it before running this script."
    exit 1
fi

# Download linux artifacts
mkdir -p prebuilt/linux
wget -O prebuilt/linux/linux.zip "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/linux/-/jobs/artifacts/rockchip-release/download?job=build%20arm64%20debian%20package"
unzip -j prebuilt/linux/linux.zip -d prebuilt/linux/

# Download u-boot artifacts for rock5b-rk3588
mkdir -p prebuilt/u-boot-rock5b-rk3588
wget -O prebuilt/u-boot-rock5b-rk3588/u-boot.zip "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/u-boot/-/jobs/artifacts/rk3588/download?job=build%20rock-5b%20with%20upstream%20TF-A"
unzip -j prebuilt/u-boot-rock5b-rk3588/u-boot.zip -d prebuilt/u-boot-rock5b-rk3588/

# List contents
find prebuilt/
