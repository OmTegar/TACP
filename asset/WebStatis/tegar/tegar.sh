#!/bin/bash
source ./asset/upgrade.sh

# Check if Nginx is installed

if dpkg -l nginx > /dev/null 2>&1; then
  echo "Nginx is installed, uninstalling and removing all files..."
  systemctl stop nginx
  sudo apt-get remove --purge nginx nginx-common nginx-full -y & progress_bar $! 
  apt-get autoremove -y & progress_bar $! 
  rm -rf /etc/nginx
  rm -rf /var/log/nginx
  rm -rf /var/www/
  echo "Nginx has been uninstalled and all files removed."
else
  echo "Nginx is not installed."
  echo "Installing Nginx..."
  apt-get install apache2 -y & progress_bar $! 
  echo "Nginx has been installed."
fi

# Check if apache2 is already installed
if ! command -v apache2 &> /dev/null
then
    # If apache2 is not installed, install it with progress bar
    apt-get install apache2 -y & progress_bar $! 
    wait
fi

# Start Apache2 service
service apache2 start
clear
echo -e "${banner}${RESET}"
sleep 2

# Clone the company-aisyatul repository to /var/www/html
cd /var/www/html/ && clone_repo "https://github.com/OmTegar/my-company-profile.git"

# Give permission to access asset directory and index.php file
chmod 777 -R /var/www/html/my-company-profile/

# Replace the default Apache2 configuration with the custom configuration
cd /etc/apache2/sites-available/
rm -r /etc/apache2/sites-available/000-default.conf
cp /var/www/html/my-company-profile/shell/000-default.conf .
rm ../sites-enabled/000-default.conf
cp 000-default.conf ../sites-enabled/
cd ../../../

# Restart Apache2 service
systemctl restart apache2
