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

## Setup

The `setup` script will install and run `dotfiles`. After initial setup, the `dotfiles` command is available globally.

```shell
./setup.sh
```

## The `dotfiles` command

\** The home directory is always synced, regardless of subcommand \**

**packages** - Installs CLI packages (non-cask brews).

**apps** - Installs GUI applications (cask brews).

**run prefs** - Sets system-wide macOS preference defaults.

Combine subcommands as such, with the `run` subcommand placed last:

```shell
dotfiles packages run prefs
```

### Local configuration

**Filename:** `~/.dotfiles.local`

Used to add extraneous functionality (aliases, functions, prompts, etc.) without committing that information to the repo.

### macOS defaults

The setup process will prompt to apply the masOS defaults. They can also be applied independently from the dotfiles directory:

```shell
./scripts/macos
```

Many of these configuration options are likely outdated. Take time to read through the [macos file](scripts/macos) to know what settings and applications will be impacted before executing the file.

## Acknowledgements

[Necolas Gallagher](http://github.com/necolas/dotfiles)

[Mathias Bynens](http://github.com/mathiasbynens/dotfiles)

---

Copyright (C) Ryan Domingue

Offered as-is with no guarantee or warranty, offered nor implied.
