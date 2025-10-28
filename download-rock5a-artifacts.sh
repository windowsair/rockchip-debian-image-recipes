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
wget -O prebuilt/linux/linux.zip "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/linux/-/jobs/artifacts/rockchip-devel/download?job=build%20arm64%20debian%20package"
unzip -j prebuilt/linux/linux.zip -d prebuilt/linux/
rm prebuilt/linux/linux.zip

# Download u-boot artifacts for rock5a-rk3588s
mkdir -p prebuilt/u-boot-rock5a-rk3588s
wget -O prebuilt/u-boot-rock5a-rk3588s/u-boot.zip "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/u-boot/-/jobs/artifacts/rockchip/download?job=build%20rock5a-rk3588s:%20[upstream]"
unzip -j prebuilt/u-boot-rock5a-rk3588s/u-boot.zip -d prebuilt/u-boot-rock5a-rk3588s/
rm prebuilt/u-boot-rock5a-rk3588s/u-boot.zip

# List contents
find prebuilt/
