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

cat index.js
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
