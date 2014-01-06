# Personal aliases and functions.

# Personal environment variables and startup programs should go in ~/.bash_profile.
# System wide environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

[[ -f /etc/profile ]] && . /etc/profile

VISUAL=vim; export VISUAL
EDITOR=vim; export EDITOR
GUI_EDITOR=/Applications/Smultron\ 4.app/Contents/MacOS/Smultron\ 4; export GUI_EDITOR


# Switch to projects folder; optionally add a project directory
function p() {
  cd ~/Projects/"$@"
}


# Create a temporary plain text file
function temp() {
  prefix="temp"
  suffix=$(date +%Y%m%d%H%M%S)
  filename="$prefix.$suffix.txt"
  touch $filename
}

[ -r "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -r "$HOME/.bash_functions" ] && source "$HOME/.bash_functions"
