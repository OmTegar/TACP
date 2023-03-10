#!/bin/bash

# Set color variables
BLUE="\x1b[1;34m"
GREEN="\x1b[1;32m"
RED="\x1b[1;31m"
YELLOW="\x1b[1;33m"
RESET="\x1b[0m"

# Set banner text

banner="${GREEN}  
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
               
${YELLOW}            ~ Package Global Scripting Linux By OmTegar ~
${BLUE}######################################################################${RESET}"

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
    read -p "[?] ${1} (y/n) " yn
    case $yn in
    [Yy]*) return 0 ;;
    [Nn]*) return 1 ;;
    *) echo "Please answer yes or no." ;;
    esac
  done
}


function progress_bar {
  local pid=$!
  local delay=0.1
  local chars="/-\|"
  printf "${GREEN}Starting process:${RESET}\n"
  while [ $(ps -eo pid | grep $pid) ]; do
    local char="${chars:$((i++ % ${#chars})):1}"
    printf "${GREEN}[${char}] ${RESET} Working on task..."
    sleep $delay
    printf "\r"
  done
  printf "\n${GREEN}[${char}] ${RESET} Task completed.${RESET}\n"
}

function clone_repo {
  local repo_url=$1
  local repo_name=$(basename $repo_url .git)
  printf "${GREEN}Cloning $repo_name ...${RESET}\n"
  git clone $repo_url $repo_name &>/dev/null &
  local pid=$!
  local delay=0.1
  local chars="/-\|"
  while [ $(ps -eo pid | grep $pid) ]; do
    local char="${chars:$((i++ % ${#chars})):1}"
    printf "${GREEN}[${char}] ${RESET}Cloning $repo_name ... "
    sleep $delay
    printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
  done
  printf "${GREEN}[${char}] ${RESET}Cloning $repo_name ... Done\n"
  printf "${GREEN}Directory: $(pwd)/$repo_name${RESET}\n"
}

function message {
  local message=$1
  message_length=${#message}
  for ((i = 1; i <= $message_length + 8; i++)); do
    echo -n "*"
  done
  printf "\n* %s *\n" "$message"
  for ((i = 1; i <= $message_length + 8; i++)); do
    echo -n "*"
  done
  echo " "
}

# function done {
#   message "Aplikasi Anda Sudah Terinstall Dengan Baik"
#   message "Lakukan checking Ulang "
#   message "Terimakasih Telah Menggunakan Layanan kami"
# }
