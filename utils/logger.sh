#!/bin/bash

# Logging helpers
# By Necolas Gallagher
# https://github.com/necolas/dotfiles/blob/master/lib/utils

log_header() {
  printf "\n$(tput setaf 188)%s$(tput sgr0)\n" "${@}";
}

log_success() {
  printf "$(tput setaf 150)✓ %s$(tput sgr0)\n" "${@}";
}

log_error() {
  printf "$(tput setaf 196)x %s$(tput sgr0)\n" "${@}";
}

log_warning() {
  printf "$(tput setaf 222)! %s$(tput sgr0)\n" "${@}";
}
