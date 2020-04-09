# Ubuntu64Pi
Ubuntu64Pi is based on <a href="https://github.com/ChasTechProjects/Debian64Pi">Debian64Pi</a>, a semi-automated script that generates Debian images using a third-party kernel compiled from the RPF source. This is because Debian does not have an official kernel for the Raspberry Pi yet. However, Ubuntu has its own kernel designed to run on Ubuntu and the Raspberry Pi which means it is therefore better to use Ubuntu's optimised kernel when building Ubuntu for the Raspberry Pi.

Ubuntu64Pi takes my existing Debian64Pi script and removes the stages of installing the RPF-sourced kernel and replaces it with the Ubuntu one, as well as change the OS to Ubuntu 20.04 from Debian 10. You can uncomment a desktop option in stage2 to set up a different flavour of Ubuntu, however this requires a larger image file and larger SD card to flash it on than a base, CLI Ubuntu system.

## Stage 0
Stage 0 is not a script, as you must do it manually. This is pretty much the only stage you must do manually, whilst all the other stages are semi or fully automated.

You must first of all determine your system architecture so you know whether you must use qemu-user-static or not. Open a terminal window, and run:

<code>arch</code>

If you have any modern PC or Mac, chances are you are running an x86_64 system. Older PCs, however, 
If the output is aarch64, or arm64, you simply need to install the <i>debootstrap</i> package with the following command:

<code>sudo apt install debootstrap</code>

If, however, the output is x86_64 or amd64, you must install additional support tools to help you run files of the ARM64 file format. Translating that into English, basically it means your computer is by default not compatible with this script and you must install some extra functionality for it to work.

The exact packages you need are <i>qemu-user-static and binfmt-support</i> which can be installed with the following command:

<code>sudo apt install qemu-user-static binfmt-support</code>

Of course, you will also need debootstrap, which can be installed with the command further above.

If the output is i386 or i686 or any other architecture, however, you cannot run 64-bit at all on your 32-bit system and therefore the script won't work at all. The solution? Buy a new PC, even a cheap Intel Atom one with 2GB RAM will do. 64-bit has been the standard for PCs since 2007, and many OSes are dropping support for 32-bit, including Ubuntu. It would be possible to make an armhf (ARM 32-bit) image on these systems however, which can be achieved with some modifications to the script but will not utilise the Raspberry Pi 3 and 4's power to the max.

Next, we need to create the image. A good tool for this is qemu-img, out of the qemu-utils package, which can be installed with the following command:

<code>sudo apt install qemu-utils</code>

Then, cd to the folder you have downloaded this repo into (eg, <i>cd Ubuntu64Pi</i> if downloaded into a folder called <i>Ubuntu64Pi</i>) and run the following:

<code>qemu-img create imagefile.img 4G</code>

You can change imagefile to whatever you want, and if you are installing a desktop environment on your image, you'll probably want to increase the size of the image. For a Lubuntu installation you'll probably want about 6G, while for a full Ubuntu (regular) installation you'll want at least 8GB, maybe more.

Next, you'll need to mount your image as a virtual drive. For example:

<code>sudo losetup -f -P --show imagefile.img</code>

It will tell you the drive name (something like /dev/loop0). Run GParted (install through apt if you haven't got it installed) and create a new partition table, then a new partition of about 240MB in the FAT32 format, then another partition taking up the rest of the unallocated space in the ext4 format. Then apply changes.

If your system auto-mounts partitions, unmount the new partitions once mounted, and run the following command:

<code>sudo mount /dev/loopXp2 /mnt && sudo mkdir -p /mnt/boot/firmware && sudo mount /dev/loopXp1 /mnt/boot/firmware</code>

Replace loopX with the device name given. So if your loop device was given the name of /dev/loop5, use /dev/loop5

## Stage 1

Before you start stage1, if you want to install a desktop environment uncomment one of the lines in stage2.sh for your chosen desktop. Remember, you'll need an image big enough to hold the desktop installation.

Then you'll need to determine whether qemu-debootstrap or debootstrap is needed. If the <i>arch</i> command reported <i>aarch64</i> or <i>arm64</i>, you do not need to modify the script as it is already set to native debootstrap. If it is <i>amd64</i> or <i>x86_64</i>, you must change the first line of stage1.sh so it used the <i>qemu-debootstrap</i> command instead of <i>debootstrap</i>.

Once you've sorted that out, run:

Once you've done, run stage1.sh with the following command:

<code>sudo ./stage1.sh</code>

If you get the error "stage1.sh: command not found" then check you're in the directory the script is downloaded into and try again. If the problem persists, run:

<code>sudo chmod +x *.sh</code>

And then try again.

## Stage 2

Once stage 1 has finished, you will now be in your filesystem. All you must do is run the following once in there:

<code>./stage2.sh</code>

At some point you will be asked for a password for the default user account. Just type ubuntu; you can make your own user account once you've booted the image on your Pi if you want.

## Stage 3

Once the script has finished, type <i>exit</i> into the command prompt to return to your host system and then run:

<code>sudo ./stage3.sh</code>

## Stage 4

Once again there is no script for stage 4 because it depends on what your loopback device is. Just run:

<code>sudo losetup -d /dev/loopX</code> (Replacing X with the number of your device)

You will now have an image ready to flash to your microSD card. Use a tool such as Etcher or dd to flash.
