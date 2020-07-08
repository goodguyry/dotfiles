#!/bin/bash

# Create a directory if it doesn't already exist.
function mkdirs() {
  if [[ ! -d "${@}" ]]; then
    mkdir "${@}";
    echo "Created ${@}";
  fi;
}

# Conditionally symlink or copy the files.
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

# Check for existing brew before installing.
function brew_install() {
  if $(brew list ${1} &> /dev/null); then
    log_warning "${1} already installed";
  else
    brew install ${@};
  fi;
}
