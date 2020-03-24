# Apt install core packages

apt update
apt upgrade -y 
apt install ubuntu-standard linux-raspi2
apt install wpasupplicant wireless-tools linux-firmware dhcpcd5 net-tools -y

# Uncomment one of these to install a Desktop Environment

#apt install xubuntu-desktop -y # For Xubuntu
#apt install ubuntu-desktop -y # For regular Ubuntu
#apt install kubuntu-desktop -y # For Kubuntu
#apt install ubuntu-mate-desktop -y # For Ubuntu MATE
#apt install lubuntu-desktop -y # For Lubuntu
#apt install ubuntu-budgie-desktop -y # For Ubuntu Budgie

# Setup default user; this step does require a bit of user interaction for password and user info

adduser ubuntu
usermod -aG sudo,video,audio,cdrom ubuntu
echo "Now, exit the chroot and run stage3.sh."
