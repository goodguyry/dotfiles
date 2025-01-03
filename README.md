# GoodGuyRy's dotfiles

Dev-related packages and shell configuration. Very exciting.


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

The `setup` script will install `dotfiles`. After initial setup, the `dotfiles` command is available globally.

```shell
./setup
```

## The `dotfiles` command

Print usage information.

```shell
dotfiles --help
```

Print the dotfiles directory path.

```shell
dotfiles --prefix
```

### Subcommands

#### sync

Sync shell configuration files to the home directory.

```shell
dotfiles sync home
```

#### install

Install Homebrew, CLI packages; NVM, Node, and NPM; RVM, Ruby and Gems

```shell
dotfiles install packages
```

Install Homebrew casks and App Store apps

```shell
dotfiles install apps
```

#### run

Set system-wide macOS preferences. **Read through the [preferences script](bin/dotfiles-run-preferences) to know what settings and applications will be impacted before executing the file**.

```shell
dotfiles run preferences
```

Set up the global .gitconfig file. This is automatically run during `dotfiles install packages`, but can be run independently.

```shell
dotfiles run gitconfig
```

## Local overrides

**Filename:** `~/.dotfiles.local`

Used to add extraneous functionality (aliases, functions, prompts, etc.) without committing that information to the repo.

---

Copyright (C) Ryan Domingue

Offered as-is with no guarantee or warranty, offered nor implied.
