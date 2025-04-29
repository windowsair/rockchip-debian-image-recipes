#!/bin/sh
#
# Downloads the latest artifacts from Collabora GitLab for the ArmSom Sige 5
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

# Download u-boot artifacts for sige5-rk3576
mkdir -p prebuilt/u-boot-sige5-rk3576/
wget -O prebuilt/u-boot-sige5-rk3576/u-boot.zip "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/u-boot/-/jobs/artifacts/rk3576-images/download?job=build%20armsom-sige5"
unzip -j prebuilt/u-boot-sige5-rk3576/u-boot.zip -d prebuilt/u-boot-sige5-rk3576/

# List contents
find prebuilt/
