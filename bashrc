# Personal aliases and functions.

# Personal environment variables and startup programs should go in ~/.bash_profile.
# System wide environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

[[ -f /etc/profile ]] && . /etc/profile

VISUAL=vim; export VISUAL
EDITOR=vim; export EDITOR
GUI_EDITOR=/Applications/Smultron\ 4.app/Contents/MacOS/Smultron\ 4; export GUI_EDITOR

[ -r "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -r "$HOME/.functions/core" ] && source "$HOME/.functions/core"
