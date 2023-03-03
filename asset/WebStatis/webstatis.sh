#!/bin/bash

source ./asset/upgrade.sh

clear
echo -e "${banner}${RESET}"
sleep 2
PS3='Please enter your choice: '
statis=("Company Profile Sektema" "Company Profile OmTegar" "Company Profile Aisyatul" "Mini Games By OmTegar ( Basics )" "Quit")
echo "Pilih Apps Yang ingin anda gunakan :"
select statis in "${statis[@]}"; do
    case $statis in
    "Company Profile Sektema")
        ./asset/WebStatis/sektema/sektema.sh
        message "Aplikasi Anda Sudah Terinstall Dengan Baik"
        message "Lakukan checking Ulang "
        message "Terimakasih Telah Menggunakan Layanan kami"
        break
        ;;
    "Company Profile OmTegar")
        ./asset/WebStatis/tegar/tegar.sh
        message "Aplikasi Anda Sudah Terinstall Dengan Baik"
        message "Lakukan checking Ulang "
        message "Terimakasih Telah Menggunakan Layanan kami"
        break
        ;;
    "Company Profile Aisyatul")
        ./asset/WebStatis/aisyatul/aisyatul.sh
        message "Aplikasi Anda Sudah Terinstall Dengan Baik"
        message "Lakukan checking Ulang "
        message "Terimakasih Telah Menggunakan Layanan kami"
        break
        ;;
    "Mini Games By OmTegar ( Basics )")
        ./asset/WebStatis/games/games.sh
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
