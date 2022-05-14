#!/bin/bash
# Install package managers and packages.

# Source utils.
DOTFILES_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )";
source "${DOTFILES_DIRECTORY}/var/helpers.sh";

##
# Install and/or update Homebrew.
# macOS requires XCode.
##
function install_homebrew() {
  # Before relying on Homebrew, check that packages can be compiled.
  if [ ! "$(type -P gcc)" ]; then
    log_error 'The XCode Command Line Tools must be installed first.';
    xcode-select --install;
  fi;

  # Check for Homebrew.
  if ! $HAS_BREW; then
    log_info 'Installing Homebrew...';
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    brew doctor;

    [[ $? ]] \
      && log_success 'Homebrew is ready.' \
      || log_error 'There was a problem installing Homebrew.';
  fi;

  log_info 'Updating Homebrew...';
  brew update;

  # Mac-only taps.
  if $IS_MACOS; then
    # Tap for font tools; not Mac-only, but no necessary for Linux.
    brew tap bramstein/webfonttools;
    # Tap for alternate versions.
    brew tap homebrew/cask-versions;
    # Tap brew-cask fonts
    brew tap homebrew/cask-fonts;
  fi
}

##
# Install and/or update NVM.
##
function install_nvm() {

  # Check for an existing NVM install location.
  # The `type` check isn't working for `nvm`.
  NVM_LOC=${NVM_DIR:="$HOME/.nvm"};

  # Install NVM.
  if [[ ! -d "${NVM_LOC}" ]]; then
    log_info 'Installing NVM...';
    git clone https://github.com/creationix/nvm.git "${NVM_LOC}";
  fi;

  # Make sure NVM is up-to-date.
  cd "${NVM_LOC}" && git checkout `git describe --abbrev=0 --tags`; cd -;

  # Source nvm.
  source "${NVM_LOC}/nvm.sh";

  printf "\n";
  log_info 'Installing NPM and Node LTS and stable...';
  printf "\n";

  # Install/update NPM.
  npm install -g npm@latest;

  # Install LTS and stable versions of Node.
  nvm install --lts;
  nvm install stable;

  printf "\n";
  [[ $? ]] \
    && log_success 'NVM, NPM & Node are ready.' \
    || log_error 'There was a problem installing NVM, NPM or Node.';
}

##
# Install and configure RVM.
##
function install_rvm() {
  if [ ! "$(type -P rvm)" ]; then
    log_info 'Installing RVM...';
    \curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles --autolibs=enable;
  fi;

  # Enable auto-updating.
  [[ -z "$(grep 'rvm_autoupdate_flag' ~/.rvmrc)" ]] && \
    echo rvm_autoupdate_flag=2 >> "${HOME}/.rvmrc";
  # Quiet RVM complaints about its position in PATH.
  [[ -z "$(grep 'rvm_silence_path_mismatch_check_flag' ~/.rvmrc)" ]] && \
    echo rvm_silence_path_mismatch_check_flag=1 >> "${HOME}/.rvmrc";

  # Source rvm.
  RVM_LOC=${rvm_path:="$HOME/.rvm"};
  source "${RVM_LOC}/scripts/rvm";

  # Update PATH before installing Gems so they end up where intended.
  export PATH=${GEM_HOME}/bin:${GEM_HOME}@global/bin:${MY_RUBY_HOME}/bin:${PATH};

  # Set Ruby version.
  RUBY_VERSION='2.7.1';

  # Install Ruby.
  rvm install "ruby-${RUBY_VERSION}";
  rvm use "${RUBY_VERSION}" --default;

  rvm cleanup all;

  printf "\n";
  [[ $? ]] \
    && log_success "RVM and Ruby are ready." \
    || log_error 'There was a problem installing RVM or Ruby.';
}

