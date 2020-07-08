#!/bin/bash

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
