#!/bin/bash

# Format the init prompt.
function get_init_prompt() {
  local MESSAGE='';

  [ ! $SKIP_GIT_INIT ] && MESSAGE="${MESSAGE} * Initialize a Git repo\n";

  [ $COPY_FILES ] \
    && MESSAGE="${MESSAGE} * Configure the shell environment by copying dotfiles to the home directory\n" \
    || MESSAGE="${MESSAGE} * Configure the shell environment by symlinking dotfiles to the home directory\n";

  MESSAGE="${MESSAGE} * Create a file at ${HOME}/.dotfiles.local for further customizations\n";
  MESSAGE="${MESSAGE} * Configure Git\n";

  if [[ ! $SERVER && ! $SKIP_PACKAGES ]]; then
    [[ $DISTRO ]] \
      && MESSAGE="${MESSAGE} * Install Linux packages (via apt, snap, npm)\n" \
      || MESSAGE="${MESSAGE} * Install macOS packages (via Homebrew, App Store, npm, ruby gem)\n";

    [ ! $SKIP_PACKAGES ] && MESSAGE="${MESSAGE} * Install Sublime Text plugins and configure Sublime Text & Sublime Merge preferences\n";
  fi

  [[ ! $SERVER && ! $DISTRO ]] && MESSAGE="${MESSAGE} * Configure macOS preferences\n";

  echo "${MESSAGE}";
}

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
