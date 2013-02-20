#!/bin/bash

mkdir konoha3/build
cd konoha3/build
cmake ..
make
sudo make install
