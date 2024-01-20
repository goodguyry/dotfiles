#!/bin/bash
#
# Copyright (c) 2024 Ryan Domingue and contributors
# Report bugs at: https://github.com/goodguyry/dotfiles/issues
#
# This is free software with ABSOLUTELY NO WARRANTY.

# Create required directories.
if [[ "function" == "$(type -t mmkd)" ]]; then
  mmkd "${HOME}/.bin";
else
  [[ ! -d "${HOME}/.bin" ]] && mkdir -pv "${HOME}/.bin";
fi

# Add the dotfiles command.
ln -sf "$(realpath dotfiles)" "${HOME}/.bin/dotfiles";

# @todo Synking these may be unnecessary, since we can reference DOTFILES_ROOT?

source "$(realpath lib/setfile)";

if [[ "function" == "$(type -t mmkd)" ]]; then
  mmkd "${HOME}/.dotfiles/lib";
else
  [[ ! -d "${HOME}/.dotfiles/lib" ]] && mkdir -pv "${HOME}/.dotfiles/lib";
fi

# Sync sourced files.
for lib_file in lib/*; do
  [[ -f "${lib_file}" ]] && setfile "${lib_file}" "${HOME}/.dotfiles/lib/$(basename $lib_file)";
done;

if [[ "function" == "$(type -t mmkd)" ]]; then
  mmkd "${HOME}/.dotfiles/bin";
else
  [[ ! -d "${HOME}/.dotfiles/bin" ]] && mkdir -pv "${HOME}/.dotfiles/bin";
fi

# Sync bin files.
for bin_file in bin/*; do
  [[ -f "${bin_file}" ]] && setfile "${bin_file}" "${HOME}/.dotfiles/bin/$(basename $bin_file)";
done;

[ -n "$(type -P dotfiles)" ] && printf "%s: Done. Type 'dotfiles' to continue.\n" "$(basename "${BASH_SOURCE[0]}")";
