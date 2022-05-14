#!/bin/bash

declare -a BREW_LIST=(
  # Missing or outdated utils.
  coreutils
  moreutils
  'findutils --with-default-names'
  'gnu-sed --with-default-names'
  'wget --enable-iri'
  'vim --with-override-system-vi'
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
  tree
  zlib
);

declare -a CASK_APPS=(
  1Password
  alfred
  appcleaner
  atext
  betterzip
  brave
  caffeine
  chronosync
  clamxav
  cleanshot
  clipy
  coconutbattery
  daisydisk
  dropbox
  firefox-developer-edition
  firefox
  gitify
  google-chrome-canary
  google-chrome
  handbrake
  macmediakeyforwarder
  imageoptim
  macdown
  muzzle
  notion
  onyx
  opera-beta
  opera-developer
  opera-mobile-emulator
  opera
  pixelsnap
  rar
  safari-technology-preview
  sequel-pro
  sketch
  sublime-merge
  sublime-text
  suspicious-package
  torbrowser
  transmission
  transmit
  vagrant
  vlc
  zeplin
);

declare -a SETTINGS_PANES=(
  hazel
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
  font-roboto-mono
  font-roboto-slab
  font-source-code-pro
  font-source-sans-pro
  font-source-serif-pro
);

# Merge brew cask arrays.
BREW_CASK_LIST=("${CASK_APPS[@]}" "${SETTINGS_PANES[@]}" "${QL_PLUGINS[@]}" "${FONTS[@]}");

# Mac App Store apps.
declare -a MAS_APPS_LIST=(
  1091189122 # Bear
  414209656  # Better Rename 9
  420212497  # Byword
  777886035  # Duo
  409203825  # Numbers
  409201541  # Pages
  407963104  # Pixelmator
  880001334  # Reeder
  803453959  # Slack
  1006087419 # SnippetsLab
  425424353  # The Unarchiver
  904280696  # Things
  557168941  # Tweetbot
);
