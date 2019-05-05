#!/bin/bash

# init 
#
# Purpose: To simplify the process of provisioning a new developer machine
#
# Method: Any tools, software or configurations that are commonly
# needed may be offered by running this script. 
#
# - No software will be installed without the user directing the script to do so
# - When this script is first run a series of prompts will allow the user to
#   select which tools (and versions) should be installed
# - Once configured the script will attempt to install each selected piece of
#   software and display progress in a clean and simple manner.
# - If any particular process has failed, the user should be notified and 
#   provided the option to reattempt, or clean up any files that may have been
#   created in the process prior to failure.
# - It should be made explicit as to why a certain process has failed, and how
#   to amend the issue if possible.
# - This script should NOT be run as sudo, and should close if the user 
#   attempts to do so
# - The script will request the sudoers password in prompt and only use it for
#   package manager operations

################# GLOBAL VARS #################
USERNAME=$USER
HOSTNAME=$HOSTNAME
DATE="$(date)"

# PROMPT COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NOCOLOR='\033[0m'

################# FEATURE VARS ################
# (n) for don't install (y) for install
GIT='n'
GIT_PROMPT='n'
PYENV='n'
PYTHON3='n'
PYTHON2='n'
BASH_PROMPT='n'
UPDATE_EXISTING='n'
BUILD_TOOLS='n'
YARN='n'
NPM='n'
NODEJS='n'

############## HELPER FUNCTIONS ###############

# purpose: set a feature variable based on user input
#
# args: $1 - the name of the feature var e.g. 'GIT'
#       $2 - the 'friendly' name of the feature var e.g. 'install git?'
function ask_feature {
  local -n ref=$1
  read -n 1 -p "$2 [y/N] " answer
  case $answer in
    [yY]* ) ref='y'
	    printf "\n"
	    ;;
    [nN]* ) ref='n'
	    printf "\n"
	    ;;
  esac
}

# purpose: output the value of a feature variable
# args: $1 - the name of the feature var e.g. 'GIT'
#       $2 - the 'friendly' name of the feature var e.g. 'install git'
function print_feature_selection {
  case "${!1}" in
    [yY]* ) printf "${GREEN}[Run ]${NOCOLOR} $2\n"
            ;;
    [nN]* ) printf "${RED}[Skip]${NOCOLOR} $2\n"
            ;;
  esac
}

# purpose: call print_feature_selection on all feature variables
# args: none
#
function print_feature_selections {
  print_feature_selection GIT "Install GIT"
  print_feature_selection GIT_PROMPT "Add git branch into bash prompt"
  print_feature_selection PYENV "Install pyenv"
  print_feature_selection PYTHON3 "Install Python 3 (via pyenv)"
  print_feature_selection PYTHON2 "Install Python 2 (via pyenv)"
  print_feature_selection BASH_PROMPT "Set custom bash prompt"
  print_feature_selection UPDATE_EXISTING "Upgrade all installed packages"
  print_feature_selection BUILD_TOOLS "Install build essential tools"
  print_feature_selection YARN "Install yarn"
  print_feature_selection NPM "Install NPM"
  print_feature_selection NODEJS "Install NodeJS"
}


# purpose: clear the terminal window and print out the init.sh header
# args: none
function print_header {
  clear
  printf "${ORANGE}"
  printf "===============================================================================\n"
  printf "init.sh | hostname: $HOSTNAME | user: $USERNAME | date: $DATE \n"
  printf "===============================================================================\n"
  printf "\n${NOCOLOR}"
}

############## INSTALL FUNCTIONS ##############

function install_git {
  apt install git
}

function set_git_prompt {
  echo "parse_git_branch() {
  \ngit branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  \n}" >> ~/.bashrc

  echo "$PS1=$PS1\$(parse_git_branch)" >> ~/.bashrc

}

############ END INSTALL FUNCTIONS ############

# purpose: runs the main script
# args: none
function main {

  print_header
  read -n 1 -s -r -p  "Hello $USERNAME! Welcome to init. Press any key to begin"

  # ask about each available option
  print_header

  ask_feature GIT "Install GIT?"
  ask_feature GIT_PROMPT "Add git branch into bash prompt?"
  ask_feature PYENV "Install pyenv?"
  ask_feature PYTHON3 "Install Python 3 (via pyenv)"
  ask_feature PYTHON2 "Install Python 2 (via pyenv)"
  ask_feature BASH_PROMPT "Set custom bash prompt?"
  ask_feature UPDATE_EXISTING "Upgrade all installed packages?"
  ask_feature BUILD_TOOLS "Install build essential tools (cmake, make, c++ c, etc)?"
  ask_feature YARN "Install yarn?"
  ask_feature NPM "Install NPM?"
  ask_feature NODEJS "Install NodeJS?"

  # review selected options
  print_header
  print_feature_selections

  printf "\n"

  read -n 1 -p "Continue with these options? [y/N] " answer
  case $answer in
    [yY]* ) ;;
        * ) clear
      exit
      ;;
  esac
}

# run the main function
main
