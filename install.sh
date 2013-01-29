#!/bin/bash

mkdir minikonoha/build
cd minikonoha/build
cmake ..
make
sudo make install
