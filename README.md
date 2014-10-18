# GoodGuyRy's dotfiles

My dotfiles. Very exciting.

## Installation

#### Using Git

Clone the repository wherever convenient by ```cd```ing into the desired directory and running the following:

```bash
git clone https://github.com/goodguyry/dotfiles.git && cd dotfiles
```

#### Git-free

Download the files, ```cd``` into the downloaded directory and run the following:

```bash
curl -#L https://github.com/goodguyry/dotfiles/tarball/master | tar -xzv --exclude={README.md,LICENSE}
```

#### Setup Options

Run ```./init``` from inside the cloned or downloaded directory. The following options are available when running the init file:

<table>
    <tr>
        <td width="20%"><code>-h</code>, <code>--help</code></td>
        <td>Print this help text</td>
    </tr>
    <tr>
        <td width="20%"><code>--copy</code></td>
        <td>Copy the files in place instead of linking<br>"Copy mode" also suppresses initializing a Git repo and pulling updates from Github</td>
    </tr>
    <tr>
        <td width="20%"><code>--no-packages</code></td>
        <td>Suppress package installations and updates (including casks). These can be run independently if need be.</td>
    </tr>
</table>

 Note: gitconfig and git_completion are always copied, regardless of the options passed.

#### Extras file

The first run of the setup process will prompt for Git author name and email, and a file called 'extras' will be created at ~/.extras. This is to prevent certain information from being committed to a public repository. The '.extras' file is also a great place to store functions and aliases that shouldn't be overwritten by future installations.

On subsequent runs of `init`, the 'extras' file will be presented for confirmation of the information it contains.

```bash
# Git credentials

# Add your name below
GIT_AUTHOR_NAME="Ryan Domingue"

# Add your email below
GIT_AUTHOR_EMAIL="ryan@aol.com"

GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

# Set the credentials (modifies ~/.gitconfig)
git config --global user.name "$GIT_AUTHOR_NAME"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

## Package managers

- Homebrew
- Homebrew Cask (native applications)
- RVM
- NPM

The [full list of installed software](http://github.com/goodguyry/dotfiles/blob/master/local/software_list.md) is available. In addition to package managers, some software is downloaded via ```wget``` to the 'Downloads' folder.

The package installation can run it independently from the dotfiles directory:

```
source local/packages && run_packages
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
