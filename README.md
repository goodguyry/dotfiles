# GoodGuyRy's dotfiles

Dev-related packages and shell configuration. Very exciting.


## Local configuration

These dotfiles and packages are configured to my liking, which may mean packages, applications and settings _you_ prefer were left out. As a means of allowing customization, without altering the repo, several additional files may be added to extend or override these dotfiles.

| Filename              | Purpose                                         |
|-----------------------|-------------------------------------------------|
| `~/.gitconfig.local`  | Your Git author information & personalization   |
| `~/.goodguyrc`        | Additional customizations                       |
| `~/.vim/settings.vim` | Vim configuration/customization                 |

Because these files aren't (and shouldn't be) included in the repo, it may be benefitial to save them in a Gist, symlink them from Dropbox or save them by some other means in case you find yourself needing to reinstall from scratch.


### Git

**Filename:** `~/.gitconfig.local`

`.gitconfig.local` is used to add your Git author information to `gitconfig` without committing that information to the repo. During `init`, you will be prompted for your Git author information, or to confirm your author information if `.gitconfig.local` already exists.

You can [add aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases) by placing them in `.gitconfig.local` as well. This will keep your settings from being overwritten by future updates.

```shell
# git config --global alias.[alias] [command]
git config --global alias.co checkout
```


### .goodguyrc

There are several environment variables you can set in `~/.goodguyrc` to alter the behavior and package listing of these dotfiles.


#### Extending installed package lists

`DOTFILES_BREW_LIST`  
`DOTFILES_CASK_LIST`  
`DOTFILES_NPM_LIST`  
`DOTFILES_GEM_LIST`  

