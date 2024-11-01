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
#        AUTHOR:  Dias, Sandro-pro.sandrodias@gmail.com
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
AUTHOR="by Mr.Pororocka-Sandro Dias"
# Simbols
CHECK_MARK="\u2713"
NO_CHECK_MARK="\u2717"
SYMBOL_HOME="\u2302"
SYMBOL_SELECT="\u2714"
SYMBOL_ERROR="\u2716"
SYMBOL_STAR_BLACK="\u2605"
SYMBOL_STAR_WHITE="\u2606"
SYMBOL_TRIANGLE_UP="\u25B2"
SYMBOLTRIANGLE_DOWN="\u25BC"
SYMBOL_TRIANGLE_LEFT="\u25C0"
SYMBOL_TRIANGLE_RIGHT="\u25B6"
SYMBOL_LIGHTNING="\u26A1"
# Others

# Funtion Header Fixed
function_header_fixed() {
  clear
  tput cup 0 0 # Move cursor to top
  echo -e "    ____           _     ___           _        _ _     _   _ _       ___  ____\n\
   |  _ \ ___  ___| |_  |_ _|_ __  ___| |_ __ _| | |   | \ | (_)_  __/ _ \/ ___|\n\
   | |_) / _ \/ __| __|__| || '_ \/ __| __/ _\` | | |   |  \| | \ \/ / | | \___\n\
   |  __/ (_) \__ \ ||___| || | | \__ \ || (_| | | |   | |\  | |>  <| |_| /___)|\n\
   |_|   \___/|___/\__| |___|_| |_|___/\__\__,_|_|_|   |_| \_|_/_/\_\\___/|____/\n\
----------------------------------------------------------------------------------\n\
    ${AUTHOR}                               Version ${NIXOS_VERSION:0:5}-1\n"
  tput sc # Restore cursor position
}

