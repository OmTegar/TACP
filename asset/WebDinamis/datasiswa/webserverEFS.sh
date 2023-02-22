#!/bin/bash
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
efs=$(df -h)
efsbaru='/var/www/web-project3/asset/images/'
echo "Mount Point EFS Anda Saat ini:"
echo "$efs"
sleep 2
echo "Untuk Menjalankan Apps ini Anda harus merubah Mount Point EFS anda menjadi : $efsbaru"
sleep 2
choice=("Yes" "No")
echo "Apakah anda yakin ingin melanjutkan installasi ?"
select choice in "${choice[@]}"; do
  case $choice in
  "Yes")
    # Update the package list and install Apache2, PHP, PHP MySQLi, Git, and MariaDB
    apt-get install apache2 php php-mysqli php-mysql git mariadb-server -y

    # Start Apache2 service
    service apache2 start
    # cd /var/www/ && git clone https://github.com/OmTegar/web-project3.git
    cd /var/www/ && mkdir tes
    cd tes/ && git clone https://github.com/OmTegar/web-project3.git
    cd web-project3/ && mv index.php /var/www/web-project3/
    cd asset/
    mv controller/ /var/www/web-project3/asset/
    mv css/ /var/www/web-project3/asset/
    mv database/ /var/www/web-project3/asset/
    mv shell/ /var/www/web-project3/asset/
    mv view/ /var/www/web-project3/asset/
    mv koneksi.php /var/www/web-project3/asset/
    cd ../../../ && rm -r tes/

    # chmod 777 -R /var/www/tes/web-project3/
    chmod 777 -R /var/www/web-project3/

    # Replace the default Apache2 configuration with the custom configuration
    cd /etc/apache2/sites-available/
    rm -r /etc/apache2/sites-available/000-default.conf
    cp /var/www/web-project3/asset/shell/000-default.conf .
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
    sed -i "s/localhost/$rds_endpoint/g" /var/www/web-project3/asset/koneksi.php
    sed -i "s/root/$username_rds/g" /var/www/web-project3/asset/koneksi.php
    sed -i "s/\"\"/\"$password_rds\"/g" /var/www/web-project3/asset/koneksi.php
    echo "Masukkan password RDS anda Lagi"

    # Check if the modification was successful
    if [ $? -eq 0 ]; then
      echo "File koneksi.php has been successfully modified."
    else
      echo "Failed to modify the file koneksi.php."
    fi
    echo "Masukkan password RDS anda"
    sleep 2
    # Login to the RDS database
    mysql -h $rds_endpoint -u $username_rds -p <<EOF

# Show existing databases
show databases;

# Create the datasiswa database
create database datasiswa;

# Use the datasiswa database
use datasiswa;

# Import the SQL script to create tables and populate data
source /var/www/web-project3/asset/database/datasiswa.sql

# Show tables in the datasiswa database
show tables;

# Select data from the users table
SELECT * FROM users;

# Exit the MySQL prompt
EOF
    ;;
  "No")
    break 2
    ;;
  esac
done
