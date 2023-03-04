#!/bin/bash
source ./asset/upgrade.sh

clear
echo -e "${banner}${RESET}"
sleep 2

# message "Tunggu Update Package React JS Selanjutnya"

# Check if Apache2 is installed
if dpkg -l apache2 > /dev/null 2>&1; then
  message "Apache2 is installed, uninstalling and removing all files..."
  systemctl stop apache2
  apt-get remove --purge apache2 apache2-utils -y & progress_bar $! 
  apt-get autoremove -y & progress_bar $! 
  rm -rf /etc/apache2
  message "Apache2 has been uninstalled and all files removed."
else
  message "Apache2 is not installed."
  message "Installing Nginx..."
  apt-get install nginx -y & progress_bar $! 
  message "Nginx has been installed."
fi

if ! command -v nginx &> /dev/null
then
    # If apache2 is not installed, install it with progress bar
    apt-get install nginx -y & progress_bar $! 
    wait
fi

# lakukan perubahan custom port sesuai keinginan user !!!!!
clear
echo -e "${banner}${RESET}"
sleep 2
message "Masukkan Port yang anda inginkan , dengan pilihan port bisa dari ( 81 - 9000 ) : "
echo "Your Answer : "
read port

clear
echo -e "${banner}${RESET}"
sleep 2
message "Masukkan Api themoviedb yang anda Miliki : "
echo "Your Answer : "
read api

# Memperbarui paket dan menginstal paket yang diperlukan
cd ~
curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
# nano /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install nodejs -y & progress_bar $!
apt install npm -y & progress_bar $!

# Menginstal PM2 untuk memproses aplikasi Node.js
npm install pm2 -g

clear
echo -e "${banner}${RESET}"
sleep 2

# Menjalankan aplikasi Node.js menggunakan PM2
cd /var/www && clone_repo "https://github.com/OmTegar/react-movie.git"
cd react-movie/src/api/

# configuration API
echo "const apiConfig = {" > apiConfig.js
echo "    baseUrl: 'https://api.themoviedb.org/3/'," >> apiConfig.js
echo "    apiKey: '$api',  // get from themoviedb.org" >> apiConfig.js
echo "    originalImage: (imgPath) => \`https://image.tmdb.org/t/p/original/\${imgPath}\`," >> apiConfig.js
echo "    w500Image: (imgPath) => \`https://image.tmdb.org/t/p/w500/\${imgPath}\`" >> apiConfig.js
echo "}" >> apiConfig.js
echo "" >> apiConfig.js
echo "export default apiConfig;" >> apiConfig.js


# start configurasi
cd /var/www/react-movie/
npm install
npm run build
pm2 serve build $port --spa
pm2 startup
pm2 save

# Mengganti konfigurasi default Nginx dengan konfigurasi yang disediakan
cd /etc/nginx/
cat << EOF > nginx.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
	# multi_accept on;
}

http {

	##
	# Basic Settings
	##

	sendfile on;
	tcp_nopush on;
	types_hash_max_size 2048;
	# server_tokens off;

	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	##
	# Logging Settings
	##

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	##
	# Gzip Settings
	##

	gzip on;

	# gzip_vary on;
	# gzip_proxied any;
	# gzip_comp_level 6;
	# gzip_buffers 16 8k;
	# gzip_http_version 1.1;
	# gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

	##
	# Virtual Host Configs
	##

	include /etc/nginx/conf.d/*.conf;
	#include /etc/nginx/sites-enabled/*;
	server {
		listen 		80;
		listen 		[::]:80;
		server_name	_;
	
		location / {
			proxy_pass http://localhost:$port;
		}
	}
}


#mail {
#	# See sample authentication script at:
#	# http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#	# auth_http localhost/auth.php;
#	# pop3_capabilities "TOP" "USER";
#	# imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#	server {
#		listen     localhost:110;
#		protocol   pop3;
#		proxy      on;
#	}
#
#	server {
#		listen     localhost:143;
#		protocol   imap;
#		proxy      on;
#	}
#}
EOF

# Merestart Nginx
systemctl restart nginx

clear
echo -e "${banner}${RESET}"
sleep 2
# echo "Terimakasih Telah Menggunakan Layanan kami"
message "Aplikasi Anda Sudah Terinstall Dengan Baik"
pm2 list 
message "Lakukan checking Ulang "
message "Terimakasih Telah Menggunakan Layanan kami"



# apt install nginx npm nodejs -y
# npm install pm2 -g
# git clone https://github.com/issaafalkattan/React-Landing-Page-Template.git
# npm install 
# npm install --legacy-peer-deps
# npm start
# npm run build
# pm2 serve build 3000 --spa
# nano /etc/nginx/nginx.conf 

# install nodejs 16
# cd ~
# curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
# nano /tmp/nodesource_setup.sh
# sudo bash /tmp/nodesource_setup.sh
# sudo apt install nodejs