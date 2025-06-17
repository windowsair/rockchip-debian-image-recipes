# Sige5 Instructions


## Installing the image

The image can either be written to the soldered on eMMC, or to an SD card.


### Installing onto eMMC

#### Entering MaskROM mode

First, the board needs to be brought into MaskROM mode. Connect a USB-C data
cable from your computer to the USB-C port that's placed closer towards the
center of the board, labelled "TYPE-C" and not "DCIN".

Next, hold the button labelled "MaskROM" (situated close to the Ethernet port)
while plugging in a USB-C power supply to the "DCIN" port. Release the MaskROM
button. The board should now show up in either `rockusb list` or
`rkdeveloptool ld`.


#### Flashing the image

`rockusb` is recommended for this process:

```
$ rockusb download-boot rk3576_spl_loader_v1.08.106.bin
$ rockusb write-bmap image-rockchip-sige5-rk3576.img.gz
```

The board can now be reset with `rockusb reset-device`, and should boot into
debian.


### Installing onto SD

To install onto an SD card, insert the SD into a USB SD reader connected to your
computer. Here it's assumed `/dev/sdX` is the name of the SD or eMMC card reader
block device; to find the actual devnode, use e.g. `lsblk`.

To write the image file, [bmaptool](https://github.com/yoctoproject/bmaptool) is
recommended, as it will not needlessly write the holes in the image:

```
$ bmaptool copy image-rockchip-sige5-rk3576.img.gz /dev/sdX
```

alternatively, the file can be manually written:

```
$ zcat image-rockchip-sige5-rk3576.img.gz > /dev/sdX && sync
```
