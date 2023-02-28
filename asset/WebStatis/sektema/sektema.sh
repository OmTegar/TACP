#!/bin/bash

source ./asset/upgrade.sh

# Check if Nginx is installed
if dpkg -l nginx > /dev/null 2>&1; then
  message "Nginx is installed, uninstalling and removing all files..."
  systemctl stop nginx
  sudo apt-get remove --purge nginx nginx-common nginx-full -y & progress_bar $! 
  apt-get autoremove -y & progress_bar $! 
  rm -rf /etc/nginx
  rm -rf /var/log/nginx
  message "Nginx has been uninstalled and all files removed."
else
  message "Nginx is not installed."
  message "Installing Nginx..."
  apt-get install apache2 -y & progress_bar $! 
  message "Nginx has been installed."
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
cd /var/www/html/ && clone_repo "https://github.com/OmTegar/company-profile-sektema.git"

# Give permission to access asset directory and index.php file
chmod 777 -R /var/www/html/company-profile-sektema/

# Replace the default Apache2 configuration with the custom configuration
cd /etc/apache2/sites-available/
cat << EOF > 000-default.conf
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
        DocumentRoot /var/www/html/company-profile-sektema/

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