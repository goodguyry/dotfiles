#!/bin/bash

declare -a APT_UTILS=(
  bash-completion
  curl
  ffmpeg
  gist
  moreutils
  openssh-client
  pigz
  python3-gpg
  sfnt2woff-zopfli
  tree
  trimage
  unzip
  vim
  wget
  woff-tools
  woff2
);

declare -a APT_GUI_APPS=(
  dropbox
  gpaste
  handbrake-gtk
  sublime-merge
  sublime-text
  virtualbox
);

# Merge apt arrays.
APT_LIST=("${APT_UTILS[@]}" "${APT_GUI_APPS[@]}");

declare -a SNAP_LIST=(
  vlc
);
