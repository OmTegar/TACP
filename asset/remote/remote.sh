#!/bin/bash
source ./asset/upgrade.sh

clear
echo -e "${banner}${RESET}"
sleep 2

message "INPUT RSA PRIVATE KEY ANDA / .PEM"
sleep 4

#menyimpan RSA pada directory (/)
cd / && nano labsuser.pem
chmod 400 labsuser.pem

#remote OS
message "Masukkan IP Server Yang Akan Anda Remote :"
echo "Your Answer : "
read ip

echo "Pilih OS Server Yang akan Di Remote"
pil=("Ubuntu" "Debian")
select pil in "${pil[@]}"; do
    case $pil in
    "Ubuntu")
        ssh -i labsuser.pem ubuntu@$ip <<EOF
sudo su
cd /
clone_repo "https://github.com/OmTegar/TACP.git"
cd /Fiture-OmTegar
chmod +x index.sh
echo -e "${banner}${RESET}"
message "Anda Sudah Berada di Remote Server Yang Anda Inginkan"
EOF
        ssh -i labsuser.pem ubuntu@$ip
        ;;
    "Debian")
        ssh -i labsuser.pem admin@$ip <<EOF
sudo su
apt-get update 
apt install git -y & progress_bar $! 
cd /
clone_repo  "https://github.com/OmTegar/TACP.git"
cd /Fiture-OmTegar
chmod +x index.sh
echo -e "${banner}${RESET}"
message "Anda Sudah Berada di Remote Server Yang Anda Inginkan"
EOF
        ssh -i labsuser.pem admin@$ip
        break
        ;;
    esac
done
