#!/bin/bash

# Update package list
sudo apt update

# Install PHP, phpMyAdmin, and MariaDB Server
sudo apt install -y php phpmyadmin mariadb-server

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

# Configure MariaDB Server
sudo mysql <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'tegar'@'%' IDENTIFIED BY 'rahasia' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON datasiswa.* TO 'tegar'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'tegar'@'%' IDENTIFIED BY 'rahasia';
GRANT INSERT ON *.* TO 'tegar'@'%';
FLUSH PRIVILEGES;
EOF
# Baru
# GRANT ALL PRIVILEGES ON *.* TO 'root'@'3.90.50.239' IDENTIFIED BY 'root' WITH GRANT OPTION;
# FLUSH PRIVILEGES;

# Allow remote access to MariaDB Server
sudo sed -i '/bind-address/ s/^#*/#/' /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb

# Enable PHP extension for phpMyAdmin
sudo phpenmod mysqli
sudo systemctl restart apache2

# Update phpMyAdmin configuration to allow remote access
sudo sed -i '/Allow from/ s/^#*/#/' /etc/phpmyadmin/apache.conf
sudo systemctl restart apache2

echo "Instalasi dan konfigurasi selesai. Anda dapat mengakses phpMyAdmin dari instance yang berbeda menggunakan pengguna 'tegar' dan kata sandi 'rahasia'."

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
        DocumentRoot /var/www/html/phpmyadmin/

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
sudo systemctl restart apache2




# nitip

# mysql -u root -p

# MariaDB [(none)]> CREATE DATABASE booku;
# MariaDB [(none)]> CREATE USER 'tegar'@'%' IDENTIFIED BY 'tegar';
# MariaDB [(none)]> GRANT ALL PRIVILEGES ON booku.* TO 'tegar'@'%';
# MariaDB [(none)]> GRANT ALL PRIVILEGES ON datasiswa.* TO 'tegar'@'%';
# MariaDB [(none)]> FLUSH PRIVILEGES;

# GRANT ALL PRIVILEGES ON database.table TO 'tegar'@'localhost';
# GRANT ALL PRIVILEGES ON *.* TO 'tegar'@'%' IDENTIFIED BY 'rahasia';

# GRANT INSERT ON *.* TO 'tegar'@'%';


