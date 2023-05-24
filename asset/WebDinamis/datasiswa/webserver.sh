#!/bin/bash
source ./asset/upgrade.sh

if dpkg -l nginx >/dev/null 2>&1; then
  message "Nginx is installed, uninstalling and removing all files..."
  systemctl stop nginx
  sudo apt-get remove --purge nginx nginx-common nginx-full -y &
  progress_bar $!
  apt-get autoremove -y &
  progress_bar $!
  rm -rf /etc/nginx
  rm -rf /var/log/nginx
  message "Nginx has been uninstalled and all files removed."
else
  message "Nginx is not installed."
  message "Installing Nginx..."
  apt-get install apache2 -y &
  progress_bar $!
  message "Nginx has been installed."
fi

# Check if apache2 is already installed
if ! command -v apache2 &>/dev/null; then
  # If apache2 is not installed, install it with progress bar
  apt-get install apache2 -y & progress_bar $! 
  wait
fi

# Start Apache2 service
service apache2 start

# Update the package list and install Apache2, PHP, PHP MySQLi, Git, and MariaDB
apt-get install php php-mysqli php-mysql git mariadb-server -y

clear
echo -e "${banner}${RESET}"
sleep 2

# Clone the web-dinamis-produktif repository to /var/www/
cd /var/www/ && clone_repo "https://github.com/OmTegar/web-dinamis-produktif.git"

# Give permission to access asset directory and index.php file
chmod 777 -R /var/www/web-dinamis-produktif/

# Replace the default Apache2 configuration with the custom configuration
cd /etc/apache2/sites-available/
cat <<EOF >000-default.conf
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/web-dinamis-produktif/

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
EOF

# Restart Apache2 service
systemctl restart apache2

# Get RDS endpoint address
clear
echo -e "${banner}${RESET}"
sleep 2

if confirm_action "Apakah Anda Ingin Melakukan Konfigurasi File Koneksi ?"; then
  message "Masukkan RDS endpoint anda: "
  echo "Your Answer : "
  read rds_endpoint

  message "Masukkan username RDS anda: "
  echo "Your Answer : "
  read username_rds

  message "Masukkan Password RDS anda: "
  echo "Your Answer : "
  read password_rds

  # Modify the file koneksi.php to use the RDS database
  sed -i "s/localhost/$rds_endpoint/g" /var/www/web-dinamis-produktif/asset/koneksi.php
  sed -i "s/root/$username_rds/g" /var/www/web-dinamis-produktif/asset/koneksi.php
  sed -i "s/\"\"/\"$password_rds\"/g" /var/www/web-dinamis-produktif/asset/koneksi.php

  # sed -i "s/localhost/44.201.53.228/g" /var/www/web-dinamis-produktif/asset/koneksi.php
  # sed -i "s/root/tegar/g" /var/www/web-dinamis-produktif/asset/koneksi.php
  # sed -i "s/\"\"/\"rahasia\"/g" /var/www/web-dinamis-produktif/asset/koneksi.php



  # Check if the modification was successful
  if [ $? -eq 0 ]; then
    success_message "File koneksi.php has been successfully modified."
  else
    warning_message "Failed to modify the file koneksi.php."
  fi
  message "Masukkan password RDS anda"
  mysql -h $rds_endpoint -u $username_rds -p <<EOF

# Show existing databases
show databases;

# Create the datasiswa database
create database datasiswa;

# Use the datasiswa database
use datasiswa;

# Import the SQL script to create tables and populate data
source /var/www/web-dinamis-produktif/asset/database/datasiswa.sql

# Show tables in the datasiswa database
show tables;

# Select data from the users table
SELECT * FROM users;

# Exit the MySQL prompt
EOF
else
  message "Aplikasi Anda Sudah Terinstall Dengan Baik"
  message "Lakukan checking Ulang "
  message "Terimakasih Telah Menggunakan Layanan kami"
fi