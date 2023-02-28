#!/bin/bash

source ./asset/upgrade.sh

clear
echo -e "${banner}${RESET}"
sleep 2
PS3='Please enter your choice: '
statis=("company-profile-sektema" "company-profile-OmTegar" "company-Profile-Aisyatul" "Quit")
echo "Pilih Apps Yang ingin anda gunakan :"
select statis in "${statis[@]}"; do
    case $statis in
    "company-profile-sektema")
        ./asset/WebStatis/sektema/sektema.sh
        message "Aplikasi Anda Sudah Terinstall Dengan Baik"
        message "Lakukan checking Ulang "
        message "Terimakasih Telah Menggunakan Layanan kami"
        break
        ;;
    "company-profile-OmTegar")
        ./asset/WebStatis/tegar/tegar.sh
        message "Aplikasi Anda Sudah Terinstall Dengan Baik"
        message "Lakukan checking Ulang "
        message "Terimakasih Telah Menggunakan Layanan kami"
        break
        ;;
    "company-Profile-Aisyatul")
        ./asset/WebStatis/aisyatul/aisyatul.sh
        message "Aplikasi Anda Sudah Terinstall Dengan Baik"
        message "Lakukan checking Ulang "
        message "Terimakasih Telah Menggunakan Layanan kami"
        break
        ;;
    "Quit")
        break
        ;;
    esac
done
