#!/bin/bash

apt-get install apache2 php php-mysqli php-mysql git mariadb-server -y
service apache2 start
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

echo "Pastikan Instance anda sudah terhubung ke RDS !!!"
choice=("Yes" "No")
echo "Apakah anda yakin ingin melanjutkan installasi ?"
select choice in "${choice[@]}"; do
    case $choice in
    "Yes")
        # Clone the web-dinamis-produktif repository to /var/www/
        cd /var/www/ && git clone https://github.com/OmTegar/batiku.git

        # Give permission to access asset directory and index.php file
        chmod 777 -R /var/www/batiku/

        # Replace the default Apache2 configuration with the custom configuration
        cd /etc/apache2/sites-available/
        rm -r /etc/apache2/sites-available/000-default.conf
        cp /var/www/batiku/shell/000-default.conf .
        rm ../sites-enabled/000-default.conf
        cp 000-default.conf ../sites-enabled/

        # Restart Apache2 service
        systemctl restart apache2

        # Get RDS endpoint address
        clear
        echo "$banner"
        sleep 2
        echo "Masukkan RDS endpoint anda: "
        read rds_endpoint
        echo "Masukkan username RDS anda: "
        read username_rds
        echo "Masukkan Password RDS anda: "
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
            echo "File koneksi.php has been successfully modified."
        else
            echo "Failed to modify the file koneksi.php."
        fi
        clear
        echo "File DB pastikan tidak ada kesalahan !"
        sleep 3

        # check file koneksi
        # nano /var/www/batiku/config/db.php
        # nano /var/www/batiku/admin/config/db.php
        # nano /etc/apache2/sites-enabled/000-default.conf
        echo "Masukkan password RDS anda"
        sleep 2
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
        ;;
    "No")
        echo "Mungkin Apps lain ada yang cocok untukmu"
        echo "- OmTegar"
        break
        ;;
    esac
done
