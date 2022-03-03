#!/bin/bash

cd ~/src/mirai/tools

if [ ! -f ./enc ]; then
    gcc enc.c -o enc
fi

./enc $1 $2
