#!/bin/bash

# source upgrade package....
source ./asset/view.sh
source ./asset/function.sh

# Skrip utama
clear
clear
echo -e "${banner}${RESET}"
sleep 2

# Menjalankan perintah update
run_update

chmod +x -R asset/

clear
echo -e "${banner}${RESET}"
sleep 2

PS3='Please enter your choice: '
options=("Install Web Static" "Install Web Dinamis" "Install Web Framework" "FTP Server" "Database Server" "Auto Mount EBS" "Rsync Helper" "Remote Server ( OS Ubuntu / OS Debian )" "Update package TACP" "Quit")
select opt in "${options[@]}"; do
    case $opt in
        "Install Web Static")
            run_web_static
            ;;
        "Install Web Dinamis")
            run_web_dinamis
            ;;
        "Install Web Framework")
            run_web_framework
            ;;
        "FTP Server")
            run_ftp_server
            ;;
        "Database Server")
            run_Database_server
            ;;
        "Auto Mount EBS")
            run_auto_mount_ebs
            ;;
        "Rsync Helper")
            run_rsync_helper
            ;;
        "Remote Server ( OS Ubuntu / OS Debian )")
            run_remote_server
            ;;
        "Update package TACP")
            run_update_tacp
            break
            ;;
        "Quit")
            break
            ;;
        *)
            message "Pilihan tidak valid, silakan coba lagi"
            ;;
    esac
done
