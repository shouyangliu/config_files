#!/bin/bash

cd ./dwm_own/ && sudo make clean install
cd ../st_own/ && sudo make clean install
cd ../dwmblocks/ && sudo make clean install
cd ../nvim/ && ./install.sh
cd ../rofi/ && ./setup.sh
