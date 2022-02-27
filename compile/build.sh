#!/bin/bash

cd ~/src
rm -rf mirai/debug
rm -rf mirai/release
rm loader/loader

cd mirai
gcc tools/enc.c -o tools/enc
./build.sh debug telnet
./build.sh release telnet

cd ../loader
./build.sh

echo finished