*Here is the [master list of installed packages](https://github.com/goodguyry/dotfiles/blob/master/PACKAGES.md).*

You can add to the list of installed packages by setting the related variable to a space-separated list in `~/.goodguyrc`.

```shell
  # List the packages as a space-separated string
  export DOTFILES_BREW_LIST="casperjs rename webkit2png";
  export DOTFILES_CASK_LIST="thunderbird vmware-fusion xscope";
  export DOTFILES_NPM_LIST="coffee-script less yo";
  export DOTFILES_GEM_LIST="capistrano mustache";
```

If you create this file and add these variables before running init, these packages will be installed during `init`. If not, you can install them later; for example, to install brews from your list, you can run

```shell
brew install $DOTFILES_BREW_LIST
```


#### Setting the projects directory

`DOTFILES_PROJECTS_DIR`  
- The directory in which you keep your projects.  
- Default: `~/Projects`

This directory will be created for you during `init` (in the event it doesn't already exist); it is also where autocomplete (`shell/config`) will look for project names. You can change it to whatever suits you by setting a new value in `~/.goodguyrc`.

```shell
  # Customize the projects directory
  export DOTFILES_PROJECTS_DIR="$HOME/Sites";
```


## Installation


#### Using Git

Clone the repository wherever convenient by ```cd```ing into the desired directory and running the following:

```shell
git clone https://github.com/goodguyry/dotfiles.git && cd dotfiles
```


#### Git-free

Download the files with the following:

```shell
curl -#L https://github.com/goodguyry/dotfiles/tarball/master | tar -xzv --exclude={README.md,LICENSE,PACKAGES.md}
```

Then ```cd``` into the downloaded directory.


### Install

**IT IS IMPERATIVE THAT THE INSTALL SCRIPT ONLY BE RUN FROM WITHIN THE SCRIPT'S DIRECTORY.**

Run `./init` from inside the dotfiles directory.


#### Setup Options

The following options are available when running the init file:

<table>
  <tr>
    <td width="25%"><code>-h</code>, <code>--help</code></td>
    <td>Print this help text</td>
  </tr>
  <tr>
    <td width="25%"><code>--copy</code></td>
    <td>Copy the files instead of symlinking</td>
  </tr>
  <tr>
    <td width="25%"><code>--no-packages</code></td>
    <td>Suppress package installations and updates</td>
  </tr>
  <tr>
    <td width="25%"><code>--server</code></td>
    <td>Skip Projects folder and OS X-related packages</td>
  </tr>
</table>

Notes:

1. `gitconfig` is always copied, regardless of the option passed.
2. `--copy` and `--server` also suppress initializing a Git repo and pulling updates from Github


### Additional customizations

In addition to setting the project directory and extending the lists of installed packages, `~/.goodguyrc` is used for any other customizations.


#### Custom $PATH, exports, aliases and functions

This file is sourced after all others, so declarations here will override anything of the same name.

```shell
  # Extend your $PATH
  PATH="$PATH:/additional/bin";
  export PATH;

  # Add an alias
  alias c="clear"

  # Add a function
  function wat() {
    sudo shutdown -r +1 "Rebooting soon...";
  }
```


#### Customize the shell prompt

There are many prompt generators and editors out there. I've never used one, but they seem okay. [Here is a good guide to the escape sequences](http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html).

The included shell looks like this (the background color is from [GoodGuyRy.terminal](https://github.com/goodguyry/dotfiles/blob/master/lib/GoodGuyRy.terminal)):

![Command prompt](http://i.imgur.com/G1ovhl2.png)

And here's the code:

```shell
  # Main prompt
  # HH:MM:SS - User@Host
  PS1="\n\[$GRAY\]\T - \u@\h";
  # New line; Current directory
  PS1+="\n\[$BLUE\]\$(PWD)";
  # If inside a Git repo, print "on <branch>" at the end of the line
  PS1+="\[$GRAY\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$ORANGE\]\$(parse_git_branch)";
  # Prompt on a new line
  PS1+="\n\[$BLUE\]\$ \[$LTGRAY\]";

  # Continuation prompt
  PS2="\[$BLUE\]: \[$GRAY\]";
```

Included colors: `BLACK`, `RED`, `GREEN`, `YELLOW`, `BLUE`, `PURPLE`, `MAGENTA`, `CYAN`, `WHITE`, `GRAY`, `LTGRAY`, `VIOLET`, `ORANGE`. To add more colors, or to change the prompt, declare them in your `~/.goodguyrc` file.

```shell
PINK="\e[38;5;219m";
```

[Here's a great guide to prompt colors](http://misc.flogisoft.com/bash/tip_colors_and_formatting).


### Vim settings

**Filename**: `settings.vim`

The included Vim configuration settings are very basic. If you're a Vim user who needs additional configuration or customization, you can include such settings in a file at `~/.vim/settings.vim`. If you know of anything cool to add, please do.


## Switching Shells

Bash 4 and Zsh 5 are installed via Homebrew to replace the old versions shipped with OS X. To change your shell to either of the new shells, run the appropriate commands below and then restart your shell (close the current widow and open a new one).

**Bash**:

```shell
# Add /usr/local/bin/bash to /etc/shells
echo /usr/local/bin/bash|sudo tee -a /etc/shells && chsh -s /usr/local/bin/bash
```

**Zsh** (_These dotfiles have not been tested with Zsh_):

```shell
# Add /usr/local/bin/zsh to /etc/shells
echo /usr/local/bin/zsh|sudo tee -a /etc/shells && chsh -s /usr/local/bin/zsh
```


## OS X defaults

The setup process will prompt to apply the OS X defaults. They can also be applied independently from the dotfiles directory:

```
./bin/osx
```

Take time to read through the [osx file](http://github.com/goodguyry/dotfiles/blob/master/bin/osx) to know what settings and applications will be impacted before executing the file.


## Known Issues

1. These dotfiles have not been tested with Zsh
2. A couple of the included functions use `osascript` to run an AppleScript snippet. If you get an error when running `cdf` or `p`, installing the file from the link below should resolve the error messages.  
http://helpx.adobe.com/photoshop/kb/unit-type-conversion-error-applescript.html


## Acknowledgements

[Necolas Gallagher](http://github.com/necolas/dotfiles)

[Mathias Bynens](http://github.com/mathiasbynens/dotfiles)

[Mat Marquis](https://github.com/wilto/)

---

Copyright (C) Ryan Domingue

Offered as-is with no guarantee or warranty, offered nor implied.
