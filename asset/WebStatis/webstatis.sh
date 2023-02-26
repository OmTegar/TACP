#!/bin/bash

source ./asset/upgrade.sh

clear
echo -e "${banner}${RESET}"
sleep 2
statis=("company-profile-sektema" "company-profile-OmTegar" "company-Profile-Aisyatul" "Quit")
echo "Pilih Apps Yang ingin anda gunakan :"
select statis in "${statis[@]}"; do
    case $statis in
    "company-profile-sektema")
        ./asset/WebStatis/sektema/sektema.sh
        echo "check apakah aplikasi sudah terinstall dengan benar ?"
        pil2=("Yes" "No")
        echo "Pilih Apps Yang ingin anda gunakan :"
        select pil2 in "${pil2[@]}"; do
            case $pil2 in
            "Yes")
                echo "Terimakasih atas kepercayaan anda"
                echo " - OmTegar"
                break 2
                ;;
            "No")
                echo "Mohon Maaf atas ketidak nyamanan dari pelayanan kami...."
                echo "Silahkan Hubungi Developer melalui github."
                break 2
                ;;
            esac
        done
        ;;
    "company-profile-OmTegar")
        ./asset/WebStatis/tegar/tegar.sh
        echo "check apakah aplikasi sudah terinstall dengan benar ?"
        pil1=("Yes" "No")
        echo "Pilih Apps Yang ingin anda gunakan :"
        select pil1 in "${pil1[@]}"; do
            case $pil1 in
            "Yes")
                echo "Terimakasih atas kepercayaan anda"
                echo " - OmTegar"
                break 2
                ;;
            "No")
                echo "Mohon Maaf atas ketidak nyamanan dari pelayanan kami...."
                echo "Silahkan Hubungi Developer melalui github."
                break 2
                ;;
            esac
        done
        ;;
    "company-Profile-Aisyatul")
        ./asset/WebStatis/aisyatul/aisyatul.sh
        echo "check apakah aplikasi sudah terinstall dengan benar ?"
        pil=("Yes" "No")
        echo "Pilih Apps Yang ingin anda gunakan :"
        select pil in "${pil[@]}"; do
            case $pil in
            "Yes")
                echo "Terimakasih atas kepercayaan anda"
                echo " - OmTegar"
                break 2
                ;;
            "No")
                echo "Mohon Maaf atas ketidak nyamanan dari pelayanan kami...."
                echo "Silahkan Hubungi Developer melalui github."
                break 2
                ;;
            esac
        done
        ;;
    "Quit")
        break
        ;;
    esac
done
