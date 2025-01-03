#!/bin/bash
# shellcheck disable=SC2034

declare -a BREW_LIST=(
  # Missing or outdated utils.
  coreutils
  findutils
  git
  git-open
  gnu-sed
  grep
  moreutils
  openssh
  rsync
  ruby
  sass/sass/sass
  shellcheck
  vim
  wget

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
  pigz
  svn
  tree
  zlib
);

declare -a CASK_APPS=(
  1password
  alfred
  appcleaner
  betterzip
  chronosync
  clamxav
  cleanshot
  coconutbattery
  daisydisk
  espanso
  firefox
  firefox-developer-edition
  gitify
  google-chrome
  google-chrome-canary
  handbrake
  hazel
  imageoptim
  macmediakeyforwarder
  notion
  onyx
  parallels
  pixelsnap
  protonvpn
  rar
  safari-technology-preview
  sip
  sublime-merge
  sublime-text
  suspicious-package
  tor-browser
  transmit
  vagrant
  vlc
  zoom
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
  # 1Password for Safari
  1569813296
  # Bear
  1091189122
  # Craft
  1487937127
  # Better Rename 9
  414209656
  # Duo
  777886035
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
  # Reeder
  1529448980
  # Reeder Classic
  1529448980
  # Sequel Ace
  1518036000
  # SnippetsLab
  1006087419
  # The Unarchiver
  425424353
  # Things
  904280696
  # Xcode
  497799835
);
