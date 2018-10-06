#!/bin/bash

##
# Logging helpers
# By Necolas Gallagher
# https://github.com/necolas/dotfiles/blob/master/lib/utils
##

DEEP_GREEN=$(tput setaf 112);
DEEP_RED=$(tput setaf 196);
LTGRAY=$(tput setaf 188);
YELLOW=$(tput setaf 222);
RESET=$(tput sgr0);

log_header() {
  printf "\n${LTGRAY}%s${RESET}\n" "${@}";
}

log_success() {
  printf "${DEEP_GREEN}✓ %s${RESET}\n" "${@}";
}

log_error() {
  printf "${DEEP_RED}x %s${RESET}\n" "${@}";
}

log_warning() {
  printf "${YELLOW}! %s${RESET}\n" "${@}";
}
