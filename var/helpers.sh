#!/bin/bash

##
# Show help text
##
function show_help_text() {
cat <<EOT

Usage: $(basename "$0") [--help] [--copy] [--no-sync] [--no-packages] [--no-settings]

OPTIONS:
    ${YELLOW}--help${RESET}            Print this help text
    ${YELLOW}--copy${RESET}            Copy the files in place instead of linking
    ${YELLOW}${RESET}                  editorconfig is always copied.
    ${YELLOW}--no-sync${RESET}         Suppress syncing with GitHub
    ${YELLOW}--no-packages${RESET}     Suppress package installations and updates
    ${YELLOW}--no-settings${RESET}     Suppress configuring OS settings

Documentation can be found at https://github.com/goodguyry/dotfiles

Copyright (c) Ryan Domingue
Licensed under the MIT license.
EOT
}

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

function log_header() {
  printf "$\n{LTGRAY}=> %s${RESET}\n" "${@}";
}

function log_success() {
  printf "$\n{DEEP_GREEN}✅ %s${RESET}\n" "${@}";
}

function log_error() {
  printf "$\n{DEEP_RED}❌ %s${RESET}\n" "${@}";
}

function log_warning() {
  printf "$\n{YELLOW}⚠️  %s${RESET}\n" "${@}";
}

function log_info() {
  printf "$\n{LTGRAY}💡 %s${RESET}\n" "${@}";

##
# Format the init prompt.
##
function print_script_details() {
  ##
  # Detect the operating system to provision.
  #
  # Detect macOS via check for sw_vers. Could also check for $(uname -s) == 'Darwin'
  ##
  [[ "$(type -P sw_vers)" ]] && IS_MACOS=true;
  [[ $(uname -s) == 'Linux' ]] && IS_LINUX=true;

  # If Linux, attempt to detect whether we're on desktop or server.
  if $IS_LINUX; then
    PROVISION_ENV='Linux';

    # Detect desktop environment.
    [[ "$(dpkg -l | grep ubuntu-desktop)" ]] && IS_SERVER=false || IS_SERVER=true;

    # Format message string. e.g, "Linux desktop"
    $IS_SERVER \
      && PROVISION_ENV="${PROVISION_ENV} server" \
      || PROVISION_ENV="${PROVISION_ENV} desktop";
  else
    PROVISION_ENV='macOS';
  fi

  # Parse options
  $COPY_FILES \
    && WRITE_VERB='Copy' \
    || WRITE_VERB='Symlink';

  printf '\n';
  log_warning "This script will do the following for your ${PROVISION_ENV} machine:";
  log_header "  * ${WRITE_VERB} dotfiles into place";
  $INSTALL_PACKAGES && log_header "  * Install and configure ${PROVISION_ENV} packages";
  $CONFIGURE_PREFERENCES && log_header "  * Configure ${PROVISION_ENV} preferences";

  export PROVISION_ENV;
  export WRITE_VERB;
}

##
# Create a directory if it doesn't already exist.
##
function mkdirs() {
  if [[ ! -d "${@}" ]]; then
    mkdir -p "${@}";
    log_success "Created ${@}";
  fi;
}

##
# Conditionally symlink or copy the files.
##
function set_file() {
  local SRC="${DOTFILES_DIRECTORY}/${1}";
  local DEST="$2";
  if $COPY_FILES; then
    # Copy with rsync
    rsync -avz --quiet "${SRC}" "${DEST}";
  else
    # Force create/replace the symlink.
    ln -fs "${SRC}" "${DEST}";
  fi
}

##
# Joins an array with a space.
##
function join_with_space() {
  ITEMS=$(printf " %s" "${@}");
  ITEMS=${ITEMS:1};
  echo "${ITEMS}";
}
