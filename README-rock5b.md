# ROCK 5B/5B+ Instructions

## Remove preinstalled bootloader from SPI flash

The ROCK 5 Model B comes with an old vendor bootloader installed on the
SPI Flash which can cause incompatibilities with these mainline-based
images. First, remove the eMMC, then get into maskrom mode by holding the
[maskrom button](https://gitlab.collabora.com/hardware-enablement/rockchip-3588/notes-for-rockchip-3588/-/blob/main/rock5b-rk3588.md#maskrom)
while powering on the board through the USB-C port connected to your computer.

If it worked, you should be able to see the board in `rockusb list` or
`rkdeveloptool ld`.


### Erasing SPI flash with rkdeveloptool (recommended)

```
$ rkdeveloptool db rk3588_spl_loader_v1.08.111.bin
$ rkdeveloptool ef
```


### Erasing SPI flash with rockusb

Alternatively, `rockusb` can be used, though it lacks the dedicated flash erase
command. For that reason, the flash is overwritten with zeroes, which is less
gentle to the flash's write cycles and also slower:

```
$ rockusb download-boot rk3588_spl_loader_v1.08.111.bin
$ head -c 16777216 /dev/zero | rockusb write-file 0 /dev/stdin
```


## Installing the image

Several different media can be used to install the image onto. This document
will only cover installing to SD (or eMMC connected through an eMMC to USB
adapter), as installing to eMMC with `rkdeveloptool`/`rockusb` does not appear
to function.


### Installing onto SD or eMMC connected with a USB reader

Here it's assumed `/dev/sdX` is the name of the SD or eMMC card reader block
device; to find the actual devnode, use e.g. `lsblk`.

To write the image file, [bmaptool](https://github.com/yoctoproject/bmaptool) is
recommended, as it will not needlessly write the holes in the image:

```
$ bmaptool copy image-rockchip-rock5b-rk3588.img.gz /dev/sdX
```

alternatively, the file can be manually written:

```
$ zcat image-rockchip-rock5b-rk3588.img.gz > /dev/sdX && sync
```
