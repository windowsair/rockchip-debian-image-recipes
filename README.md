# debian-image-recipes for Rockchip RK3588 boards

Debos recipes to build Debian images for Rockchip RK3588-based boards, as well
as RK3576-based boards.

Currently, only the ROCK 5 Model B (RK3588) and the Sige5 (RK3576) are supported
by the images.

These images can be flashed to an SD card or eMMC.

## Prerequisites

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

### rkdeveloptool
The official vendor tool alternative to RockUSB is [rkdeveloptool](https://github.com/rockchip-linux/rkdeveloptool/),
which includes some features RockUSB lacks, but lacks others. It's recommended
to build it from source, as the `./tools/rkdeveloptool` included in rkbin isn't
always up to date or fully functional.

### udev rules
For both RockUSB and rkdeveloptool, some udev rules are required if rockusb or
rkdeveloptool is to be run as a regular user, and not root.

The following can be saved to e.g. `/etc/udev/rules.d/99-rockusb.rules` in order
to let regular users access Rockchip devices connected over USB:

```
SUBSYSTEM!="usb", GOTO="end_rules"

# RK3036
ATTRS{idVendor}=="2207", ATTRS{idProduct}=="301a", MODE="0666", GROUP="users"
# RK3128
ATTRS{idVendor}=="2207", ATTRS{idProduct}=="310c", MODE="0666", GROUP="users"
# RK3229
ATTRS{idVendor}=="2207", ATTRS{idProduct}=="320b", MODE="0666", GROUP="users"
# RK3288
ATTRS{idVendor}=="2207", ATTRS{idProduct}=="320a", MODE="0666", GROUP="users"
# RK3328
ATTRS{idVendor}=="2207", ATTRS{idProduct}=="320c", MODE="0666", GROUP="users"
# RK3368
ATTRS{idVendor}=="2207", ATTRS{idProduct}=="330a", MODE="0666", GROUP="users"
# RK3399
ATTRS{idVendor}=="2207", ATTRS{idProduct}=="330c", MODE="0666", GROUP="users"
# RK3566
ATTRS{idVendor}=="2207", ATTRS{idProduct}=="350a", MODE="0666", GROUP="users"
# RK3576
ATTRS{idVendor}=="2207", ATTRS{idProduct}=="350e", MODE="0666", GROUP="users"
# RK3588
ATTRS{idVendor}=="2207", ATTRS{idProduct}=="350b", MODE="0666", GROUP="users"

LABEL="end_rules"
```

Afterwards, `udevadm control --reload` should be run as root to reload the
rules, and if the device has already been plugged in, either replugging it or
running `udevadm trigger` will ensure the new rules are in effect.

## Board-specific installation instructions

Please refer to the following documents for instructions on how to install
these images onto the supported boards:

* [ROCK 5B/5B+ Instructions](./README-rock5b.md)
* [ROCK 4D Instructions](./README-rock4d.md)
* [Sige5 Instructions](./README-sige5.md)
* [RK3576 EVB Instructions](./README-rk3576-evb.md)

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
