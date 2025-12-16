#!/bin/sh
#
# Downloads the latest artifacts from Collabora GitLab for the image build

BOARD=$1
DOWNLOAD_LINUX_REPO=windowsair/rk3588-linux
DOWNLOAD_LINUX_BRANCH=rk-v6.15
DOWNLOAD_LINUX_CI_NAME=ci.yml
DOWNLOAD_LINUX_ARTIFACT_NAME=build-arm64-debian-package

if [ -z "${BOARD}" ] ; then
    echo "ERROR: provide boardname as first argument"
    exit 1
fi

# Refuse to overwrite already existing prebuilt directory
if [ -d "prebuilt" ] ; then
    echo "ERROR: prebuilt directory exists. Please remove it before running this script."
    exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "You are not logged into any GitHub hosts. To log in, run: gh auth login"
  exit 1
fi

# Download linux artifacts
mkdir -p prebuilt/linux
LINUX_RUN_ID=$(gh run list -R "$DOWNLOAD_LINUX_REPO" -w "$DOWNLOAD_LINUX_CI_NAME" --branch "$DOWNLOAD_LINUX_BRANCH" \
    -L 1 --status success --json databaseId -q '.[0].databaseId')
gh run download "$LINUX_RUN_ID" -R "$DOWNLOAD_LINUX_REPO" -n "$DOWNLOAD_LINUX_ARTIFACT_NAME" -D prebuilt/linux

# Download u-boot artifacts for the board
mkdir -p prebuilt/u-boot-${BOARD}/
wget -O prebuilt/u-boot-${BOARD}/u-boot.zip "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/u-boot/-/jobs/artifacts/rockchip/download?job=build%20${BOARD}:%20[upstream]"
unzip -j prebuilt/u-boot-${BOARD}/u-boot.zip -d prebuilt/u-boot-${BOARD}/
rm prebuilt/u-boot-${BOARD}/u-boot.zip

# List contents
find prebuilt/
