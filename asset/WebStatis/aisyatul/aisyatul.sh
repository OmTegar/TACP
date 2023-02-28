#!/bin/bash

source ./asset/upgrade.sh

# Check if Nginx is installed
if command -v nginx &> /dev/null
then
    echo "Nginx is installed, uninstalling..."

    # Stop Nginx service if it's running
    systemctl stop nginx

    # Remove Nginx
    apt-get remove -y nginx

    # Remove Nginx directory
    rm -rf /etc/nginx
    rm -rf /var/www/html/*

    echo "Nginx has been uninstalled"
else
    echo "Nginx is not installed, installing Apache2..."

    # Install Apache2
    apt-get update
    apt-get install apache2 -y & progress_bar $! 

    echo "Apache2 has been installed"
fi

# Check if apache2 is already installed
if ! command -v apache2 &> /dev/null
then
    # If apache2 is not installed, install it with progress bar
    apt-get install apache2 -y & progress_bar $! 
    wait
fi

service apache2 start
clear
echo -e "${banner}${RESET}"
sleep 2

# Clone the company-aisyatul repository to /var/www/html
cd /var/www/html/ && clone_repo "https://github.com/OmTegar/company-aisyatul.git"

# Give permission to access asset directory and index.php file
chmod 777 -R /var/www/html/company-aisyatul/

# Replace the default Apache2 configuration with the custom configuration
cd /etc/apache2/sites-available/
rm -r /etc/apache2/sites-available/000-default.conf
cp /var/www/html/company-aisyatul/shell/000-default.conf .
rm ../sites-enabled/000-default.conf
cp 000-default.conf ../sites-enabled/
cd ../../../

# Restart Apache2 service
systemctl restart apache2