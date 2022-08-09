#!/bin/bash
echo "Looking for updates."
sudo apt-get -qq update
requiredpackages=(
    software-properties-common
    wget
    curl
    gpg
    apt-transport-https
    )
echo "Installing required packages."
for requiredpackage in "${requiredpackages[@]}"
do
    echo "Installing $requiredpackage."
    sudo apt-get -qq install $requiredpackage
done
echo "Adding repositories"
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

echo "Looking for updates."
sudo apt-get -qq update
packages=(
    clamav
    clamtk
    python3
    terminator
    timeshift
    nano
    thunderbird
    firefox
    brave-browser
    code
    gnome-tweak-tool
    audacity
    libreoffice
    vlc
    wireshark
    wireshark-common
    traceroute
    powershell
    screen
    hping3
    openssh-client
    )
echo "Installing packages."
for package in "${packages[@]}"
do
    echo "Installing $package."
    sudo apt-get -qq install $package
done
sudo apt-get upgrade -qq