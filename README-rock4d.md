# ROCK 4D Instructions

## Remove preinstalled bootloader from SPI flash

Some ROCK 4D models come with SPI flash. The SPI flash contains a preinstalled
downstream vendor u-boot, which may cause issues. It's best to remove it if one
wants to use Collabora's images.

### Setting up the board for USB flashing

A USB A-to-A cable needs to be connected from the upper USB 3 port of the board
to a computer. Hold down the Maskrom button (located on the long side of the
board, near the USB host ports), plug in the USB-C power, and then let go of
the Maskrom button. The board should now be in Maskrom mode, which can be
verified with either `rockusb` or `rkdeveloptool`.

With `rkdeveloptool`:

```
$ rkdeveloptool ld
DevNo=1 Vid=0x2207,Pid=0x350e,LocationID=501    Maskrom
```

With `rockusb`:

```
$ rockusb list
Available rockchip devices
* Bus 005 Device 120: ID 2207:350e
```

### Erasing the flash

#### Using rkdeveloptool

`rkdeveloptool` has a dedicated flash erasing command in order to efficiently
clear the SPI flash.

```
$ rkdeveloptool db rk3576_spl_loader_v1.08.106.bin
$ rkdeveloptool ef
```

#### Using rockusb

`rockusb` lacks the flash erasing command. However, a suboptimal solution is
to simply fill the flash with zeroes:

```
$ rockusb download-boot rk3576_spl_loader_v1.08.106.bin
$ head -c 16777216 /dev/zero | rockusb write-file 0 /dev/stdin
```

This is suboptimal as it does not use dedicated erase commands on the flash,
which means it's slower and will count against the flash's write endurance more
heavily.


## Installing the image

The image can be installed onto several different media. However, eMMC can only
be used if the board does not come with SPI flash. Attempting to write to a
connected eMMC module with SPI flash present will not work, and will likely not
be very nice to the SPI flash's write endurance.


### Installing onto eMMC

If the loader binary isn't already loaded into the board's RAM (e.g. from
previously erasing the SPI flash), load it with either

```
$ rockusb download-boot rk3576_spl_loader_v1.08.106.bin
```

or, alternatively with `rkdeveloptool`:

```
$ rkdeveloptool db rk3576_spl_loader_v1.08.106.bin
```

Then, the image can be written to eMMC flash. With `rockusb`:

```
$ rockusb write-bmap image-rockchip-rock4d-rk3576.img.gz
```

or with rkdeveloptool:

```
$ zcat image-rockchip-rock4d-rk3576.img.gz | rkdeveloptool wl 0 /dev/stdin
```


### Installing onto SD card

It appears the ROCK 4D cannot read u-boot from SD cards directly. Due to this,
u-boot must be present on the SPI flash.

If the loader binary isn't already loaded into the board's RAM (e.g. from
previously erasing the SPI flash), load it with either

```
$ rockusb download-boot rk3576_spl_loader_v1.08.106.bin
```

or, alternatively with `rkdeveloptool`:

```
$ rkdeveloptool db rk3576_spl_loader_v1.08.106.bin
```

#### Flashing u-boot to SPI

With `rockusb`:

```
$ rockusb write-file 0 u-boot-rockchip-spi.bin
```

With `rkdeveloptool`:

```
$ rkdeveloptool wl 0 u-boot-rockchip-spi.bin
```

#### Writing the image to SD card

Next, the image can be written to an SD card. Here it's assumed `/dev/sdX` is
the name of the SD card block device; to find the actual devnode, use e.g.
`lsblk`.

To write the image file, [bmaptool](https://github.com/yoctoproject/bmaptool) is
recommended, as it will not needlessly write the holes in the image:

```
$ bmaptool copy image-rockchip-rock4d-rk3576.img.gz /dev/sdX
```

alternatively, the file can be manually written:

```
$ zcat image-rockchip-rock4d-rk3576.img.gz > /dev/sdX && sync
```


### Installing onto UFS

Booting straight off UFS is currently not supported by our images, and neither
is booting a kernel/initramfs located on UFS from a u-boot located on SPI.
However, UFS will still work in Linux. This is not an inherent limitation of the
hardware, but simply remains to be implemented on our u-boot branch.
