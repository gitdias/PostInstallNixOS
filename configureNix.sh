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
# Version NixOS
NIXOS_VERSION=$(nixos-version)
AUTHOR="by Mr. Pororocka - Sandro Dias"

# Funtion Header Fixed
function_header_fixed() {
  clear
  tput cup 0 0 # Move cursor to top
  echo -e "\033[5m\n 
    ____           _     ___           _        _ _     _   _ _       ___  ____\n\
   |  _ \ ___  ___| |_  |_ _|_ __  ___| |_ __ _| | |   | \ | (_)_  __/ _ \/ ___|\n\
   | |_) / _ \/ __| __|__| || '_ \/ __| __/ _\` | | |   |  \| | \ \/ / | | \___\n\
   |  __/ (_) \__ \ ||___| || | | \__ \ || (_| | | |   | |\  | |>  <| |_| |___)|\n\
   |_|   \___/|___/\__| |___|_| |_|___/\__\__,_|_|_|   |_| \_|_/_/\_\\___/|____/\n\
----------------------------------------------------------------------------------\n\
                                                                  Version 24.05-1\n\
                                                                                    \033[5m"
  tput sc # Restore cursor position
}

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
      source ./LANGUAGE/us.lang
      ;;
    esac

    #echo $HELLO_WORLD
    echo -e "   $HELLO ${BOLD}${YELLOW}${USER^^}!${RESET} $WELCOME_SCRIPT ${BOLD}${CYAN}${NIXOS_VERSION:0:5}.${RESET}\n"
    return 0

  else

    return 1

  fi

}

function_requirements() {

  # List of programs required in this script
  list_programs=("lolcat")

  # Função para verificar se os list_programas estão instalados
  check_list_programs() {
    not_installed=()
    for list_pkgs in "${list_programs[@]}"; do
      if ! command -v $list_pkgs &>/dev/null; then
        not_installed+=($list_pkgs)
      fi
    done

    if [ ${#not_installed[@]} -eq 0 ]; then
      return 0
    else
      echo -e "   ${GREEN}${ALERT_REQUIREMENTS_OOPS}${RESET}\n   ${ALERT_REQUIREMENTS}${BOLD}${YELLOW}\n   ${not_installed[*]}${RESET}\n "
      return 1
    fi
  }

  # Função de barra de progresso
  progress_bar() {
    local speed=0.05  # Velocidade da animação em segundos (mais rápida)
    local width=20    # Largura da barra de progresso
    local position=0  # Posição inicial do bloco <-X->
    local direction=1 # Direção do movimento (1 = direita, -1 = esquerda)
    local progress=0  # Progresso inicial

    while [ $progress -le 100 ]; do
      # Limpar a linha atual
      printf "\r"

      # Construir a barra de progresso
      bar=""
      for ((i = 0; i < $width; i++)); do
        if [ $i -eq $position ]; then
          bar+="<-X->"
          i=$((i + 4))
        else
          bar+=" "
        fi
      done

      # Atualizar a posição do bloco <-X->
      position=$((position + direction))
      if [ $position -ge $((width - 5)) ] || [ $position -le 0 ]; then
        direction=$((direction * -1))
      fi

      # Incrementar o progresso
      progress=$((progress + 1))

      # Pausar para criar a animação
      sleep $speed

      # Exibir a barra de progresso
      #if nix-env -q | grep -q "^lolcat"; then
      #  printf " ${YELLOW}[${bar:0:$width}] ${PREPARING_ENVIRONMENT}${RESET}" | lolcat
      #else
        printf " ${YELLOW}[${bar:0:$width}] ${PREPARING_ENVIRONMENT}${RESET}"
      #fi

    done

    # Limpar a linha final antes de sair
    printf "\r\033[K"
  }

  # Primeira verificação
  if check_list_programs; then
    exit 0
  fi
  # Testa a conexão com a Internet
  if ! function_detect_internet; then
    suggest_connection
  fi
  # Pergunta se deseja instalar os list_programas faltantes
  read -p "${CONFIRM_INSTALL_REQUIREMENTS}" response
  if [[ "$response" == "s" || "$response" == "S" || "$response" == "y" || "$response" == "Y" ]]; then
    for list_pkgs in "${not_installed[@]}"; do
      {
        nix-env -iA nixos.$list_pkgs &>/dev/null
      } &
      progress_bar
      #show_progress
    done

    # Segunda verificação após a instalação
    if check_list_programs; then
      function_header_fixed | lolcat 2>/dev/null
      echo -e "   ${CYAN}${ALL_RIGHT_REQUIREMENTS}\n 
   ${YELLOW}$list_pkgs\n"
      exit 0
    else
      echo "${RED}${FAILURE_TO_INSTALL_REQUIREMENTS}"
    fi
  fi

}

function_detect_internet() {
  # Testa a conexão pingando o Google DNS
  if ping -c 1 8.8.8.8 &>/dev/null; then
    #echo "Conexão com a Internet está OK."
    return 0
  else
    echo "Sem conexão com a Internet."
    return 1
  fi

}

# Função para sugerir conexão usando nmcli
suggest_connection() {
  echo "Sugestão: Conectar-se a uma rede Wi-Fi usando o comando:"
  echo "nmcli device wifi connect <SSID> password <PASSWORD>"
}

# Code applied

clear

function_header_fixed | lolcat 2>/dev/null

function_detect_language

function_requirements

#function_detect_internet
