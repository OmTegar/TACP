#!/bin/bash
source ./asset/upgrade.sh

clear
echo -e "${banner}${RESET}"
sleep 2

git stash
git pull
message "Package TACP Sudah Berhasil Di Update
Silahkan Ulangi Perintah di bawah :
1. chmod +x index.sh
2. sudo ./index.sh"
