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

if ! command -v nginx &> /dev/null
then
    # If apache2 is not installed, install it with progress bar
    apt-get install nginx -y & progress_bar $! 
    wait
fi

# lakukan perubahan custom port sesuai keinginan user !!!!!

message "Masukkan Port yang anda inginkan , dengan pilihan port bisa dari ( 81 - 9000 ) : "
echo "Your Answer : "
read port

# Memperbarui paket dan menginstal paket yang diperlukan
apt install nodejs npm -y & progress_bar $! 

# Menginstal PM2 untuk memproses aplikasi Node.js
npm install pm2 -g

clear
echo -e "${banner}${RESET}"
sleep 2

# Menjalankan aplikasi Node.js menggunakan PM2
cd /var/www && clone_repo "https://github.com/OmTegar/node-website-static1.git"
cd node-website-static1/

# buat index baru dengan EOF include dengan port custom
cat << EOF > index.js
var http = require("http");
var fs = require("fs");
var path = require("path");
var port = $port;

http
  .createServer(function (request, response) {
    console.log("request ", request.url);

    var filePath = "." + request.url;
    if (filePath == "./") {
      filePath = "./app/index.html";
    }

    var extname = String(path.extname(filePath)).toLowerCase();
    var mimeTypes = {
      ".html": "text/html",
      ".js": "text/javascript",
      ".css": "text/css",
      ".json": "application/json",
      ".png": "image/png",
      ".jpg": "image/jpg",
      ".gif": "image/gif",
      ".svg": "image/svg+xml",
      ".wav": "audio/wav",
      ".mp4": "video/mp4",
      ".woff": "application/font-woff",
      ".ttf": "application/font-ttf",
      ".eot": "application/vnd.ms-fontobject",
      ".otf": "application/font-otf",
      ".wasm": "application/wasm",
    };

    var contentType = mimeTypes[extname] || "application/octet-stream";

    fs.readFile(filePath, function (error, content) {
      if (error) {
        if (error.code == "ENOENT") {
          fs.readFile("./404.html", function (error, content) {
            response.writeHead(404, { "Content-Type": "text/html" });
            response.end(content, "utf-8");
          });
        } else {
          response.writeHead(500);
          response.end(
            "Sorry, check with the site admin for error: " +
              error.code +
              " ..\n"
          );
        }
      } else {
        response.writeHead(200, { "Content-Type": contentType });
        response.end(content, "utf-8");
      }
    });
  })
  .listen(port);

console.log("Server running at http://127.0.0.1:" + port);
EOF

# hapus nginx.conf dan buat yang baru dengan EOF include dengan port custom 

npm install
pm2 startup
pm2 delete index
pm2 start index.js

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


# rm -r /etc/nginx/nginx.conf
# cp app/shell/nginx.conf /etc/nginx/

# Merestart Nginx
systemctl restart nginx

clear
echo -e "${banner}${RESET}"
sleep 2
# echo "Terimakasih Telah Menggunakan Layanan kami"
message "Aplikasi Anda Sudah Terinstall Dengan Baik"
message "Lakukan checking Ulang "
message "Terimakasih Telah Menggunakan Layanan kami"
