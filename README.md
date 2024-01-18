# GoodGuyRy's dotfiles

Dev-related [packages](scripts/) and shell configuration. Very exciting.


## Prerequisites

XCode Command Line Tools must be installed.

```shell
xcode-select --install
```

Allow full-disk access for Terminal

```shell
open x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles
```

## Download

### Using Git

Clone the repository wherever convenient by ```cd```ing into the desired directory and running the following:

```shell
git clone https://github.com/goodguyry/dotfiles.git && cd dotfiles
```

### Git-free

Download the files with the following:

```shell
curl -#L https://github.com/goodguyry/dotfiles/tarball/master | tar -xzv --exclude={README.md,LICENSE,PACKAGES.md}
```

Then ```cd``` into the downloaded directory.

## Setup

The `setup` script will install and run `dotfiles`. After initial setup, the `dotfiles` command is available globally.

```shell
./setup.sh
```

## The `dotfiles` command

\** The home directory is always synced, regardless of subcommand \**

**install**

Available options:
* `packages` - Installs Homebrew, CLI packages; NVM, Node, and NPM; RVM, Ruby and Gems
* `apps` - Installs Homebrew casks and App Store apps

```shell
dotfiles install packages
```

**run**

Available options:
* `preferences` - Sets system-wide macOS preferences. **Read through the [macos file](scripts/macos) to know what settings and applications will be impacted before executing the file**.

```shell
dotfiles run preferences
```

## Local overrides

**Filename:** `~/.dotfiles.local`

Used to add extraneous functionality (aliases, functions, prompts, etc.) without committing that information to the repo.

---

Copyright (C) Ryan Domingue

Offered as-is with no guarantee or warranty, offered nor implied.
