#!/bin/bash

clear
banner="#####################################################################
                                                                
  8888888 8888888888   .8.           ,o888888o.    8 888888888o   
        8 8888        .888.         8888      88.  8 8888     88. 
        8 8888       :88888.     ,8 8888        8. 8 8888      88 
        8 8888      .  88888.    88 8888           8 8888      88 
        8 8888     .8.  88888.   88 8888           8 8888.   ,88  
        8 8888    .8 8.  88888.  88 8888           8 888888888P'  
        8 8888   .8'  8.  88888. 88 8888           8 8888         
        8 8888  .8'    8.  88888. 8 8888       .8  8 8888         
        8 8888 .888888888.  88888.  8888     ,88'  8 8888         
        8 8888.8'        8.  88888.   8888888P'    8 8888         
                                                                  
#####################################################################"
echo "$banner"
sleep 2

rsa="
INPUT RSA PRIVATE KEY ANDA / .PEM                                                                                                                                                                                                                                                                  
"
echo "$rsa"
sleep 2

#menyimpan RSA pada directory (/)
cd / && nano labsuser.pem
chmod 400 labsuser.pem

#remote OS
echo "Masukkan IP Server Yang Akan Anda Remote :"
read ip

echo "Pilih OS Server Yang akan Di Remote"
pil=("Ubuntu" "Debian")
select pil in "${pil[@]}"; do
    case $pil in
    "Ubuntu")
        ssh -i labsuser.pem ubuntu@$ip <<EOF
sudo su
cd /
git clone https://github.com/OmTegar/TACP.git
cd /Fiture-OmTegar
chmod +x index.sh
banner="#####################################################################
                                                                
  8888888 8888888888   .8.           ,o888888o.    8 888888888o   
        8 8888        .888.         8888      88.  8 8888     88. 
        8 8888       :88888.     ,8 8888        8. 8 8888      88 
        8 8888      .  88888.    88 8888           8 8888      88 
        8 8888     .8.  88888.   88 8888           8 8888.   ,88  
        8 8888    .8 8.  88888.  88 8888           8 888888888P'  
        8 8888   .8'  8.  88888. 88 8888           8 8888         
        8 8888  .8'    8.  88888. 8 8888       .8  8 8888         
        8 8888 .888888888.  88888.  8888     ,88'  8 8888         
        8 8888.8'        8.  88888.   8888888P'    8 8888         
                                                                  
#####################################################################"
echo "$banner"
echo ""
echo "Anda Sudah Berada di Remote Server Yang Anda Inginkan"
EOF
        ssh -i labsuser.pem ubuntu@$ip
        ;;
    "Debian")
        ssh -i labsuser.pem admin@$ip <<EOF
sudo su
apt-get update 
apt install git -y
cd /
git clone https://github.com/OmTegar/TACP.git
cd /Fiture-OmTegar
chmod +x index.sh
banner="#####################################################################
                                                                
  8888888 8888888888   .8.           ,o888888o.    8 888888888o   
        8 8888        .888.         8888      88.  8 8888     88. 
        8 8888       :88888.     ,8 8888        8. 8 8888      88 
        8 8888      .  88888.    88 8888           8 8888      88 
        8 8888     .8.  88888.   88 8888           8 8888.   ,88  
        8 8888    .8 8.  88888.  88 8888           8 888888888P'  
        8 8888   .8'  8.  88888. 88 8888           8 8888         
        8 8888  .8'    8.  88888. 8 8888       .8  8 8888         
        8 8888 .888888888.  88888.  8888     ,88'  8 8888         
        8 8888.8'        8.  88888.   8888888P'    8 8888         
                                                                  
#####################################################################"
echo "$banner"
echo ""
echo "Anda Sudah Berada di Remote Server Yang Anda Inginkan"
EOF
        ssh -i labsuser.pem admin@$ip
        break
        ;;
    esac
done
