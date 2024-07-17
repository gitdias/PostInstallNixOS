#!/usr/bin/env bash

#==============================================================================
#
#          FILE:  configureNix.sh
#
#         USAGE:  ./configureNix.sh [options]
#
#   DESCRIPTION:    PT = "Este script é parte de projeto pessoal que visa facilitar/automatizar/agilizar
#                         o processo de pós instalação do NixOS modificando os arquivos configuration.nix
#                         e hardware-configuration.nix contidos em /etc/nixos" de Pororocka (Sandro Dias).
#
#                   US = "This script is part of a personal project that aims to facilitate/automate/speed
#                         up the NixOS post-installation process by modifying the configuration.nix and
#                         hardware-configuration.nix files contained in /etc/nixos" by Pororocka (Sandro Dias).
#
#                   ES = "Este script es parte de un proyecto personal que tiene como objetivo
#                         facilitar/automatizar/acelerar el proceso posterior a la instalación de NixOS
#                         modificando los archivos configuración.nix y hardware-configuration.nix contenidos
#                         en /etc/nixos" por Pororocka (Sandro Dias).
#       OPTIONS:  ---
#    COMPATIBLE:  NixOS 24.05
#
#  REQUIREMENTS:  [Dependências do sistema, bibliotecas necessárias, etc.]
#          BUGS:  Relate problemas para [email@example.com]
#         NOTES:  ---
#        AUTHOR:  Dias, Sandro - pro.sandrodias@gmail.com
#       COMPANY:  freedom
#       VERSION:  1.0
#       CREATED:  06/30/2024
#      REVISION:  0 (ha! ha! ha!)
#
#==============================================================================

