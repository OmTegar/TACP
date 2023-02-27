#!/bin/bash


# lakukan pengecheck an apakah service apache sedang berjalan ?
# lakukan perubahan custom port sesuai keinginan user !!!!!







# Memperbarui paket dan menginstal paket yang diperlukan
apt update && apt install nodejs npm nginx -y

# Menginstal PM2 untuk memproses aplikasi Node.js
npm install pm2 -g

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

# Menjalankan aplikasi Node.js menggunakan PM2
cd /var/www
git clone https://github.com/OmTegar/node-website-static1.git
cd node-website-static1/
npm install
pm2 startup
pm2 delete index
pm2 start index.js

# Mengganti konfigurasi default Nginx dengan konfigurasi yang disediakan
rm -r /etc/nginx/nginx.conf
cp app/shell/nginx.conf /etc/nginx/

# Merestart Nginx
systemctl restart nginx

clear
echo "$banner"
sleep 2
echo "Terimakasih Telah Menggunakan Layanan kami"
