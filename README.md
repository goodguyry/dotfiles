# GoodGuyRy's dotfiles

Dev-related packages and shell configuration. Very exciting.

*Here is the [master list of installed packages](https://github.com/goodguyry/dotfiles/blob/master/PACKAGES.md).*



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


## Local configuration

**Filename:** `~/.dotfiles.local`

`.dotfiles.local` is used to add Git author information, as well as any other extraneous functionality (aliases, functions, prompts, etc.) without committing that information to the repo.

`init`, will prompt for Git author information and create `.dotfiles.local` if it doesn't already exist.

Add [Git aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases) by placing them in `.dotfiles.local` in the following format to ensure settings are not overwritten by future updates.

```shell
# git config --global alias.[alias] [command]
git config --global alias.co checkout
```


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
