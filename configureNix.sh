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

# Funtion Header Fixed
function_header_fixed () {
    clear
    tput cup 0 0 # Move cursor to top
    echo -e "\ 
    ____           _     ___           _        _ _     _   _ _       ___  ____\n\
   |  _ \ ___  ___| |_  |_ _|_ __  ___| |_ __ _| | |   | \ | (_)_  __/ _ \/ ___|\n\
   | |_) / _ \/ __| __|__| || '_ \/ __| __/ _\` | | |   |  \| | \ \/ / | | \___\n\
   |  __/ (_) \__ \ ||___| || | | \__ \ || (_| | | |   | |\  | |>  <| |_| |___)|\n\
   |_|   \___/|___/\__| |___|_| |_|___/\__\__,_|_|_|   |_| \_|_/_/\_\\___/|____/\n\
----------------------------------------------------------------------------------\n\
                                                                  Version 24.05-1"
    tput sc # Restore cursor position
}

function_detect_language () {
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
        source ./LANGUAGE/us.lang
        ;;
  esac

  
  echo $HELLO_WORLD
  exit 0

else

  exit 1

fi

}

function_header_fixed

function_detect_language 

#function_requirements () {
    
#}