# Variables and functions
# Text colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'
# Background colors
BG_RED='\e[41m'
BG_GREEN='\e[42m'
BG_YELLOW='\e[43m'
BG_BLUE='\e[44m'
BG_MAGENTA='\e[45m'
BG_CYAN='\e[46m'
BG_WHITE='\e[47m'
# Text styles
BOLD='\e[1m'
UNDERLINE='\e[4m'
RESET='\e[0m'
FLASHING='\033[5m'
# Version NixOS
NIXOS_VERSION=$(nixos-version)
AUTHOR="by Mr.Pororocka - Sandro Dias"
# Simbols
CHECK_MARK="\u2713"
NO_CHECK_MARK="\u2717"
# Funtion Header Fixed
function_header_fixed() {
  clear
  tput cup 0 0 # Move cursor to top
  echo -e "\n 
    ____           _     ___           _        _ _     _   _ _       ___  ____\n\
   |  _ \ ___  ___| |_  |_ _|_ __  ___| |_ __ _| | |   | \ | (_)_  __/ _ \/ ___|\n\
   | |_) / _ \/ __| __|__| || '_ \/ __| __/ _\` | | |   |  \| | \ \/ / | | \___\n\
   |  __/ (_) \__ \ ||___| || | | \__ \ || (_| | | |   | |\  | |>  <| |_| |___)|\n\
   |_|   \___/|___/\__| |___|_| |_|___/\__\__,_|_|_|   |_| \_|_/_/\_\\___/|____/\n\
----------------------------------------------------------------------------------\n\
    ${AUTHOR}                                 Version 24.05-1\n"
  tput sc # Restore cursor position
}
# Funtion Header Flashing
function_header_flashing() {
  clear
  tput cup 0 0 # Move cursor to top
  echo -e "${FLASHING}\n 
    ____           _     ___           _        _ _     _   _ _       ___  ____\n\
   |  _ \ ___  ___| |_  |_ _|_ __  ___| |_ __ _| | |   | \ | (_)_  __/ _ \/ ___|\n\
   | |_) / _ \/ __| __|__| || '_ \/ __| __/ _\` | | |   |  \| | \ \/ / | | \___\n\
   |  __/ (_) \__ \ ||___| || | | \__ \ || (_| | | |   | |\  | |>  <| |_| |___)|\n\
   |_|   \___/|___/\__| |___|_| |_|___/\__\__,_|_|_|   |_| \_|_/_/\_\\___/|____/\n\
----------------------------------------------------------------------------------\n\
    ${AUTHOR}                                 Version 24.05-1\n${FLASHING}"
  tput sc # Restore cursor position
}
# Function Welcome User
function_welcome_user() {
  if [ $? -eq 0 ]; then
  echo -e "\n   $HELLO ${BOLD}${YELLOW}${USER^^}!${RESET} $WELCOME_SCRIPT ${BOLD}${CYAN}${NIXOS_VERSION:0:5}.${RESET}\n"
fi
}
# Function progress bar
function_progress_bar() {
  local speed=0.05  # Animation speed in seconds
  local width=20    # Progress bar width
  local position=0  # Starting position of block <-X->
  local direction=1 # Movement direction (1 = right, -1 = left)
  local progress=0  # Initial percentage
  #
  while [ $progress -le 100 ]; do
    # Clear current line
    printf "\r"
    # Build the progress bar
    bar=""
    for ((i = 0; i < $width; i++)); do
      if [ $i -eq $position ]; then
        bar+="<-X->"
        i=$((i + 4))
      else
        bar+=" "
      fi
    done
    # Updating position of block <-X->
    position=$((position + direction))
    if [ $position -ge $((width - 5)) ] || [ $position -le 0 ]; then
      direction=$((direction * -1))
    fi
    # Increase progress
    progress=$((progress + 1))
    # Do not comment, as it prevents the creation of the progress bar
    sleep $speed
    # Exibir a barra de progresso
    printf ""
    printf " ${YELLOW}[${bar:0:$width}] ${PREPARING_ENVIRONMENT}${RESET}"
    printf ""
  done
  # Clear the end line before leaving
  printf "\r\033[K"
}
#
function_detect_language() {
  # Check the LANG environment variable
  if [ -n "$LANG" ]; then
    # Extracts the first two letters and
    # save them in the LANGUAGE_CODE variable
    LANGUAGE_CODE=${LANG:0:2}
    # Choosing the .lang file to use
    case $LANGUAGE_CODE in
    en)
      source ./LANGUAGE/$LANGUAGE_CODE.lang
      ;;
    pt)
      source ./LANGUAGE/$LANGUAGE_CODE.lang
      ;;
    es)
      source ./LANGUAGE/$LANGUAGE_CODE.lang
      ;;
    *)
      source ./LANGUAGE/en.lang
      ;;
    esac
    return 0
  else
    return 1
  fi
}
#
function_detect_internet() {
  # Test the connection by pinging Google DNS
  if ping -c 1 8.8.8.8 &>/dev/null; then
    return 0
  else
    echo -e "   ${FLASHING}${BG_RED}${OFFLINE_INTERNET}${FLASHING}${RESET} ${MSG_OFFLINE_INTERNET}\n"
    echo -e "   ${CONNECT_WIFI}\n   ${YELLOW}${COMMAND_CONNECT_WIFI}${RESET}\n"
    exit 1
  fi
}
#
function_requirements() {
  # List of programs required in this script
  list_programs=("lolcat" "pciutils" "zip" "unzip")
  # Function to check if list_programs are installed
  function_check_list_programs() {
    not_installed=()
    for list_pkgs in "${list_programs[@]}"; do
      if ! nix-env -q | grep -q "$list_pkgs"; then
        not_installed+=($list_pkgs)
      fi
    done
    if [ ${#not_installed[@]} -eq 0 ]; then
      return 0
    else
      echo -e "   ${GREEN}${ALERT_REQUIREMENTS_OOPS}${RESET}\n   ${ALERT_REQUIREMENTS}${BOLD}${YELLOW}\n   ${not_installed[*]}${RESET}\n"
      return 1
    fi
  }
  # First Check
  if function_check_list_programs; then
    return 0
  fi
  # Test conection internet
  if ! function_detect_internet; then
    function_detect_internet
  fi
  #Asks if you want to install the missing list_programs
  read -p "${CONFIRM_INSTALL_REQUIREMENTS}" response
  if [[ "$response" == "s" || "$response" == "S" || "$response" == "y" || "$response" == "Y" ]]; then
    for list_pkgs in "${not_installed[@]}"; do
      {
        nix-env -iA nixos.$list_pkgs &>/dev/null
      } &
      function_progress_bar
    done
  elif [[ "$response" == "n" || "$response" == "N" ]]; then
    echo -e "\n   ${BG_RED}${NEED_TO_INSTALL}\n"
    exit 0
  else
    clear
    function_header_fixed #| lolcat 2>/dev/null
    echo -e "   $HELLO ${BOLD}${YELLOW}${USER^^}!${RESET} $WELCOME_SCRIPT ${BOLD}${CYAN}${NIXOS_VERSION:0:5}.${RESET}\n"
    function_requirements
  fi
  # Test after installation of requirements
  if function_check_list_programs; then
    function_header_flashing | lolcat 2>/dev/null
    echo -e "   ${CYAN}${ALL_RIGHT_REQUIREMENTS}\n
   ${YELLOW}$list_pkgs\n"
    echo -e "${PRESS_ENTER_CONTINUE}"
    function_header_fixed | lolcat 2>/dev/null
    echo -e "   $HELLO ${BOLD}${YELLOW}${USER^^}!${RESET} $WELCOME_SCRIPT ${BOLD}${CYAN}${NIXOS_VERSION:0:5}.${RESET}\n"
    return 0
  else
    echo -e "   ${BG_RED}${FAILURE_TO_INSTALL_REQUIREMENTS}\n"
  fi
}
# Function Backup
function_backup_configuration() {

  local src_dir="/etc/nixos"
  local dst_dir="/etc/nixos/bak"
  local backup_file_base="backup_configuration.zip"

  # Checks if the target directory exists, otherwise creates it using sudo
  if [[ ! -d "$dst_dir" ]]; then
    sudo mkdir -p "$dst_dir"
  fi

  # Sets the name of the initial backup file
  backup_file="$dst_dir/$backup_file_base"

  # If the backup file already exists, increment the version number
  if [[ -e "$backup_file" ]]; then
    version=1
    while [[ -e "$dst_dir/${version}_$backup_file_base" ]]; do
      ((version++))
    done
    backup_file="$dst_dir/${version}_$backup_file_base"
  fi

  # Create a zip archive of all .nix files in the source directory
  sudo zip -j "$backup_file" "$src_dir"/*.nix
}

function_typed_texts() {
echo -e "                              ${BOLD}${YELLOW}${TITLE_PRESENTATION}${RESET}\n"
# Text used
text="${TEXT_PRESENTATION}"

# maximum character length per line
length_max_line=80
# delay between printing each character
delay=0.005

# Funçtion split text
function_split_text() {
    local text="$1"
    local length_max="$2"
    
    echo "$text" | awk -v len=$length_max '
    {
        n = split($0, a, " ")
        line = "        "a[1]
        for (i = 2; i <= n; i++) {
            if (length(line " " a[i]) > len) {
                print line
                line = "  " a[i]
            } else {
                line = line " " a[i]
            }
        }
        print line
    }'
}

# Call the function and store the result in an array
IFS=$'\n' read -d '' -r -a lines <<< "$(function_split_text "$text" $length_max_line)"

# Loop for each line in the lines array
for line in "${lines[@]}"; do
  # Loop to print each character with delay
  for ((i=0; i<${#line}; i++)); do
    echo -n "${line:$i:1}"
    sleep $delay
  done
  echo
done

echo -e "\n                                                   ${CYAN}$AUTHOR${RESET}\n"
}


# Code applied
clear
function_backup_configuration

#
function_detect_language
function_welcome_user
#
function_requirements
#
function_header_fixed | lolcat 2>/dev/null
function_welcome_user
#
echo ""
function_typed_texts
echo -e "\n${FLASHING}${PRESS_ENTER_CONTINUE}${FLASHING}${RESET}\n"
read