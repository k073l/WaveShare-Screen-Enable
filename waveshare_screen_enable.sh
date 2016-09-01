#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root, just for sure"
  exit
fi

echo "******************"
echo "*WaveShare enable*"
echo "******************"

#script written by k073l  Varad A G from raspberrypi.stackexchange.com helped with system recognition

echo "First make sure you have WaveShare drivers installed and some free space."
echo "For sure install on clean system with drivers"
echo ""
echo "WaveShare SpotPear 3.2"
echo "http://www.waveshare.com/wiki/3.2inch_RPi_LCD_(B)"
echo ""
echo "WaveShare SpotPear 3.5"
echo "http://www.waveshare.com/wiki/3.5inch_RPi_LCD_(A)"
echo ""
echo "WaveShare SpotPear 4"
echo "http://www.waveshare.com/wiki/4inch_RPi_LCD_(A)"
echo "****************************************************"
echo "If you have them installed, continue installation."
echo "If not cancel (Ctrl+C) and go install drivers"
echo "Wait 5 sec"
sleep 5

sudo apt-get install libbsd-dev -y
sudo apt-get install cmake -y

git clone git://github.com/AndrewFromMelbourne/raspi2fb.git
cd raspi2fb
mkdir build
cd build
cmake ..
make

debian_version=`egrep "jessie|wheezy" /etc/os-release`
if [ `echo $debian_version|grep -c "jessie"` == 1 ]
then
   sudo make install
   sudo cp ../raspi2fb@.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable raspi2fb@1.service
   sudo systemctl start raspi2fb@1
elif [ `echo $debian_version|grep -c "wheezy"` == 1 ]
then
   sudo make install
   sudo cp ../raspi2fb.init.d /etc/init.d/raspi2fb
   sudo update-rc.d raspi2fb defaults
   sudo service raspi2fb start
else
   echo "Script checked your system and it's not Raspbian Wheezy or Jessie. Try to open this script with your favorite editor and copy commands to terminal."
fi

echo "It's done. You should see your screen working."
