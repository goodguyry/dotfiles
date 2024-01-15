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

## Install

```shell
./setup.sh
```

The `setup` script will add the dotfiles executable to the PATH and run `dotfiles sync`.

The following options are available when running the setup file:

| Option          | Description                                |
|-----------------|--------------------------------------------|
| `--help`        | Print this help text                       |
| `--copy`        | Copy the files in place instead of linking |
| `--no-packages` | Suppress package installations and updates |
| `--no-settings` | Suppress configuring OS settings           |

**Notes:**
- `editorconfig` is always copied.

### The `dotfiles` command

**sync** - Symlinks files to the user `$HOME` directory.

**cli** - Installs CLI packages (non-cask brews).

**install** - Installs GUI applications (cask brews).

**run prefs** - Sets system-wide macOS preference defaults.

**run gitconfig** - Creates the global `.gitconfig` file.

Combine subcommands as such:

```shell
dotfiles sync cli run prefs
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
