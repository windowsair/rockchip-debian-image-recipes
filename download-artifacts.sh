#!/bin/sh
#
# Downloads the latest artifacts from Collabora GitLab for the image build

BOARD=$1

if [ -z "${BOARD}" ] ; then
    echo "ERROR: provide boardname as first argument"
    exit 1
fi

# Refuse to overwrite already existing prebuilt directory
if [ -d "prebuilt" ] ; then
    echo "ERROR: prebuilt directory exists. Please remove it before running this script."
    exit 1
fi

# Download linux artifacts for rockchip-release and rockchip-devel branches
mkdir -p prebuilt/linux
wget -O prebuilt/linux/linux.zip "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/linux/-/jobs/artifacts/rockchip-release/download?job=build%20arm64%20debian%20package"
unzip -j prebuilt/linux/linux.zip -d prebuilt/linux/
wget -O prebuilt/linux/linux.zip "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/linux/-/jobs/artifacts/rockchip-devel/download?job=build%20arm64%20debian%20package"
unzip -j prebuilt/linux/linux.zip -d prebuilt/linux/
rm prebuilt/linux/linux.zip

# Download u-boot artifacts for the board
mkdir -p prebuilt/u-boot-${BOARD}/
wget -O prebuilt/u-boot-${BOARD}/u-boot.zip "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/u-boot/-/jobs/artifacts/rockchip/download?job=build%20${BOARD}:%20[upstream]"
unzip -j prebuilt/u-boot-${BOARD}/u-boot.zip -d prebuilt/u-boot-${BOARD}/
rm prebuilt/u-boot-${BOARD}/u-boot.zip

# List contents
find prebuilt/
