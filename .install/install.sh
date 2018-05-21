#! /bin/bash

# archlinux install script

# setup
MAIN_PARTITION=/dev/sda
ROOT_SIZE=10
SWAP_SIZE=2

echo "username: "
read USERNAME
echo
echo

echo "password: "
read -s PASSWORD
echo
echo

echo "hostname: "
read HOSTNAME
echo
echo

AUR_CONFIG_DIR="/home/$USERNAME/.config/aur"

# get time zone
echo "timezone information..."
tzselect > timezone.info
TIMEZONE=$( cat timezone.info )
echo
echo

echo "setting up time..."
timedatectl set-ntp true

# partition disks
echo "partitioning $MAIN_PARTITION..."
cat <<EOF | fdisk $MAIN_PARTITION
o
n
p


+200M
n
p


+${SWAP_SIZE}G
n
p


+${ROOT_SIZE}G
n
p


w
EOF
partprobe

# reformat partitoned disks
echo "formating partitions..."
mkfs.ext4 ${MAIN_PARTITION}4
mkfs.ext4 ${MAIN_PARTITION}3
mkfs.ext4 ${MAIN_PARTITION}1

echo "creating swap space..."
mkswap ${MAIN_PARTITION}2
swapon ${MAIN_PARTITION}2

echo "mounting partitions..."
mount ${MAIN_PARTITION}3 /mnt

# create mount points and mount disks
echo "creating mount points..."
mkdir -p /mnt/boot
mkdir -p /mnt/home

mount ${MAIN_PARTITION}1 /mnt/boot
mount ${MAIN_PARTITION}4 /mnt/home

# install base system
echo "installing archlinux..."
pacstrap /mnt base base-devel

# install the base system
echo "generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# setup hostname
echo $HOSTNAME > /mnt/etc/hostname

# arch-chroot
cat <<EOF > /mnt/archroot_install.sh
#!/bin/bash

# setup time
echo "setting up time"
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# setup hardware clock
echo "setting up hardware clock"
hwclock --systohc

# generate locale
echo "generating locale"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen

# enable dhcpd
systemctl enable dhcpcd

# install grub
echo "installing grub"
pacman --noconfirm --needed -S grub && grub-install --target=i386-pc $MAIN_PARTITION &&  grub-mkconfig -o /boot/grub/grub.cfg

# install user
useradd -m -G wheel -s /bin/bash $USERNAME > /dev/tty6
echo "$USERNAME:$PASSWORD" | chpasswd > /dev/tty6

# add user to sudoers file
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# install programs
pacman --noconfirm --needed -S vim vim-runtime sudo mesa xorg xorg-xinit rofi qutebrowser ranger dialog wpa_supplicant git wget i3status qutebrowser firefox  pulseaudio pulseaudio-alsa
# open ssh, zsh, nvidiam nvidia-libgl

# setup and install pacaur
mkdir -p $AUR_CONFIG_DIR

git clone https://aur.archlinux.org/pacaur.git "$AUR_CONFIG_DIR/pacaur"
git clone https://aur.archlinux.org/cower.git "$AUR_CONFIG_DIR/cower"

sudo chown -R $USERNAME:wheel /home/$USERNAME


exit
EOF

# run the script above
chmod +x /mnt/archroot_install.sh
arch-chroot /mnt ./archroot_install.sh


cat<<EOF > /mnt/home/$USERNAME/install_user.sh

#! /bin/bash
echo "getting gpg signatures"
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53

echo "installing cower - dependency for pacaur"
cd $AUR_CONFIG_DIR/cower
makepkg -si

echo "installing pacaur - aur package manager"
cd $AUR_CONFIG_DIR/pacaur
makepkg -si

# install i3 gaps and st
echo "installing the rest of my programs"
pacaur -S  powerline ttf-inconsolata ttf-linux-libertine vim-pathogen ttf-font-awesome pulseaudio pulseaudio-alsa wget i3status qutebrowser firefox  terminator dmenu rxvt-unicode feh

pacaur -S i3-gaps-next-git

echo "xrdb ~/.Xresources" > /home/$USERNAME/.xinitrc
echo "exec i3" >> /home/$USERNAME/.xinitrc

git clone https://github.com/DieHard073055/dotfiles /tmp
mv /tmp/dotfile/.* ./
mv /tmp/dotfile/* ./

reboot

EOF


chmod +x /mnt/home/$USERNAME/install_user.sh

echo "done installing the system"
echo "please restart and run the install_user.sh in the $USERNAME's home directory"