##
# Install the Mac App Store CLI and attempt to sign in.
##
function install_mas() {
  ! $HAS_BREW && install_homebrew;

  # Check for `mas`.
  if [[ ! "$(type -P mas)" ]]; then
    brew install mas;
  fi;

  # Capture account.
  ACCOUNT=$(mas account);
  printf '\n';
  log_info "Setting up the MAS CLI tool...";

  # Sign in if not signed in.
  if [[ "${ACCOUNT}" == *"Not signed in"* ]]; then
    # Ask for Apple ID.
    printf '\n';
    log_warning 'You are not signed in to the App Store';
    printf 'Enter your App Store Apple ID ';
    read APPLE_ID;
    printf '\n';

    # Check APPLE_ID value.
    if [[ "$(echo -e ${APPLE_ID} | tr -d '[:space:]')" != '' ]]; then
      if [[ $(mas signin "${APPLE_ID}") && $? -eq 0 ]]; then
        log_header "You are signed in with ${APPLE_ID}";
      else
        log_error "Could not sign in to the App Store.";
        exit;
      fi;
    else
      exit;
    fi;
  else
    log_success "You are already signed in with ${ACCOUNT}";
  fi;

  printf '\n';
}

##
# Install Git.
##
function install_git() {
  log_info 'Installing Git...';

  # Make .bin exists for diff-highlight.
  mkdir -p "${HOME}/.bin";

  if $IS_MACOS; then
    # Install Git from Homebrew for macOS
    ! $HAS_BREW && install_homebrew;
    brew install git;

    # Set up word highlighting.
    [ -s $(brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight ] \
      && ln -sf "$(brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight" "${HOME}/.bin/diff-highlight";
  else
    sudo add-apt-repository ppa:git-core/ppa;
    sudo apt update;
    sudo apt-get install git;
    # Set up word highlighting.
    [ -s /usr/share/doc/git/contrib/diff-highlight ] \
      && ln -sf "/usr/share/doc/git/contrib/diff-highlight" "${HOME}/.bin/diff-highlight";
  fi

  printf "\n";
  [[ $? ]] \
    && log_success 'Git ready.' \
    || log_error 'There was a problem installing Git.';
}

##
# Adds necessary PPAs
##
function set_ppas() {
  # Adds the official Sublime Text/Merge PPA
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  sudo apt-get install apt-transport-https
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

  # Adds the official Dropbox PPA.
  sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
  echo "deb https://linux.dropbox.com/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/nautilus-dropbox.list

  # Adds the official Handbrake PPA
  sudo add-apt-repository ppa:stebbins/handbrake-releases;

  sudo apt-get update;

  printf "\n";
  [[ $? ]] \
    && log_success 'PPAs are ready.' \
    || log_error 'There was a problem adding PPAs.';
}

##
# Install a given brew if it's not already installed.
##
function brew_install() {
  for BREW in "${@}"; do
    PACKAGE_NAME="$(printf "%s\n" "${BREW%% *}")";
    if $(brew list ${PACKAGE_NAME} &> /dev/null); then
      log_header "${PACKAGE_NAME} already installed.";
    else
      brew install ${BREW};
    fi;
  done;

  printf "\n";
  [[ $? ]] \
    && log_success 'Brew packages ready.' \
    || log_error 'There was a problem installing Brew packages.';
}

##
# Install a given brew cask if it's not already installed.
##
function brew_cask_install() {
  for BREW in "${@}"; do
    APP=$(brew info ${BREW} --cask | grep \\.app | sed -e 's/\ (App)//');
    if $(brew list ${BREW}  --cask &> /dev/null) || $(ls /Applications/ | grep -i "${APP}" &> /dev/null); then
      log_header "${BREW} already installed";
    else
      brew install ${BREW} --cask;
    fi;
  done;

  printf "\n";
  [[ $? ]] \
    && log_success 'Brew casks ready.' \
    || log_error 'There was a problem installing Brew casks.';
}

##
# Install global NPM packages.
##
function npm_install() {
  # Install Node packages.
  log_info 'Installing Node packages...';

  # Install global packages for LTS.
  nvm use --lts;
  npm install "${@}" --global --quiet;
  npm list -g --depth 0;

  # Also install stable with the same packages.
  nvm use stable;
  npm install "${@}" --global --quiet;
  npm list -g --depth 0;

  # Be sure to switch back to the LTS version.
  nvm use --lts;

  printf "\n";
  [[ $? ]] \
    && log_success 'NPM packages are ready.' \
    || log_error 'There was a problem installing NPM packages.';
}

##
# Install Ruby, Gems, Vagrant plugins and add Dreambox.
##
function rvm_install() {
  # Install Gems.
  log_info 'Installing Gems...';
  gem install "${@}" --no-document;

  gem cleanup;

  printf "\n";
  [[ $? ]] \
    && log_success 'Ruby Gems are ready.' \
    || log_error 'There was a problem installing Gems.';

  # Install Vagrant plugins
  vagrant plugin install vagrant-ghost;

  # Add Dreambox
  vagrant box add goodguyry/dreambox --provider virtualbox;
}

##
# Install app from the Mac App Store.
##
function mas_install() {
  for APP in "${@}"; do
    mas install "${APP}";
  done;

  printf "\n";
  [[ $? ]] \
    && log_success 'App Store apps ready.' \
    || log_error 'There was a problem installing App Store apps.';
}

##
# Install Debian apps.
##
function apt_install() {
  ITEMS=("$@");
  APT_PACKAGES="$(join_with_space "${ITEMS[@]}")";

  sudo apt-get install -y "${APT_PACKAGES}";

  printf "\n";
  [[ $? ]] \
    && log_success 'apt packages ready.' \
    || log_error 'There was a problem installing apt packages.';
}

##
# Install Snap packages.
##
function snap_install() {
  ITEMS=("$@");
  SNAP_PACKAGES="$(join_with_space "${ITEMS[@]}")";

  snap install "${SNAP_PACKAGES}";

  printf "\n";
  [[ $? ]] \
    && log_success 'Snap apps ready.' \
    || log_error 'There was a problem installing Snap apps.';
}

###
# Download and install deb packages.
###
function install_downloads_debian() {
  # Vagrant
  VAGRANT_VER='2.2.9';
  wget https://releases.hashicorp.com/vagrant/${VAGRANT_VER}/vagrant_${VAGRANT_VER}_x86_64.deb;
  sudo dpkg -i vagrant_${VAGRANT_VER}_x86_64.deb;
  sudo apt -f install;
  # Cleanup.
  rm vagrant_${VAGRANT_VER}_x86_64.deb;

  # Packer
  PACKER_VERSION='1.6.0';
  wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip;
  sudo unzip packer_${VER}_linux_amd64.zip -d /usr/local/bin;
  # Cleanup.
  rm packer_${VER}_linux_amd64.zip;

  # libdvdcss
  LIBDVDCSS_VERSION='1.2.13-0';
  wget http://download.videolan.org/pub/debian/stable/libdvdcss2_${LIBDVDCSS_VERSION}_amd64.deb;
  sudo dpkg -i libdvdcss2_${LIBDVDCSS_VERSION}_amd64.deb;
  # Cleanup.
  rm libdvdcss2_${LIBDVDCSS_VERSION}_amd64.deb;

  # Hack font.
  # @todo https://wiki.manjaro.org/index.php?title=Improve_Font_Rendering
  HACK_FONT_VERSION='3.003';
  wget https://github.com/source-foundry/Hack/releases/download/v${HACK_FONT_VERSION}/Hack-v${HACK_FONT_VERSION}-ttf.zip;
  sudo mkdir -p /usr/share/fonts/truetype/hack/;
  # Unzip font files to system font folder.
  sudo unzip -j Hack-v${HACK_FONT_VERSION}-ttf.zip -d /usr/share/fonts/truetype/hack/;
  # Get full source to retrieve the config file.
  wget https://github.com/source-foundry/Hack/archive/v${HACK_FONT_VERSION}.zip;
  # Unzip configuration file system font configuration folder.
  sudo bash -c "unzip -p v${HACK_FONT_VERSION}.zip Hack-${HACK_FONT_VERSION}/config/fontconfig/45-Hack.conf > /usr/share/fontconfig/conf.avail/45-Hack.conf;"
  # Symlink config file into place.
  sudo ln -fs /usr/share/fontconfig/conf.avail /usr/share/fontconfig/conf.d;
  # Clear and regenerate the font cache and indexes.
  fc-cache -f -v;
  # Confirm the fontz are installed.
  fc-list | grep "Hack"
  # Cleanup.
  rm Hack-v${HACK_FONT_VERSION}-ttf.zip;
  rm v${HACK_FONT_VERSION}.zip;

  printf "\n";
  [[ $? ]] \
    && log_success 'Downloadable deb packages ready.' \
    || log_error 'There was a problem downloading or installing deb packages.';
}
