#!/bin/bash

# Update package list
source ./asset/view.sh
# source ./asset/function.sh

# Install PHP, phpMyAdmin, and MariaDB Server
sudo apt install php phpmyadmin mariadb-server -y & progress_bar $!
clear
echo -e "${banner}${RESET}"
sleep 2

# Configure MariaDB Server
sudo mysql_secure_installation <<EOF
n
root
root
y
y
y
y
EOF

# Masukkan Username Mysql yang anda inginkan
message "Masukkan Username Mysql yang anda inginkan :" 
echo "Your Answer : "
read Username

# Masukkan Password Mysql yang anda inginkan
message "Masukkan Password Mysql yang anda inginkan :" 
echo "Your Answer : "
read Password

# Configure MariaDB Server
sudo mysql <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO '$Username'@'%' IDENTIFIED BY '$Password' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON datasiswa.* TO '$Username'@'%';
GRANT ALL PRIVILEGES ON *.* TO '$Username'@'%' IDENTIFIED BY '$Password';
GRANT INSERT ON *.* TO '$Username'@'%';
FLUSH PRIVILEGES;
EOF

cd /home & mkdir database
chmod 777 /home/database

# Allow remote access to MariaDB Server
sudo sed -i '/bind-address/ s/^#*/#/' /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb

# Enable PHP extension for phpMyAdmin
sudo phpenmod mysqli
sudo systemctl restart apache2

# Update phpMyAdmin configuration to allow remote access
sudo sed -i '/Allow from/ s/^#*/#/' /etc/phpmyadmin/apache.conf
sudo systemctl restart apache2

# Skip dbconfig-common configuration for phpMyAdmin
echo "No" | sudo dbconfig-common

echo "Instalasi dan konfigurasi selesai. Anda dapat mengakses phpMyAdmin dari instance yang berbeda menggunakan pengguna 'tegar' dan kata sandi 'rahasia'."

cd /etc/apache2/sites-available/
cat <<EOF >000-default.conf
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/phpmyadmin/

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Restart Apache2 service
sudo systemctl restart apache2

clear
echo -e "${banner}${RESET}"
sleep 2
echo " "
message "Berikut Data User MySQL Server Anda:" > /home/database/user.txt
echo "#############################" >> /home/database/user.txt
echo "| Username Default  | root   |" >> /home/database/user.txt
echo "| Password Default  | root   |" >> /home/database/user.txt
echo "| Username          | $Username   |" >> /home/database/user.txt
echo "| Password          | $Password   |" >> /home/database/user.txt
echo "#############################" >> /home/database/user.txt
cat /home/database/user.txt
echo " "
