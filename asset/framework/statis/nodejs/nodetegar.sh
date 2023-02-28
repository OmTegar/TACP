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
console.log('var http = require("http");');
console.log('var fs = require("fs");');
console.log('var path = require("path");');
console.log('var port = $port;');

console.log('http');
console.log('  .createServer(function (request, response) {');
console.log('    console.log("request ", request.url);');

console.log('    var filePath = "." + request.url;');
console.log('    if (filePath == "./") {');
console.log('      filePath = "./app/index.html";');
console.log('    }');

console.log('    var extname = String(path.extname(filePath)).toLowerCase();');
console.log('    var mimeTypes = {');
console.log('      ".html": "text/html",');
console.log('      ".js": "text/javascript",');
console.log('      ".css": "text/css",');
console.log('      ".json": "application/json",');
console.log('      ".png": "image/png",');
console.log('      ".jpg": "image/jpg",');
console.log('      ".gif": "image/gif",');
console.log('      ".svg": "image/svg+xml",');
console.log('      ".wav": "audio/wav",');
console.log('      ".mp4": "video/mp4",');
console.log('      ".woff": "application/font-woff",');
console.log('      ".ttf": "application/font-ttf",');
console.log('      ".eot": "application/vnd.ms-fontobject",');
console.log('      ".otf": "application/font-otf",');
console.log('      ".wasm": "application/wasm",');
console.log('    };');

console.log('    var contentType = mimeTypes[extname] || "application/octet-stream";');

console.log('    fs.readFile(filePath, function (error, content) {');
console.log('      if (error) {');
console.log('        if (error.code == "ENOENT") {');
console.log('          fs.readFile("./404.html", function (error, content) {');
console.log('            response.writeHead(404, { "Content-Type": "text/html" });');
console.log('            response.end(content, "utf-8");');
console.log('          });');
console.log('        } else {');
console.log('          response.writeHead(500);');
console.log('          response.end(');
console.log('            "Sorry, check with the site admin for error: " +');
console.log('              error.code +');
console.log('              " ..\\n"');
console.log('          );');
console.log('        }');
console.log('      } else {');
console.log('        response.writeHead(200, { "Content-Type": contentType });');
console.log('        response.end(content, "utf-8");');
console.log('      }');
console.log('    });');
console.log('  })');
console.log('  .listen(port);');

console.log('console.log("Server running at http://127.0.0.1:" + port);');
EOF


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
