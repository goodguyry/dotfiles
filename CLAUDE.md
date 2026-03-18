# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal macOS dotfiles management system. The main `dotfiles` script is a CLI dispatcher that routes subcommands to scripts in `bin/`. Initial setup is done via `./setup`.

## Commands

```bash
./setup                       # Initial install: symlinks dotfiles CLI, creates ~/.dotfiles/, sets PATH
dotfiles --help               # Show available subcommands
dotfiles sync home            # Symlink config files from home/ to ~/
dotfiles install packages     # Install Homebrew packages, NVM, Ruby gems
dotfiles install apps         # Install Homebrew casks and Mac App Store apps
dotfiles run gitconfig        # Configure global git settings interactively
dotfiles run preferences      # Apply macOS system preferences
dotfiles set path             # Configure /etc/paths.d/ and /etc/manpaths.d/ (requires sudo)
```

There is no test suite or linter configuration.

## Architecture

**Entry point:** `dotfiles` — parses args and dispatches to `bin/dotfiles-<subcommand>` scripts. Also sources lib functions.

**Subcommand scripts (`bin/`):** Each subcommand is a standalone Bash script. The script name maps to the CLI command: `dotfiles set path` → `bin/dotfiles-set-path`.

**Library functions (`lib/`):** Sourced by scripts as needed. Key utilities:
- `lib/status` — `status()` prints colored output (`--info`, `--success`, `--error`, `--warning`)
- `lib/setfile` — `setfile()` creates symlinks via `ln -fs`
- `lib/add_path` — `add_path()` / `add_manpath()` write path files to the dotfiles prefix dirs
- `lib/mmkd` — `mmkd()` creates a directory only if it doesn't exist
- `lib/setprefix` — stores the dotfiles install path in `~/.dotfiles/.prefix`
- `lib/dohomebrew` — installs or updates Homebrew

**Prefix system:** `~/.dotfiles/.prefix` stores the path to the dotfiles directory. Scripts read this to know where to find subcommands and lib files. Set during `./setup`.

**Home config (`home/`):** Shell config files and scripts that get symlinked into `~/` by `dotfiles sync home`. Completions go to `~/.completions.d/`, functions to `~/.functions/`.

**Package lists (`etc/packages.macos.sh`):** Bash arrays (`BREW_LIST`, `CASK_APPS`, `QL_PLUGINS`, `FONTS`, `MAS_APPS_LIST`) consumed by `bin/dotfiles-install-packages` and `bin/dotfiles-install-apps`.

**Shell reload pattern:** Scripts that modify PATH or config end with `exec env -i HOME=$HOME $SHELL -l` to reload with a clean environment.

**Local overrides:** `~/.dotfiles.local` is sourced for machine-specific config not tracked in this repo.

## Setup Flow

```
./setup
  └── creates ~/.bin/, ~/.dotfiles/
  └── copies bin/* and lib/* to ~/.dotfiles/
  └── symlinks dotfiles CLI → ~/.bin/dotfiles
  └── runs: dotfiles set path
        └── writes to /etc/paths.d/ and /etc/manpaths.d/
        └── reloads shell
```

After setup, run `dotfiles sync home` then `dotfiles install packages`.
