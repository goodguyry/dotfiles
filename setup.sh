#!/bin/bash
#
# Copyright (c) 2024 Ryan Domingue and contributors
# Report bugs at: https://github.com/goodguyry/dotfiles/issues
#
# This is free software with ABSOLUTELY NO WARRANTY.

source "$(realpath lib/mkdirs)";
source "$(realpath lib/setfile)";

# Create required directories.
mkdirs "${HOME}/.dotfiles/bin";
mkdirs "${HOME}/.dotfiles/lib";
mkdirs "${HOME}/.bin";

# Add the dotfiles command.
ln -sf "$(realpath dotfiles)" "${HOME}/.bin/dotfiles";

# Sync sourced files.
for lib_file in lib/*; do
  [[ -f "${lib_file}" ]] && setfile "${lib_file}" "${HOME}/.dotfiles/lib/$(basename $lib_file)";
done;

# Sync bin files.
for bin_file in bin/*; do
  [[ -f "${bin_file}" ]] && setfile "${bin_file}" "${HOME}/.dotfiles/bin/$(basename $bin_file)";
done;

# dotfiles;
