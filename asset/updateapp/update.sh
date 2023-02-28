#!/bin/bash
source ./asset/upgrade.sh

clear
echo -e "${banner}${RESET}"
sleep 2

git stash
git pull
message "Package TACP Sudah Berhasil Di Update"
message "Silahkan Ulangi Perintah di bawah :"
message "1. chmod +x index.sh"
message "2. sudo ./index.sh"
