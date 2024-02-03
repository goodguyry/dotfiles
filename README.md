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
./setup.sh
```

## The `dotfiles` command

By default, running `dotfiles` symlinks shell configuration files files to the home directory.

| Flag        | Description                                       |
|-------------|---------------------------------------------------|
| `--prefix`  | Prints the dotfiles dorectory path.               |
| `--no-sync` | Suppreses symlinking files to the home directory. |

### Subcommands

**install**

Available options:
* `packages` - Installs Homebrew, CLI packages; NVM, Node, and NPM; RVM, Ruby and Gems
* `apps` - Installs Homebrew casks and App Store apps

```shell
# E.g.,
dotfiles install packages
```

**run**

Available options:
* `preferences` - Sets system-wide macOS preferences. **Read through the [macos file](scripts/macos) to know what settings and applications will be impacted before executing the file**.
* `gitconfig` - Sets up the global .gitconfig file. This is automatically run during git setup, but can be run independently.

```shell
# E.g.,
dotfiles run preferences
```

## Local overrides

**Filename:** `~/.dotfiles.local`

Used to add extraneous functionality (aliases, functions, prompts, etc.) without committing that information to the repo.

---

Copyright (C) Ryan Domingue

Offered as-is with no guarantee or warranty, offered nor implied.
