#!/bin/bash

declare -a BREW_LIST=(
  # Missing or outdated utils.
  coreutils # /opt/homebrew/opt/coreutils
  moreutils # /opt/homebrew/opt/moreutils
  findutils # /opt/homebrew/opt/findutils
  gnu-sed # /opt/homebrew/opt/gnu-sed
  wget
  vim
  grep
  openssh
  rsync

  # Install newer Bash.
  bash
  bash-completion2

  # Font tools.
  sfnt2woff
  sfnt2woff-zopfli
  woff2

  # Miscellaneous utils.
  gist
  libdvdcss
  mas
  mysql
  packer
  pigz
  svn
  tree
  zlib
);

declare -a CASK_APPS=(
  1Password
  alfred
  appcleaner
  atext
  bartender
  betterzip
  chronosync
  clamxav
  cleanshot
  coconutbattery
  daisydisk
  dropbox
  firefox
  firefox-developer-edition
  google-chrome
  google-chrome-canary
  handbrake
  hazel
  imageoptim
  macmediakeyforwarder
  notion
  onyx
  protonvpn
  rar
  safari-technology-preview
  sequel-pro
  sublime-merge
  sublime-text
  suspicious-package
  tor-browser
  transmit
  vagrant
);

declare -a QL_PLUGINS=(
  qlcolorcode
  qlimagesize
  qlmarkdown
  qlstephen
  quicklook-csv
  webpquicklook
);

declare -a FONTS=(
  font-hack
  font-inconsolata
  font-lato
  font-merriweather-sans
  font-merriweather
  font-nunito
  font-open-sans-condensed
  font-open-sans-hebrew-condensed
  font-open-sans-hebrew
  font-open-sans
  font-pt-mono
  font-pt-sans
  font-pt-serif
  font-roboto
  font-roboto-mono
  font-roboto-slab
  font-source-code-pro
  font-source-sans-pro
  font-source-serif-pro
);

# Merge brew cask arrays.
BREW_CASK_LIST=("${CASK_APPS[@]}" "${QL_PLUGINS[@]}" "${FONTS[@]}");

# Mac App Store apps.
declare -a MAS_APPS_LIST=(
  1091189122 # Bear
  414209656  # Better Rename 9
  682658836  # GarageBand
  1568924476 # Mela
  409203825  # Numbers
  409201541  # Pages
  407963104  # Pixelmator
  1529448980 # Reeder 5
  1006087419 # SnippetsLab
  425424353  # The Unarchiver
  904280696  # Things
  557168941  # Tweetbot
);
