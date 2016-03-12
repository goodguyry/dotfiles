# GoodGuyRy's dotfiles

Dev-related packages and shell configuration. Very exciting.

*Here is the [master list of installed packages](https://github.com/goodguyry/dotfiles/blob/master/PACKAGES.md).*



## Download


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


## Install

```shell
./init
```


#### Setup Options

The following options are available when running the init file:

<table>
  <tr>
    <td width="25%"><code>-h</code>, <code>--help</code></td>
    <td>Print this help text</td>
  </tr>
  <tr>
    <td width="25%"><code>-c</code>, <code>--copy</code></td>
    <td>Copy the files instead of symlinking</td>
  </tr>
  <tr>
    <td width="25%"><code>-n</code>, <code>--no-packages</code></td>
    <td>Suppress package installations and updates</td>
  </tr>
  <tr>
    <td width="25%"><code>-s</code>, <code>--server</code></td>
    <td>Skip Projects folder and OS X-related packages</td>
  </tr>
</table>

Notes:

1. `gitconfig` is always copied, regardless of the option passed.
2. `--copy` and `--server` also suppress initializing a Git repo and pulling updates from Github


## Local configuration

**Filename:** `~/.dotfiles.local`

`.dotfiles.local` is used to add Git author information and any other extraneous functionality (aliases, functions, prompts, etc.) without committing that information to the repo.

`init` will prompt for Git author information and create `.dotfiles.local` if it doesn't already exist.


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


## Acknowledgements

[Necolas Gallagher](http://github.com/necolas/dotfiles)

[Mathias Bynens](http://github.com/mathiasbynens/dotfiles)

[Mat Marquis](https://github.com/wilto/)

---

Copyright (C) Ryan Domingue

Offered as-is with no guarantee or warranty, offered nor implied.
