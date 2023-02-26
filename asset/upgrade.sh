#!/bin/bash

# Set color variables
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Set banner text
banner="#####################################################################
                                                                
  ${BLUE}8888888 8888888888   .8.           ,o888888o.    8 888888888o   
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

# Function to print a message in green color
function success_message {
  echo -e "${GREEN}[*] ${1}${RESET}"
}

# Function to print a message in yellow color
function warning_message {
  echo -e "${YELLOW}[!] ${1}${RESET}"
}

# Function to print a message in red color
function error_message {
  echo -e "${RED}[X] ${1}${RESET}"
}

# Function to confirm a user action
function confirm_action {
  while true; do
    read -p "${YELLOW}[?] ${1} (y/n) ${RESET}" yn
    case $yn in
        [Yy]* ) return 0;;
        [Nn]* ) return 1;;
        * ) warning_message "Please answer yes or no.";;
    esac
  done
}

# Function to display a progress bar
function progress_bar {
  local progress=0
  local pid=$!
  while [ $progress -ne 100 ]; do
    sleep 1
    progress=$(expr $progress + 10)
    echo -ne "${BLUE}[+] Progress: ${progress}%\r${RESET}"
  done
  wait $pid
}
