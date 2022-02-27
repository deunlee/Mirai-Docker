#!/bin/bash

cd ~/src

cd mirai
rm -rf debug
rm -rf release
mkdir debug
mkdir release
./build.sh debug telnet
./build.sh release telnet

cd ../loader
rm -f loader
./build.sh

echo
echo finished
