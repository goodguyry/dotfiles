#!/bin/bash

##
# Check for, install and/or update Homebrew.
##

# Before relying on Homebrew, check that packages can be compiled.
if [ ! "$(type -P gcc)" ]; then
  log_header 'The XCode Command Line Tools must be installed first.';
  xcode-select --install;
fi;

# Check for Homebrew.
if ! $HAS_BREW; then
  log_header 'Installing Homebrew...';
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew doctor;
  [[ $? ]] && log_success 'Homebrew installed.';
fi;

log_header 'Updating Homebrew...';
brew update;
