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

# Source setup files.
source "./home/functions/mmkd";
source "./lib/status";

mmkd "${HOME}/.bin" && status "Created '${HOME}/.bin'";
ln -sf "$(realpath dotfiles)" "${HOME}/.bin/dotfiles";

[ -n "$(type -P dotfiles)" ] && status --success "Done. Type 'dotfiles' to continue.";
