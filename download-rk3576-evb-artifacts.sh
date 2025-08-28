#!/bin/sh
#
# Downloads the latest artifacts from Collabora GitLab for the Rockchip RK3576 EVB1
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

# Download u-boot artifacts for evb-rk3576
mkdir -p prebuilt/u-boot-evb-rk3576/
wget -O prebuilt/u-boot-evb-rk3576/u-boot.zip "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/u-boot/-/jobs/artifacts/rockchip/download?job=build%20evb-rk3576:%20[upstream]"
unzip -j prebuilt/u-boot-evb-rk3576/u-boot.zip -d prebuilt/u-boot-evb-rk3576/
rm prebuilt/u-boot-evb-rk3576/u-boot.zip

# List contents
find prebuilt/
