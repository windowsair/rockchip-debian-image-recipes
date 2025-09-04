# Rockchip RK3576 Evaluation Board (EVB) Instructions

The board has two mass storage options:

1. UFS
2. MicroSD card slot

The system always boots from UFS. The vendor U-Boot SPL will then check if an
MicroSD card is plugged and has U-Boot at the right offset and continue booting
from there, otherwise it will continue booting from UFS. This effectively means
that booting from the MicroSD card slot is preferred.

## Maskrom Mode

For Maskrom mode the USB-C port next to the camera module (opposite of the
MicroSD card slot) needs to be used. Then the Maskrom button (directly next
to the MicroSD card slot) needs to be pressed while the board is powered up.
The board should now be in Maskrom mode, which can be verified with either
`rockusb` or `rkdeveloptool`.

With `rkdeveloptool`:

```
$ rkdeveloptool ld
DevNo=1	Vid=0x2207,Pid=0x350e,LocationID=104	Maskrom
```

With `rockusb`:

```
$ rockusb list
Available rockchip devices
* Bus 001 Device 037: ID 2207:350e
```

## Installing an Image

### Writing the image to SD card

The image can be written to an SD card. Here it's assumed `/dev/sdX` is the
name of the SD card block device; to find the actual devnode, use e.g. `lsblk`.

To write the image file, [bmaptool](https://github.com/yoctoproject/bmaptool) is
recommended, as it will not needlessly write the holes in the image:

```
$ bmaptool copy image-rockchip-evb-rk3576.img.gz /dev/sdX
```

alternatively, the file can be manually written:

```
$ zcat image-rockchip-evb-rk3576.img.gz > /dev/sdX && sync
```

### Writing the image to UFS

This is currently not supported as upstream U-Boot is missing UFS support.
Details can be found in [issue:u-boot/6].
