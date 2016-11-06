# Before relying on Homebrew, check that packages can be compiled
if [ ! "$(type -P gcc)" ]; then
  log_header 'The XCode Command Line Tools must be installed first.';
  xcode-select --install;
fi;

# Check for Homebrew
if [ ! "$(type -P brew)" ]; then
  log_header 'Installing Homebrew...';
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
  brew doctor;
  [[ $? ]] && log_success 'Homebrew installed.';
fi;

log_header 'Updating Homebrew...';
brew update;

log_header 'Upgrading installed formulae...';
brew upgrade;
