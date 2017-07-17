#!/bin/bash
### every exit != 0 fails the script
set -e

rstudio=https://download1.rstudio.org/rstudio-1.0.143-x86_64.rpm
mkdir rstudio
cd rstudio
wget $rstudio
rpm -i $rstudio
cd ..
rm -rf rstudio
