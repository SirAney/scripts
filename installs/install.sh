# This install script is for a debian based distro
# ideally a minimal install

# Ask what wants to be installed, then if statement each section. Test.
# Basic, GUI, 
#echo "What do you want to install??\n"
# ask for username

# Install X and sudo so other things can work
apt install sudo xorg build-essential -y

# Update baybee
apt update && upgrade -y

# Add the user to sudo?
adduser nathan sudo

# Terminal shit
apt install perl tmux vim neofetch htop wget -y
apt install git tig zsh curl -y

# Firewall
apt install ufw -y
systemctl --now enable ufw
ufw enable
ufw default deny incoming
ufw default allow outgoing
ufw allow 22
# ufw status

# Additional filesystem stuff
apt install cifs-utils jmtpfs nemo -y

# Tools
apt install gzip zip tar -y

# Mail
apt install neomutt thunderbird -y

# Bluetooth
apt install blueman -y

# Music player, rss feed
apt install mpd mpc ncmpcpp newsboat  -y

# Video player 
apt install mpv -y

# Youtube-dl
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl

# Screencap and screenshots 
apt install ffmpeg maim slop -y

# Image viewer, PDF Reader (GUI)
apt install feh zathura -y

# Text tools
apt install groff -y

# Network Tools
#apt install net-tools wicd -y
apt install network-manager -y

# Audio
apt install alsa-utils alsa-oss pulseaudio -y

# Pulseaudio GUI
apt install pavucontrol -y 

# Random shit
apt install gtypist screenkey -y

# Backups
apt install rsync syncthing -y

# PC connections
apt install ssh -y #remmina tigervnc-viewer -y

# Notifications
apt install dunst libnotify-bin -y

# Media tools
# Graphics
apt install gimp -y
# Game Editor
#apt install godot3 -y
# This wants to be the most up-to date, so download from the site...

# Compositor
apt install compton -y
# This wants to be picom ideally, but debian lul
# Get the .config/compton.conf too

# Suckless pre-requisites
apt install libx11-dev libxft-dev libxinerama-dev -y
apt install libx11-xcb-dev libxcb-res0-dev -y

# Torrenting 
apt install transmission-daemon transmission-cli transmission-remote-cli -y

#systemctl stop transmission-daemon.service
#/lib/systemd/system/tranmission-daemon.service # Change debian-transmission to $USER
# systemctl daemon-reload
# start/restart service
# /etc/transmission-daemon/settings.json # edit whitelist, blocklist, password

# Setup the user for transmission-daemon

# VPN
apt install openvpn -y
# Add the .ovpn/.conf files?

# Virtualisation
apt install qemu-kvm libvirt-clients libvirt-daemon-system virt-manager -y
# Add to virtualisation groups
adduser nathan libvirt
adduser nathan libvirt-qemu

# brave-browser
apt install apt-transport-https -y
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
apt update
apt install brave-browser -y

# firefox
apt install firefox-esr -y

# Xanmod Kernel
echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list && wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key add -
apt update && apt install linux-xanmod -y

#####

# Fake user installs
userdo() {
	sudo -H -u nathan bash -c "$1"
}

# User
#su nathan 
HOME=/home/nathan

mkdir2() {
	for DIR
	do
		if [ ! -d $DIR ]; then
			mkdir $DIR 
		fi
	done
}

# Create directories
sudo -H -u nathan bash -c "cd ~"
mkdir2 books/ documents/ downloads/ misc/ music/ pictures/ recordings/ video/
touch recordings/.recording_status

# Temp, so startx works
echo "exec dwm" > $HOME/.xinitrc

# Set location to download source code and other repos
REPO=$HOME/agitrepo
sudo -H -u nathan bash -c "mkdir $REPO"

# Suckless installs
# Not sure how to do the intsall without sudo prompt...
# dwm
sudo -H -u nathan bash -c "git clone https://git.suckless.org/dwm $REPO/adwm"
cd $REPO/adwm/
make clean install

# st terminal
sudo -H -u nathan bash -c "git clone https://git.suckless.org/st $REPO/ast"
cd $REPO/ast/
make clean install

# dmenu launcher
sudo -H -u nathan bash -c "git clone https://git.suckless.org/dmenu $REPO/admenu"
cd $REPO/admenu/
make clean install

# slstatus
sudo -H -u nathan bash -c "git clone https://git.suckless.org/slstatus $REPO/aslstatus"
cd $REPO/aslstatus/
make clean install

# Setup the bin directory for custom scripts
sudo -H -u nathan bash -c "mkdir $HOME/.local/bin"
# Vi mode terminal and local bin # This also happens in dotfiles, so kinda redundant
echo "set -o vi\nexport PATH=\$HOME/.local/bin:\$PATH" >> .zshrc
echo "export PATH=\$HOME/.local/bin/*:\$PATH" >> .zshrc
# Add to path for this session
export PATH=\$HOME/.local/bin/:$PATH
export PATH=\$HOME/.local/bin/dmenu:$PATH

# Muh scripties
sudo -H -u nathan bash -c "git clone https://github.com/aney/scripts $REPO/ascripts/"
# create a sym link. Will change to cp if others start using my install.sh
ln -s $REPO/ascripts/dmenu/ $HOME/.local/bin/
ln -s $REPO/ascripts/config/ $HOME/.local/bin/
ln -s $REPO/ascripts/backup/ $HOME/.local/bin/

# lf file manager
# Download a pre-built binary
sudo -H -u nathan bash -c "curl -LO https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz | tar xzC $HOME/.local/bin"

# Change default shell to zsh
chsh nathan -s /bin/zsh

# dotfiles
# This will overwrite existing dotfiles...
sudo -H -u nathan bash -c "git clone https://github.com/aney/dotfiles $REPO/adotfiles/"
ln -s $REPO/adotfiles/.[^.]* $HOME

# Oh my Zsh
sudo -H -u nathan bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Extras. Bg image, icons, etc. 
sudo -H -u nathan bash -c "$(curl 'https://pixabay.com/get/57e8d7414c51aa14f6d1867dda3536781539dbe35552754b_1920.jpg' $HOME/pictures/wallpapers/barren.jpg)"

# Notes for me and me alone
# WFH
# slack, discord, remmina, teamviewer, linphone (or alternative softphone)
