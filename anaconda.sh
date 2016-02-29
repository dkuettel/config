#!/bin/bash -xeu
echo 'todo: not checking if it's already installed'
cd ~
wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
chmod +x Miniconda-latest-Linux-x86_64.sh
./Miniconda-latest-Linux-x86_64.sh -b
rm Miniconda-latest-Linux-x86_64.sh
pip install --upgrade pip
ln -s ~/miniconda2 ~/anaconda
echo 'for miniconda, the path is ~/miniconda2/bin'
echo 'but there is a canonical symlink at ~/anaconda
