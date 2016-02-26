#!/bin/bash -xeu
cd ~
wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
chmod +x Miniconda-latest-Linux-x86_64.sh
./Miniconda-latest-Linux-x86_64.sh -b
rm Miniconda-latest-Linux-x86_64.sh
pip install --upgrade pip
echo 'for miniconda, the path is ~/miniconda2/bin'
