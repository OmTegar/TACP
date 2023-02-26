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

# function progress_bar {
#   local pid=$!
#   local delay=0.1
#   local i=0
#   local progress=0
#   local chars="/-\|"
#   printf "${GREEN}Starting process:${RESET}\n"
#   while [ $(ps -eo pid | grep $pid) ]; do
#     local char="${chars:$((i++%${#chars})):1}"
#     printf "${GREEN}[${char}] ${RESET}${YELLOW}%3d%% ${RESET}" $progress
#     printf "${GREEN}${char}" $progress
#     sleep $delay
#     printf "\b\b\b"
#     progress=$(($progress + 10))
#   done
#   printf "${GREEN}[${char}] ${RESET}${YELLOW}%3d%% ${RESET}" 100
#   printf "\n${GREEN}Process finished!${RESET}\n"
# }

function progress_bar {
  local pid=$!
  local delay=0.1
  local chars="/-\|"
  printf "${GREEN}Starting process:${RESET}\n"
  while [ $(ps -eo pid | grep $pid) ]; do
    local char="${chars:$((i++%${#chars})):1}"
    printf "${GREEN}[${char}] ${RESET} Working on task..."
    sleep $delay
    printf "\r"
  done
  printf "\n${GREEN}[${char}] ${RESET} Task completed.${RESET}\n"
}


#!/bin/bash

function clone_repo {
  local repo_url=$1
  local dir_path=$2
  local dir_name=$(basename "$dir_path")
  local pid=$!

  printf "${GREEN}Cloning repository ${repo_url} to ${dir_path}...${RESET}\n"

  if [ -d "$dir_path" ]; then
    printf "${YELLOW}Directory ${dir_path} already exists. Removing...${RESET}\n"
    rm -rf "$dir_path"
  fi

  mkdir -p "$dir_path"
  cd "$dir_path"

  git clone "$repo_url" "$dir_name" &
  pid=$!

  local delay=0.1
  local chars="/-\|"
  while [ $(ps -eo pid | grep $pid) ]; do
    local char="${chars:$((i++%${#chars})):1}"
    printf "${GREEN}[${char}] ${RESET}Cloning in progress..."
    printf "\b\b\b"
    sleep $delay
  done

  printf "${GREEN}[✔] ${RESET}Cloning completed!\n"
  printf "${YELLOW}Cloned repository stored in: ${dir_path}${RESET}\n"
}





