# Setup ext4 root filesystem

debootstrap --arch=arm64 eoan /mnt

mount -o bind /proc /mnt/proc
mount -o bind /dev /mnt/dev
mount -o bind /dev/pts /mnt/dev/pts
mount -o bind /sys /mnt/sys

# Make internet available from within the chroot, and setup fstab, hostname, and sources.list

cp /etc/resolv.conf /mnt/etc/resolv.conf
rm /mnt/etc/fstab
rm /mnt/etc/hostname
rm /mnt/etc/apt/sources.list
echo "proc            /proc           proc    defaults          0       0
/dev/mmcblk0p1  /boot/firmware  vfat    defaults          0       2
/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1" >> /mnt/etc/fstab

echo "ubuntu-rpi64" >> /mnt/etc/hostname

echo "deb http://ports.ubuntu.com/ubuntu-ports/ eoan main restricted universe multiverse 
#deb-src http://ports.ubuntu.com/ubuntu-ports/ eoan main restricted universe multiverse 

deb http://ports.ubuntu.com/ubuntu-ports/ eoan-security main restricted universe multiverse 
#deb-src http://ports.ubuntu.com/ubuntu-ports/ eoan-security main restricted universe multiverse 

deb http://ports.ubuntu.com/ubuntu-ports/ eoan-updates main restricted universe multiverse 
#deb-src http://ports.ubuntu.com/ubuntu-ports/ eoan-updates main restricted universe multiverse" >> /mnt/etc/apt/sources.list

# Setup bootloader and overlays

wget http://archive.raspberrypi.org/debian/pool/main/r/raspberrypi-firmware/raspberrypi-bootloader_1.20190925-2_armhf.deb
mkdir /tmp/pi-bootloader/
dpkg-deb -x raspberrypi-bootloader_1.20190925-2_armhf.deb /tmp/pi-bootloader/
cp /tmp/pi-bootloader/boot/* /mnt/boot/
rm raspberrypi-bootloader_1.20190925-2_armhf.deb

wget https://github.com/ChasTechProjects/Ubuntu64Pi/releases/download/overlays2020/overlays.zip
mkdir /mnt/boot/firmware/overlays
unzip overlays.zip -d /mnt/boot/firmware/overlays/
rm overlays.zip

# Setup config.txt

echo "arm_64bit=1
kernel=vmlinuz
initramfs initrd.img followkernel
dtoverlay=vc4-fkms-v3d
#disable_overscan=1
#gpu_mem=384" >> /mnt/boot/firmware/config.txt

# Copy stage2 to chroot environment

cp stage2.sh /mnt/
echo "Run stage2.sh in chroot for stage 2."
chroot /mnt
