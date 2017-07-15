#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Update existing software"
yum -y update

echo "Install epel"
yum -y install epel-release 
yum -y update

# echo "Install tools"
# yum -y install vim sudo wget which net-tools bash-completion nano
# 
# echo "Install git"
# yum -y install git

echo "Install Xfce Desktop"
yum groupinstall -y xfce

echo "Install TigerVNC server"
yum -y install tigervnc-server

# echo "Install Firefox"
# yum -y install firefox

yum clean all
