#!/bin/bash

##
# Install macOS packages
##

source bin/brews;
source bin/appstore;
source bin/nvm;
source bin/rvm; # @todo Still needed?

# Set up Sublime Text & Sublime Merge
source bin/sublime;

# Change to bash 4 installed by bin/brews.
if [[ "$(grep "/usr/local/bin/bash" /etc/shells)" ]]; then
  log_header "'/usr/local/bin/bash' already in /etc/shells";
else
  echo /usr/local/bin/bash|sudo tee -a /etc/shells && chsh -s /usr/local/bin/bash;
  log_success 'Shell switched to latest Bash';
fi;