# Function Press Enter to continue
function_press_enter() {
  echo -e " ${BOLD}${PRESS_ENTER_CONTINUE}${RESET}"
  read
}
# Function Welcome User
function_welcome_user() {
  languages_available=$(function_list_languages)
  if [ $? -eq 0 ]; then
    echo -e "   ${HELLO} ${BOLD}${YELLOW}${USER^^}!${RESET} $WELCOME_SCRIPT ${BOLD}${CYAN}${NIXOS_VERSION:0:5}${RESET}
   ${MSG_LANG_SUP} ${BOLD}${GREEN}${languages_available^^}${RESET}.\n"
  fi
}
# Function that lists .LANGUAGE content
function_list_languages() {
  local dir="./LANGUAGE"
  # List files removing .lang
  languages=$(ls "$dir"/*.lang 2>/dev/null | sed 's/.*\/\(.*\)\.lang/\1/')
  # Convert to horizontal
  languages_horizontal=$(echo "$languages" | tr '\n' ' ')
  echo -e "${languages_horizontal^^}"
}
# Function Features Status
function_features_status() {
  list_all_functions="_PT _EN _ES BAK 001 002 003 004 005 006 007 008 009 010"
  # Custom message based on role ID
  get_custom_message() {
    local id="$1"
    case "$id" in
    _??) echo "\n   [ ${GREEN}${CHECK_MARK}${RESET} ] ${MSG_LANG} ${id:1:2}" ;;
    BAK) echo "${MSG_BAK}" ;;
    001) echo "${MSG_001}" ;;
    002) echo "${MSG_002}" ;;
    003) echo "${MSG_003}" ;;
    004) echo "${MSG_004}" ;;
    005) echo "${MSG_005}" ;;
    006) echo "${MSG_006}" ;;
    007) echo "${MSG_007}" ;;
    008) echo "${MSG_008}" ;;
    009) echo "${MSG_009}" ;;
    010) echo "${MSG_010}" ;;
    *) echo "" ;;
    esac
  }
  # Function to process the file and print custom messages
  process_file() {
    local file_path="/etc/nixos/bak/applied.features"
    local ID_FUNCTION NAME_FUNCTION DATE_FUNCTION

    while IFS=- read -r ID_FUNCTION NAME_FUNCTION DATE_FUNCTION; do
      if [[ "$list_all_functions" =~ $ID_FUNCTION ]]; then
        local custom_message=$(get_custom_message "$ID_FUNCTION")
        if [[ -n "$custom_message" ]]; then
          echo -e "${custom_message}\n"
          sleep 1
        fi
      fi
    done <"$file_path"
  }
  process_file
}
# Function progress bar
function_progress_bar1() {
  local speed=0.05  # Animation speed in seconds
  local width=25    # Progress bar width
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
        #bar+="<-X->"
        bar+="<-NixOS->"
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
    # Display progress bar
    printf ""
    printf " ${BOLD}${YELLOW}[${bar:0:$width}]${RESET}" #${PREPARING_ENVIRONMENT}${RESET}"
    printf ""
  done
  # Clear the end line before leaving
  printf "\r\033[K"
}
#
# Function progress bar
function_progress_bar2() {
  # Interval between updates
  local delay=0.005

  # Character set for simulation
  local chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_+=[]{}<>?,."

  # Function to generate random character set
  random_char() {
    echo -n "${chars:RANDOM%${#chars}:1}"
  }

  # Function to display random characters
  display_random_chars() {
    local pid=$1
    local prefix suffix

    while kill -0 $pid 2>/dev/null; do
      # Generate seven random characters for the prefix and suffix
      prefix=$(for _ in {1..7}; do random_char; done | tr -d '\n')
      suffix=$(for _ in {1..7}; do random_char; done | tr -d '\n')

      # Display the complete string
      echo -ne "\r${prefix}--NixOS--${suffix}"

      # Wait for the defined interval
      sleep $delay
    done

    # Clear the line before exiting
    printf "\r\033[K"
    echo
  }

  # Gets the PID of the function passed as an argument
  local pid=$1

  # Executa a função de exibição enquanto a função passada está em execução
  display_random_chars $pid
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
    echo -e "   ${FLASHING}${BG_RED}${OFFLINE_INTERNET^^}${FLASHING}${RESET} ${MSG_OFFLINE_INTERNET}\n"
    echo -e "   ${CONNECT_WIFI}\n   ${YELLOW}${COMMAND_CONNECT_WIFI}${RESET}\n"
    exit 1
  fi
}
#
function_requirements() {
  # List of programs required in this script
  list_programs=("lolcat" "pciutils" "zip" "unzip")
  header=$(function_header_fixed)
  echo -e "${BOLD}${CYAN}${header}${RESET}"
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
        nix-env -iA nixos.$list_pkgs &>/dev/null &
        pkg_pid=$!
        # Run progress bar while function_task is running
        function_progress_bar2 $pkg_pid
        # Wait for the installation to complete
        wait $pkg_pid
        # Pkg installed successfully message
        echo -e " ${YELLOW}$list_pkgs${RESET} ${INSTALL_SUCCESS}"
      }
    done

  elif [[ "$response" == "n" || "$response" == "N" ]]; then
    echo -e "\n   ${BG_RED}${NEED_TO_INSTALL}\n"
    exit 0
  else
    function_header_fixed
    echo -e "   $HELLO ${BOLD}${YELLOW}${USER^^}!${RESET} $WELCOME_SCRIPT ${BOLD}${CYAN}${NIXOS_VERSION:0:5}.${RESET}\n"
    function_requirements
  fi
  # Test after installation of requirements
  if function_check_list_programs; then
    echo -e "\n   ${BOLD}${GREEN}${ALL_RIGHT_REQUIREMENTS}${RESET}\n"
    function_press_enter
    function_header_fixed | lolcat 2>/dev/null
    echo -e "   $HELLO ${BOLD}${YELLOW}${USER^^}!${RESET} $WELCOME_SCRIPT ${BOLD}${CYAN}${NIXOS_VERSION:0:5}.${RESET}\n"
    return 0
  else
    echo -e "   ${BG_RED}${FAILURE_TO_INSTALL_REQUIREMENTS}\n"
    exit 1
  fi
}
# Function Backup Initial
function_backup_initial() {
  local src_dir="/etc/nixos"
  local dst_dir="/etc/nixos/bak"
  local backup_file_base="backup_configuration.zip"
  # Checks if the target directory exists, otherwise creates it using sudo
  if [[ ! -d "$dst_dir" ]]; then
    echo -e "   ${BOLD}${DONT_WORRY^^} ${NEED_PASSWORD_MAKE_DIRBAK_INITIAL}${RESET}\n\
     ${dst_dir}/${backup_file_base}\n"
    sudo mkdir -p "$dst_dir"
  fi
  # Sets the name of the initial backup file
  backup_file="$dst_dir/$backup_file_base"
  # Creates backup_configuration.zip if it does not exist
  if [[ ! -e "$backup_file" ]]; then
    # Creates a zip archive of all .nix files in the source directory
    sudo zip -j "$backup_file" "$src_dir"/*.nix
    echo ""
    # Make file applied.features
    sudo touch /etc/nixos/bak/applied.features
    local date_str=$(date +%Y_%d_%m)
    # Execute the additional code regardless of the detected language
    echo -e "_${LANGUAGE_CODE^^}-Detect_Language-${date_str}" | sudo tee -a /etc/nixos/bak/applied.features >/dev/null
    echo -e "BAK-Backup_Initial-${date_str}" | sudo tee -a /etc/nixos/bak/applied.features >/dev/null
    function_press_enter
    function_header_fixed | lolcat 2>/dev/null
  fi
}
# Function Backup Sequential
function_backup_sequential() {
  local src_dir="/etc/nixos"
  local dst_dir="/etc/nixos/bak"
  local backup_file_base="backup_configuration.zip"
  local version=1
  # Increments the version until it finds an available file name
  while [[ -e "$dst_dir/${version}_$backup_file_base" ]]; do
    ((version++))
  done
  # Sets the name of the sequential backup file
  local backup_file="$dst_dir/${version}_$backup_file_base"
  # Creates a zip archive of all .nix files in the source directory
  sudo zip -j "$backup_file" "$src_dir"/*.nix
}
function_typed_texts() {
  echo -e "                              ${BOLD}${YELLOW}${TITLE_PRESENTATION^^}${RESET}\n"
  # Text used
  text="${TEXT_PRESENTATION}"
  # maximum character length per line
  length_max_line=80
  # delay between printing each character
  delay=0.0005
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
  IFS=$'\n' read -d '' -r -a lines <<<"$(function_split_text "$text" $length_max_line)"
  # Loop for each line in the lines array
  for line in "${lines[@]}"; do
    # Loop to print each character with delay
    for ((i = 0; i < ${#line}; i++)); do
      echo -n "${line:$i:1}"
      sleep $delay
    done
    echo
  done
  echo -e "\n                                                   ${CYAN}$AUTHOR${RESET}\n"
}

# Function view /etc/nixos/bak directory
function_view_dir_bak() {
  function_header_fixed | lolcat 2>/dev/null
  printf "   ${BOLD}${YELLOW}${IMPORTANT^^}${RESET} ${BOLD}${MSG_INITIAL_BACKUP_REMINDER}${RESET}
   ${dst_dir}/${backup_file_base}

    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${SYMBOL_TRIANGLE_RIGHT} 1-${TITLE_ALL_ABOUT_BACKUPS^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 1-${OPTION_VIEW_BACKUP_FOLDER^^}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  ls -lha /etc/nixos/bak
  echo ""
  function_press_enter
  function_backups_menu
}

# Function to list specific files in /etc/nixos/bak directory
function_list_backups() {
  local src_dir="/etc/nixos/bak"
  function_header_fixed | lolcat 2>/dev/null
  printf "   ${MSG_SAVE_BACKUP_CONFIGURATIONS1} ${BOLD}${src_dir}${RESET}.
   ${BOLD}${CYAN}${MSG_SAVE_BACKUP_CONFIGURATIONS2}${RESET}

    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${SYMBOL_TRIANGLE_RIGHT} 1-${TITLE_ALL_ABOUT_BACKUPS^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 2-${TITLE_ALL_BACKUPS^^}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  ls -lh --time-style=+"%Y-%m-%d  |  %H:%M  |  " /etc/nixos/bak/[1-9]_backup_configuration.zip 2>/dev/null |
    awk '{print $6, $7, $8, $9, $10, $11}' | sed 's/\/etc\/nixos\/bak\///'
  printf "\n${BOLD}${MSG_FILE_BACKUP_INITIAL}${RESET}\n\n"
  ls -lh --time-style=+"%Y-%m-%d  |  %H:%M  |  " /etc/nixos/bak/backup_configuration.zip 2>/dev/null |
    awk '{print $6, $7, $8, $9, $10, $11}' | sed 's/\/etc\/nixos\/bak\///'
  echo ""
  function_press_enter
  function_backups_menu
}

function_save_backups() {
  local src_dir="/etc/nixos/bak"
  local dst_dir="/home/$USER/Downloads/save_backup_configurations"
  function_header_fixed | lolcat 2>/dev/null
  printf "   ${MSG_SAVE_BACKUP_CONFIGURATIONS1} ${BOLD}${src_dir}${RESET}.
   ${BOLD}${CYAN}${MSG_SAVE_BACKUP_CONFIGURATIONS2}${RESET}

    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${SYMBOL_TRIANGLE_RIGHT} 1-${TITLE_ALL_BACKUPS^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 3-${TITLE_SAVE_BACKUPS^^}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  # Stores file names in an array
  local files=($(ls $src_dir/*backup_configuration.zip 2>/dev/null | sed 's/\/etc\/nixos\/bak\///'))

  if [[ ${#files[@]} -eq 0 ]]; then
    echo ${NO_FILES_FOUND}${RESET}
    exit 1
  fi
  # Select a file
  printf "${BOLD}${ALL_FILES} ${RESET}\n"
  for i in "${!files[@]}"; do
    echo "$((i + 1))) ${files[$i]}"
  done

  # Read user choice
  printf "${BOLD}${SELECT_A_FILE} ${RESET}"
  read choice

  # Assign the chosen file to a variable
  local file_selected="${files[$((choice - 1))]}"

  # Check if the choice is valid
  if [[ -z "$file_selected" ]]; then
    echo "${INVALID_OPTION}${RESET}"
    exit 1
  fi

  # Case for handling choice dynamically
  case "$file_selected" in
  *)
    # Checks if the target directory exists, otherwise creates
    if [[ ! -d "$dst_dir" ]]; then
      mkdir -p "$dst_dir"
    fi
    cp "$src_dir/$file_selected" "$dst_dir/$file_selected" 2>/dev/null
    if [ $? -eq 0 ]; then
      printf "\n   ${CYAN}${MSG_SAVE_BACKUP_CONFIGURATIONS3}${RESET}\n\n"
      function_press_enter
      function_backups_menu
    else
      printf "\n   ${RED}${MSG_SAVE_BACKUP_CONFIGURATIONS4}${RESET}\n\n"
      function_press_enter
      function_save_backups
    fi
    ;;
  esac
}

# Function Detect GPU
function_detect_gpu() {
  function_header_fixed | lolcat 2>/dev/null
  printf "   ${MSG_SAVE_BACKUP_CONFIGURATIONS1} ${BOLD}${src_dir}${RESET}.
   ${BOLD}${CYAN}${MSG_SAVE_BACKUP_CONFIGURATIONS2}${RESET}

    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${SYMBOL_TRIANGLE_RIGHT} 1-${TITLE_CONFIGURE_HARDWARE^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 1-${TITLE_DETECT_VIDEO_CARD^^}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  BOLD=$(tput bold)
  RESET=$(tput sgr0)
  # Detects and stores the output of the lspci command by filtering VGA
  gpus=$(lspci | grep -i 'vga\|3d\|display' | grep VGA)
  # Counts the number of detected GPUs
  qtd_gpu=$(echo "$gpus" | wc -l)
  # Initializes control variables for GPU types
  has_intel=false
  has_nvidia=false
  has_amd=false
  # Check detected GPU models
  if echo "$gpus" | grep -qi 'intel'; then
    has_intel=true
  fi

  if echo "$gpus" | grep -qi 'nvidia'; then
    has_nvidia=true
  fi

  if echo "$gpus" | grep -qi 'amd'; then
    has_amd=true
  fi
  # Determines and displays the message about the type of GPU detected
  if $has_intel && ! $has_nvidia && ! $has_amd; then
    gpu_DETECTED=": INTEL."
  elif $has_nvidia && ! $has_intel && ! $has_amd; then
    gpu_DETECTED=": NVIDIA."
  elif $has_amd && ! $has_intel && ! $has_nvidia; then
    gpu_DETECTED=": AMD."
  elif $has_nvidia && $has_intel && ! $has_amd; then
    gpu_DETECTED=": NVIDIA - INTEL."
  elif $has_nvidia && $has_amd && ! $has_intel; then
    gpu_DETECTED=": NVIDIA - AMD."
  elif $has_amd && $has_intel && ! $has_nvidia; then
    gpu_DETECTED=": AMD - INTEL."
  else
    gpu_DETECTED=""
  fi
  # Displays the number of GPUs detected
  printf "${WERE_DETECTED} ${BOLD}${qtd_gpu}${RESET} ${VIDEO_CARDS}${gpu_DETECTED}\n\n"
  # Formats and displays information for each GPU
  printf "$gpus" | awk -v bold="$BOLD" -v reset="$RESET" '
    {
        # Remove "VGA compatible controller:" e "(rev ...)"
        sub(/VGA compatible controller: /, "", $0)
        sub(/\(rev .*?\)/, "", $0)

        # Print the GPU number
        printf bold "GPU: " reset "%d\n", NR
        
        # Print the ID (bus)
        printf bold "ID:  " reset "%s\n", $1
        
        # Prints the GPU model and sets the GPU type variable
        printf bold "MODEL: " reset
        for (i=2; i<=NF; i++) printf "%s ", $i
        printf "\n\n"
    }'
}
function_install_gpu_NVIDIA_AMD() {
  local config_file="/etc/nixos/configuration.nix"
  local search_line="  imports ="
  local insert_line="      ./config_gpu.nix"

  # Checking if the row has already been added
  if grep -q "${insert_line}" "$config_file"; then
    printf "\n${THE_FILE} ${BOLD}${insert_line:8:22}${RESET} ${IS_READY_IMPORT} ${BOLD}${config_file:11:28}.${RESET}
    
   ${BOLD}${FILE_DETAILS^^} ${CYAN}/etc/nixos/config_gpu.nix${RESET}\n"
    ls -lh /etc/nixos/config_gpu.nix
    printf "   "
  else
    # Using sudo to edit the file and add the line below "  imports ="
    sudo sed -i "/${search_line}/!b;n;a\\
${insert_line}" "$config_file"

    local file_path="/etc/nixos/config_gpu.nix"

    sudo tee "$file_path" >/dev/null <<EOF
{ config, lib, pkgs, ... }:
{

# Nvidia settings for hybrid graphics(AMD video cores and Nvidia)
services.xserver.videoDrivers = ["nvidia" "amdgpu-pro"];

hardware.nvidia = {
  # Enable the Nvidia settings menu,
  nvidiaSettings = true;
  
  # Modesetting is required.
  modesetting.enable = true;
  
  # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  powerManagement.enable = false;
  
  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  package = config.boot.kernelPackages.nvidiaPackages.stable;
  
  # Fixes a glitch
  nvidiaPersistenced = true;
  
  # Required for amdgpu and nvidia gpu pairings
  prime = {
    #sync.enable = true;
    #reverseSync.enable = true;
    
    # Enable if using an external GPU
    #allowExternalGpu = false;
    
    # Whether to enable render offload support using the NVIDIA proprietary driver via PRIME.
    offload.enable = true;
    
    # Report bus IDs for NVIDIA and AMD GPUs
    amdgpuBusId = "PCI:5:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
};

# Enable OpenGL drivers.
   hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  
# Packages necessary
environment.systemPackages = with pkgs; [
  glxinfo
  lshw
  nvtop
  autoAddDriverRunpath
  amdvlk
  driversi686Linux.amdvlk
];

}
EOF

    printf "\n${THE_FILE} ${BOLD}${insert_line:8:22}${RESET} ${IS_READY_IMPORT} ${BOLD}${config_file:11:28}.${RESET}
    
  ${BOLD}${FILE_DETAILS^^} ${CYAN}/etc/nixos/config_gpu.nix${RESET}\n"
    ls -lh /etc/nixos/config_gpu.nix

    printf "\n   ${BOLD}${FILE_DETAILS^^} ${CYAN}/etc/nixos/configuration.nix${RESET}\n"

    head -n 15 /etc/nixos/configuration.nix
    echo ""
  fi
  function_press_enter
  function_video_card_menu
}
# Function to display the main menu
function_main_menu() {
  function_header_fixed | lolcat 2>/dev/null
  function_welcome_user
  printf "    ${BOLD}${YELLOW}${SYMBOL_HOME} ${TITLE_CATEGORIZED_OPTIONS_MENU^^}${RESET}
${YELLOW}----------------------------------------------------------------------------------${RESET}
   1. ${CYAN}${CATEGORY_All_BACKUPS}${RESET}
   2. ${CYAN}${CATEGORY_HARDWARE_CONFIGURATION}${RESET}
   3. ${CYAN}${CATEGORY_SOFTWARE_INSTALLATION}${RESET}
   4. ${CYAN}${CATEGORY_SYSTEM_SETTINGS}${RESET}
   5. ${CYAN}${CATEGORY_GAME_INSTALLATION}${RESET}
   6. ${CYAN}${CATEGORY_SERVICE_DEPLOYMENT}${RESET}
   7. ${CYAN}${CATEGORY_APPLY_ALL_CHANGES}${RESET}

   0. ${CYAN}${EXIT_SCRIPT}${RESET}
${YELLOW}----------------------------------------------------------------------------------${RESET}\n"
  echo -n "   ${CHOOSE_OPTION} "
  read option
  case $option in
  1) function_backups_menu ;;
  2) function_configure_hardware_menu ;;
  3) function_install_software_menu ;;
  4) function_configure_system_menu ;;
  5) function_install_games_menu ;;
  6) function_implement_services_menu ;;
  0) echo "" && exit 0 ;;
  *) echo -e "  ${RED}${SYMBOL_ERROR}${RESET} ${BOLD}${INVALID_OPTION}${RESET} ${TRY_AGAIN}${RESET}" && sleep 2 && function_main_menu ;;
  esac
}

# Submenu backups
function_backups_menu() {
  local dst_dir="/etc/nixos/bak"
  local backup_file_base="backup_configuration.zip"
  function_header_fixed | lolcat 2>/dev/null
  printf "   ${BOLD}${YELLOW}${IMPORTANT^^}${RESET} ${BOLD}${MSG_INITIAL_BACKUP_REMINDER}${RESET}
   ${dst_dir}/${backup_file_base}

    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 1-${TITLE_ALL_ABOUT_BACKUPS^^}${RESET}
----------------------------------------------------------------------------------${RESET}
   1. ${CYAN}${OPTION_VIEW_BACKUP_FOLDER}${RESET}
   2. ${CYAN}${OPTION_VIEW_BACKUP_LIST}${RESET}
   3. ${CYAN}${OPTION_COPY_BACKUP_TO}${RESET}

   0. ${CYAN}${OPTION_BACK_TO_MAIN_MENU}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  echo -n "   ${CHOOSE_OPTION} "
  read option
  case $option in

  1) function_view_dir_bak ;;
  2) function_list_backups ;;
  3) function_save_backups ;;
  0) function_main_menu ;;
  *) echo -e "  ${RED}${SYMBOL_ERROR}${RESET} ${BOLD}${INVALID_OPTION}${RESET} ${TRY_AGAIN}${RESET}" && sleep 2 && function_backups_menu ;;
  esac
}

# Submenu configure hardware
function_configure_hardware_menu() {
  function_header_fixed | lolcat 2>/dev/null
  printf "   ${MSG_CONFIGURE_YOUR_HARDWARE}
   ${BOLD}${MSG_NEW_FEATURES}${RESET} ${MSG_REPOGIT}

    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 2-${TITLE_CONFIGURE_HARDWARE^^}${RESET}
----------------------------------------------------------------------------------${RESET}
   1. ${CYAN}${OPTION_VIDEO_CARD}${RESET}

   0. ${CYAN}${OPTION_BACK_TO_MAIN_MENU}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  echo -n "   ${CHOOSE_OPTION} "
  read option
  case $option in
  1) function_video_card_menu ;;
  0) function_main_menu ;;
  *) echo -e "  ${RED}${SYMBOL_ERROR}${RESET} ${BOLD}${INVALID_OPTION}${RESET} ${TRY_AGAIN}${RESET}" && sleep 2 && function_configure_hardware_menu ;;
  esac
}

# Submenu de placas de vídeo
function_video_card_menu() {
  function_header_fixed | lolcat 2>/dev/null
  printf "   ${BOLD}${MSG_CONFIGURE_VIDEO_CARD}${RESET}
   ${MSG_OR_DETECT_VIDEO_CARD}

    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${SYMBOL_TRIANGLE_RIGHT} 2-${TITLE_CONFIGURE_HARDWARE^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 1-${TITLE_VIDEO_CARD^^}${RESET}
----------------------------------------------------------------------------------${RESET}
   1. ${CYAN}${OPTION_DETECT_VIDEO_CARD}${RESET}
   2. ${CYAN}${OPTION_INSTALL_INTEL_CARDS}${RESET}
   3. ${CYAN}${OPTION_INSTALL_NVIDIA_CARDS}${RESET}
   4. ${CYAN}${OPTION_INSTALL_AMD_CARDS}${RESET}
   5. ${CYAN}${OPTION_INSTALL_HIBRID_CARDS}${RESET}
   6. ${CYAN}${OPTION_INSTALL_HIBRID_CARDS}${RESET}
   7. ${CYAN}${OPTION_INSTALL_HIBRID_CARDS}${RESET}

   9. ${CYAN}${OPTION_BACK_TO_PREVIOUS_MENU}${RESET}
   0. ${CYAN}${OPTION_BACK_TO_MAIN_MENU}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  echo -n "   ${CHOOSE_OPTION} "
  read option
  case $option in
  1) function_detect_gpu && function_press_enter && function_video_card_menu ;;
  2) echo "Instalar Placas Intel" ;;
  3) echo "Instalar Placas NVidia" ;;
  4) echo "Instalar Placas AMD" ;;
  5) function_install_gpu_NVIDIA_AMD ;;
  6) echo "Instalar Placas NVidia" ;;
  7) echo "Instalar Placas AMD" ;;
  9) function_configure_hardware_menu ;;
  0) function_main_menu ;;
  *) echo -e "  ${RED}${SYMBOL_ERROR}${RESET} ${BOLD}${INVALID_OPTION}${RESET} ${TRY_AGAIN}${RESET}" && sleep 2 && function_video_card_menu ;;
  esac
}

# Submenu de instalação de softwares
function_install_software_menu() {
  function_header_fixed | lolcat 2>/dev/null
  printf "   ${BOLD}${MSG_SCRIPT_PURPOSE1}${RESET}
   ${MSG_SCRIPT_PURPOSE2}

    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 3-${TITLE_INSTALL_APPS^^}${RESET}
----------------------------------------------------------------------------------${RESET}
   1. ${CYAN}${OPTION_ENABLE_FLATPAK}${RESET}
   2. ${CYAN}${OPTION_INSTALL_FLATPAK}${RESET}
   3. ${CYAN}${OPTION_ENABLE_APPIMAGE}${RESET}
   4. ${CYAN}${OPTION_INSTALL_APPIMAGE}${RESET}
   5. ${CYAN}${OPTION_INSTALL_APPS_ON_SYSTEM}${RESET}
   6. ${CYAN}${OPTION_INSTALL_APPS_USER_ONLY}${RESET}
   7. ${CYAN}${OPTION_INSTALL_APPS_IN_SANDBOX}${RESET}

   0. ${CYAN}${OPTION_BACK_TO_MAIN_MENU}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  echo -n "   ${CHOOSE_OPTION} "
  read option
  case $option in
  1) echo "Habilitar FlatPaks" ;;
  2) echo "Instalar Flatpaks" ;;
  3) echo "Habilitar AppImage" ;;
  4) echo "Instalar AppImage" ;;
  5) echo "Instalar Apps no Sistema" ;;
  6) echo "Instalar Apps apenas para o Usuário" ;;
  7) echo "Testar Apps antes de Instalar" ;;
  0) function_main_menu ;;
  *) echo -e "  ${RED}${SYMBOL_ERROR}${RESET} ${BOLD}${INVALID_OPTION}${RESET} ${TRY_AGAIN}${RESET}" && sleep 2 && function_install_software_menu ;;
  esac
}

# Submenu de configuração do sistema
function_configure_system_menu() {
  function_header_fixed | lolcat 2>/dev/null
  printf "    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 4-${TITLE_CONFIGURE_SYSTEM^^}${RESET}
----------------------------------------------------------------------------------${RESET}
   1. ${CYAN}${OPTION_BOOTLOADERS}${RESET}
   2. ${CYAN}${OPTION_DESKTOP_ENVIRONMENT}${RESET}

   0. ${CYAN}${OPTION_BACK_TO_MAIN_MENU}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  echo -n "   ${CHOOSE_OPTION} "
  read option
  case $option in
  1) bootloaders_menu ;;
  2) desktops_environment_menu ;;
  0) function_main_menu ;;
  *) echo -e "  ${RED}${SYMBOL_ERROR}${RESET} ${BOLD}${INVALID_OPTION}${RESET} ${TRY_AGAIN}${RESET}" && sleep 2 && function_configure_system_menu ;;
  esac
}

# Submenu de bootloaders
bootloaders_menu() {
  function_header_fixed | lolcat 2>/dev/null
  printf "    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${SYMBOL_TRIANGLE_RIGHT} 4-${TITLE_CONFIGURE_SYSTEM^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 1-${TITLE_BOOTLOADERS^^}${RESET}
----------------------------------------------------------------------------------${RESET}
   1. ${CYAN}${OPTION_GRUB_INSTALL}${RESET}
   2. ${CYAN}${OPTION_GRUB_THEME}${RESET}

   9. ${CYAN}${OPTION_BACK_TO_PREVIOUS_MENU}${RESET}
   0. ${CYAN}${OPTION_BACK_TO_MAIN_MENU}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  echo -n "   ${CHOOSE_OPTION} "
  read option
  case $option in
  1) echo "Instalar GRUB" ;;
  2) echo "Temas GRUB" ;;
  9) function_configure_system_menu ;;
  0) function_main_menu ;;
  *) echo -e "  ${RED}${SYMBOL_ERROR}${RESET} ${BOLD}${INVALID_OPTION}${RESET} ${TRY_AGAIN}${RESET}" && sleep 2 && bootloaders_menu ;;
  esac
}

# Submenu de ambientes desktop
desktops_environment_menu() {
  function_header_fixed | lolcat 2>/dev/null
  printf "    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${SYMBOL_TRIANGLE_RIGHT} 4-${TITLE_CONFIGURE_SYSTEM^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 2-${TITLE_DESKTOP_ENVIRONMENT^^}${RESET}
----------------------------------------------------------------------------------${RESET}
   1. ${CYAN}${OPTION_INSTALL_GNOME}${RESET}
   2. ${CYAN}${OPTION_INSTALL_KDE}${RESET}
   3. ${CYAN}${OPTION_INSTALL_XFCE}${RESET}
   4. ${CYAN}${OPTION_INSTALL_CINNAMON}${RESET}
   5. ${CYAN}${OPTION_INSTALL_DEEPIN}${RESET}
   6. ${CYAN}${OPTION_INSTALL_BUDGIE}${RESET}
   7. ${CYAN}${OPTION_INSTALL_MATE}${RESET}
   8. ${CYAN}${OPTION_INSTALL_HYPRLAND}${RESET}

   9. ${CYAN}${OPTION_BACK_TO_PREVIOUS_MENU}${RESET}
   0. ${CYAN}${OPTION_BACK_TO_MAIN_MENU}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  echo -n "   ${CHOOSE_OPTION} "
  read option
  case $option in
  1) echo "Gnome" ;;
  2) echo "KDE Plasma" ;;
  3) echo "XFCE" ;;
  4) echo "Cinnamon" ;;
  5) echo "Deepin" ;;
  6) echo "Budgie" ;;
  7) echo "Mate" ;;
  8) echo "Hyprland" ;;
  9) function_configure_system_menu ;;
  0) function_main_menu ;;
  *) echo -e "  ${RED}${SYMBOL_ERROR}${RESET} ${BOLD}${INVALID_OPTION}${RESET} ${TRY_AGAIN}${RESET}" && sleep 2 && desktops_environment_menu ;;
  esac
}

# Submenu de instalação de jogos
function_install_games_menu() {
  function_header_fixed | lolcat 2>/dev/null
  printf "    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 5-${TITLE_INSTALL_GAMES^^}${RESET}
----------------------------------------------------------------------------------${RESET}
   1. ${CYAN}${OPTION_INSTALL_STEAM}${RESET}
   2. ${CYAN}${OPTION_INSTALL_HEROIC}${RESET}
   3. ${CYAN}${OPTION_INSTALL_LUTRIS}${RESET}
   4. ${CYAN}${OPTION_INSTALL_GAME_FLATPAK}${RESET}

   0. ${CYAN}${OPTION_BACK_TO_MAIN_MENU}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  echo -n "   ${CHOOSE_OPTION} "
  read option
  case $option in
  1) echo "Instalar Steam" ;;
  2) echo "Instalar Heroic Games" ;;
  3) echo "Instalar Lutris" ;;
  4) echo "Instalar Game Flatpak" ;;
  0) function_main_menu ;;
  *) echo -e "  ${RED}${SYMBOL_ERROR}${RESET} ${BOLD}${INVALID_OPTION}${RESET} ${TRY_AGAIN}${RESET}" && sleep 2 && function_install_games_menu ;;
  esac
}

# Submenu de implantação de serviços
function_implement_services_menu() {
  function_header_fixed | lolcat 2>/dev/null
  printf "    ${YELLOW}${SYMBOL_HOME} 0-${TITLE_OPTIONS_MENU^^} ${BOLD}${SYMBOL_TRIANGLE_RIGHT} 6-${TITLE_DEPLOY_SERVICE^^}${RESET}
----------------------------------------------------------------------------------${RESET}
   1. ${CYAN}${OPTION_INSTALL_WEB_DATA}${RESET}
   2. ${CYAN}${OPTION_INSTALL_VIRT}${RESET}
   3. ${CYAN}${OPTION_INSTALL_MONITORING}${RESET}
   4. ${CYAN}${OPTION_INSTALL_DIR_DATA}${RESET}
   5. ${CYAN}${OPTION_INSTALL_SEC_NET}${RESET}
   6. ${CYAN}${OPTION_INSTALL_EMAIL_MSG}${RESET}
   7. ${CYAN}${OPTION_INSTALL_DEV}${RESET}
   8. ${CYAN}${OPTION_INSTALL_CONFIG_MANAGEMENT}${RESET}

   0. ${CYAN}${OPTION_BACK_TO_MAIN_MENU}${RESET}
----------------------------------------------------------------------------------${RESET}\n"
  echo -n "   ${CHOOSE_OPTION} "
  read option
  case $option in
  1) echo "Servidores Web" ;;
  2) echo "Banco de Dados" ;;
  3) echo "Containers" ;;
  4) echo "Virtualização" ;;
  5) echo "Servidores Web" ;;
  6) echo "Banco de Dados" ;;
  7) echo "Containers" ;;
  8) echo "Virtualização" ;;
  0) function_main_menu ;;
  *) echo -e "  ${RED}${SYMBOL_ERROR}${RESET} ${BOLD}${INVALID_OPTION}${RESET} ${TRY_AGAIN}${RESET}" && sleep 2 && function_implement_services_menu ;;
  esac
}

# Code applied
clear
function_detect_language
function_requirements
function_header_fixed | lolcat 2>/dev/null
function_welcome_user
function_backup_initial
function_main_menu
