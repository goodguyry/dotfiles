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
  bash-completion@2

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
  # Bear
  1091189122
  # Better Rename 9
  414209656
  # GarageBand
  682658836
  # Mela
  1568924476
  # Numbers
  409203825
  # Pages
  409201541
  # Pixelmator
  407963104
  # Reeder 5
  1529448980
  # SnippetsLab
  1006087419
  # The Unarchiver
  425424353
  # Things
  904280696
  # Tweetbot 3
  1384080005
);
