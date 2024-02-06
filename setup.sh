#!/bin/bash
# shellcheck disable=SC1091
#
# Copyright (c) 2024 Ryan Domingue and contributors
# Report bugs at: https://github.com/goodguyry/dotfiles/issues
# This is free software with ABSOLUTELY NO WARRANTY.

# ------------------------------------------------------------------------------
# usage: ./setup.sh
#
# Adds the dotfiles command.
# ------------------------------------------------------------------------------

DOTFILES_ROOT=$(dirname "$(realpath "${BASH_SOURCE[0]}")");

# Source setup files.
source "${DOTFILES_ROOT}/lib/mmkd";
source "${DOTFILES_ROOT}/lib/status";
source "${DOTFILES_ROOT}/lib/setfile";

mmkd "${HOME}/.bin" && status "Created '${HOME}/.bin'";
ln -sf "${DOTFILES_ROOT}/dotfiles" "${HOME}/.bin/dotfiles";

mmkd "${HOME}/.dotfiles";
if [[ $? ]]; then
  for subcommand_file in "${DOTFILES_ROOT}"/bin/*; do
    [[ -f "${subcommand_file}" ]] && setfile "${subcommand_file}" "${HOME}/.dotfiles/$(basename "${subcommand_file}")";
  done;
else
  status --error "Could not create ${HOME}/.dotfiles";
fi

[ -n "$(type -P dotfiles)" ] && status --success "Done. Type 'dotfiles' to continue.";
