#!/bin/bash

#MIT License

#Copyright (c) 2022 4D5A

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

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