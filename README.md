# debian-image-recipes for Rockchip RK3588 boards

Debos recipes to build Debian images for Rockchip RK3588-based boards, as well
as RK3576-based boards.

Currently, only the ROCK 5 Model B (RK3588) and the Sige5 (RK3576) are supported
by the images.

These images can be flashed to an SD card or eMMC.

## Using the images

### Prebuilt images
See the [CI/CD pipelines](https://gitlab.collabora.com/hardware-enablement/rockchip-3588/debian-image-recipes/-/pipelines)
to download prebuilt images for your target. Extract the archive somewhere.

### RockUSB
It is recommended to use `rockusb` from the [rockchiprs](https://github.com/collabora/rockchiprs)
Rust crate to flash the images to the board. It can be installed with:
```
$ cargo install rockusb --example rockusb --features=libusb
```

By default, the resulting rockusb binary will be placed in `~/.cargo/bin`. It's
a good idea to add this directory to your `$PATH` if you haven't already.

### Remove preinstalled bootloader from SPI Flash
The ROCK 5 Model B comes with an old vendor bootloader installed on the
SPI Flash which can cause incompatibilities with these mainline-based
images. To remove the bootloader from the SPI flash, remove the eMMC,
press the [maskrom button](https://gitlab.collabora.com/hardware-enablement/rockchip-3588/notes-for-rockchip-3588/-/blob/main/rock5b-rk3588.md#maskrom),
plug the board into USB port and run:

```
$ rkdeveloptool db rk3588_spl_loader_v1.08.111.bin
$ rkdeveloptool ef
```

### Install to eMMC

Press & hold the board's [maskrom button](https://gitlab.collabora.com/hardware-enablement/rockchip-3588/notes-for-rockchip-3588/-/blob/main/rock5b-rk3588.md#maskrom) before applying power. Once the board is in maskrom mode, release the button.

```
$ rockusb list
Available rockchip devices
* Bus 006 Device 014: ID 2207:350b

$ rockusb download-boot rk3588_spl_loader_v1.08.111.bin
0 Name: UsbHead
Done!... waiting 1ms
1 Name: rk3588_ddr_lp4_2112M
Done!... waiting 1ms
0 Name: rk3588_usbplug_v1
Done!... waiting 0ms

$ rockusb write-bmap image-rockchip-rock5b-rk3588.img.gz

$ rockusb reset
```

The process for the Sige5 and ROCK 4D boards is similar, but substituting the
loader with the `rk3576_spl_loader_*` binary and the image with the
`image-rockchip-sige5-rk3576.img.gz` or `image-rockchip-rock4d-rk3576.img.gz`
files respectively.

### Install to SD card
Copy the image to an SD card using `bmaptool`, assuming `/dev/sdX` as the
target block device:
```
# For ROCK 5B
$ bmaptool copy image-rockchip-rock5b-rk3588.img.gz /dev/sdX
# For Sige5
$ bmaptool copy image-rockchip-sige5-rk3576.img.gz /dev/sdX
# For ROCK 4D
$ bmaptool copy image-rockchip-rock4d-rk3576.img.gz /dev/sdX
```

## Using the images

The default username is `user`, with the password `user`.

The root partition and filesystem is resized on first boot to take up all
remaining space on the medium the image has been installed to.

An sshd runs on the default port of 22. The serial console is accessible at
1.5Mbauds (1500000 baud). The board will announce itself over mDNS, so
```bash
$ ssh user@debian-rockchip-rock5b-rk3588.local
```
will work if your system has mDNS resolution enabled.

## Building the images

### System requirements
On a Debian (bookworm preferred) system, install debos:
```bash
$ sudo apt install debos
```

### Locally build images
The first stage is to build a generic (but architecture-specific) ospack, then
assemble the ospack into multiple hardware-specific images.

Linux kernel and u-boot binaries for your specific platform needs to be copied
into the `prebuilt` directory. See the corresponding `download-*-artifacts.sh`
file for the directory layout.


```bash
$ mkdir out
$ debos --artifactdir=out -t architecture:arm64 ospack-debian.yaml
$ ./download-rock5b-artifacts.sh
$ debos --artifactdir=out -t architecture:arm64 -t platform:rock5b-rk3588 image-rockchip-rk3588.yaml
$ ./download-sige5-artifacts.sh
$ debos --artifactdir=out -t architecture:arm64 -t platform:sige5-rk3576 image-rockchip-sige5-rk3576.yaml
$ ./download-rock4d-artifacts.sh
$ debos --artifactdir=out -t architecture:arm64 -t platform:rock4d-rk3576 image-rockchip-rock4d-rk3576.yaml
```
