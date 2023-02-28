#!/bin/bash
source ./asset/upgrade.sh

# lakukan pengecheck an apakah service apache sedang berjalan ?

# Check if Apache2 is installed
if dpkg -l apache2 > /dev/null 2>&1; then
  echo "Apache2 is installed, uninstalling and removing all files..."
  systemctl stop apache2
  apt-get remove --purge apache2 apache2-utils -y & progress_bar $! 
  apt-get autoremove -y & progress_bar $! 
  rm -rf /etc/apache2
  rm -rf /var/www/html
  echo "Apache2 has been uninstalled and all files removed."
else
  echo "Apache2 is not installed."
  echo "Installing Nginx..."
  apt-get install nginx -y & progress_bar $! 
  echo "Nginx has been installed."
fi

# lakukan perubahan custom port sesuai keinginan user !!!!!

message "Masukkan Port yang anda inginkan , dengan pilihan port bisa dari ( 1 - 9999 ) : "
echo "Your Answer : "
read port

# port=$(echo "$port" | tr -d '[:space:]')

echo "$port"





# # Memperbarui paket dan menginstal paket yang diperlukan
# apt install nodejs npm -y & progress_bar $! 

# # Menginstal PM2 untuk memproses aplikasi Node.js
# npm install pm2 -g

# clear
# echo -e "${banner}${RESET}"
# sleep 2

# # Menjalankan aplikasi Node.js menggunakan PM2
# cd /var/www
# git clone https://github.com/OmTegar/node-website-static1.git
# cd node-website-static1/

# # ubah index jadi nama apapun
# # buat index baru dengan EOF include dengan port custom
# # hapus nginx.conf dan buat yang baru dengan EOF include dengan port custom 



# npm install
# pm2 startup
# pm2 delete index
# pm2 start index.js

# # Mengganti konfigurasi default Nginx dengan konfigurasi yang disediakan
# rm -r /etc/nginx/nginx.conf
# cp app/shell/nginx.conf /etc/nginx/

# # Merestart Nginx
# systemctl restart nginx

# clear
# echo -e "${banner}${RESET}"
# sleep 2
# echo "Terimakasih Telah Menggunakan Layanan kami"
