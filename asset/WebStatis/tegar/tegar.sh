#!/bin/bash
# source upgrade package....
source ./../../upgrade.sh

apt-get install apache2 -y & progress_bar $! 
wait
service apache2 start
clear
echo "${banner}${RESET}"
sleep 2

# Clone the company-aisyatul repository to /var/www/html
cd /var/www/html/ && git clone https://github.com/OmTegar/my-company-profile.git

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