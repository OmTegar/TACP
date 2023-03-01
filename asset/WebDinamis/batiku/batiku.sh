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
    apt-get install apache2 -y &
    progress_bar $!
    wait
fi

apt-get install php php-mysqli php-mysql git mariadb-server -y &
progress_bar $!
service apache2 start
clear
echo -e "${banner}${RESET}"
sleep 2

echo "Pastikan Instance anda sudah terhubung ke RDS !!!"
choice=("Yes" "No")
echo "Apakah anda yakin ingin melanjutkan installasi ?"
select choice in "${choice[@]}"; do
    case $choice in
    "Yes")
        # Clone the web-dinamis-produktif repository to /var/www/
        cd /var/www/ && clone_repo "https://github.com/OmTegar/batiku.git"

        # Give permission to access asset directory and index.php file
        chmod 777 -R /var/www/batiku/

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
        DocumentRoot /var/www/batiku/

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
        clear
        echo -e "${banner}${RESET}"
        sleep 2

        if confirm_action "Apakah Anda Ingin Melakukan Konfigurasi File Koneksi ?"; then
            # Get RDS endpoint address

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
            sed -i "s/localhost/$rds_endpoint/g" /var/www/batiku/config/db.php
            sed -i "s/root/$username_rds/g" /var/www/batiku/config/db.php
            sed -i "s/password/$password_rds/g" /var/www/batiku/config/db.php

            sed -i "s/localhost/$rds_endpoint/g" /var/www/batiku/admin/config/db.php
            sed -i "s/root/$username_rds/g" /var/www/batiku/admin/config/db.php
            sed -i "s/password/$password_rds/g" /var/www/batiku/admin/config/db.php
            # sed -i "s/\"\"/\"$password_rds\"/g" /var/www/batiku/admin/config/db.php

            # Check if the modification was successful
            if [ $? -eq 0 ]; then
                success_message "File koneksi.php has been successfully modified."
            else
                error_message "Failed to modify the file koneksi.php."
            fi
            clear
            message "File DB pastikan tidak ada kesalahan !"
            sleep 3
            # check file koneksi
            # nano /var/www/batiku/config/db.php
            # nano /var/www/batiku/admin/config/db.php
            # nano /etc/apache2/sites-enabled/000-default.conf
            message "Masukkan password RDS anda"
            # Login to the RDS database
            mysql -h $rds_endpoint -u $username_rds -p <<EOF

# Show existing databases
show databases;

# Create the datasiswa database
create database batiku;

# Use the datasiswa database
use batiku;

# Import the SQL script to create tables and populate data
source /var/www/batiku/batiku.sql

# Show tables in the datasiswa database
show tables;

# Select data from the users table
SELECT * FROM form_login;
SELECT * FROM jenis_produk;
SELECT * FROM pelanggan;
SELECT * FROM pembayaran;
SELECT * FROM penjual;
SELECT * FROM produk;
SELECT * FROM supplier;
SELECT * FROM tabel_admin;
SELECT * FROM tabel_kategori;
SELECT * FROM tabel_keranjang;
SELECT * FROM tabel_komentar;
SELECT * FROM tabel_produk;
SELECT * FROM tabel_transaksi;
SELECT * FROM tabel_trolly;
SELECT * FROM tabel_user;
SELECT * FROM transaksi;
EOF
        else
            message "Terimakasih Telah Menggunakan Layanan kami"
        fi

        ;;
    "No")
        message "Mungkin Apps lain ada yang cocok untukmu"
        echo "- OmTegar"
        break
        ;;
    esac
done
