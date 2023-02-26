#!/bin/bash

# Set color variables
BLUE="\x1b[1;34m"
GREEN="\x1b[1;32m"
RED="\x1b[1;31m"
YELLOW="\x1b[1;33m"
RESET="\x1b[0m"

# Set banner text
banner="${BLUE}                                                                
#####################################################################

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

# Function to display a progress bar in green color
# function progress_bar {
#   local pid=$!
#   local delay=0.1
#   local spinstr='|/-\'
#   while [ $(ps -eo pid | grep $pid) ]; do
#     local temp=${spinstr#?}
#     printf "${GREEN} [%c] ${RESET}" "$spinstr"
#     spinstr=$temp${spinstr%"$temp"}
#     sleep $delay
#     printf "\b\b\b\b\b\b"
#   done
#   printf "    \b\b\b\b"
# }

function progress_bar {
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  local i=0
  local progress=0
  while [ $(ps -eo pid | grep $pid) ]; do
    local temp=${spinstr#?}
    if [ $i -eq 0 ]; then
      printf "${GREEN} [${spinstr:0:1}] ${RESET} ${YELLOW}%3d%% ${RESET}" $progress
      i=1
    else
      printf "\b\b\b${GREEN} [${spinstr:0:1}] ${RESET} ${YELLOW}%3d%% ${RESET}" $progress
      i=0
    fi
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    progress=$(($progress + 10))
  done
  printf "${GREEN} [${spinstr:0:1}] ${RESET} ${YELLOW}%3d%% ${RESET}\n" $progress
}


