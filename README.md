# GoodGuyRy's dotfiles

My dotfiles. Very exciting.

## Installation

#### Using Git

You can clone the repository wherever you want. To do so, ```cd``` into the desired directory and run the following:

```bash
git clone https://github.com/goodguyry/dotfiles.git && cd dotfiles
```

#### Git-free

Download the files into the directory of your chosing, then ```cd``` into the downloaded directory.

```bash
curl -#L https://github.com/goodguyry/dotfiles/tarball/master | tar -xzv --exclude={README.md,LICENSE}
```

#### Setup Options

Once you've navigated to the cloned or downloaded directory, you'll want to run ```./setup```. The following options are available when running the setup file:

<table>
    <tr>
        <td><code>-h</code>, <code>--help</code></td>
        <td>Print this help text</td>
    </tr>
    <tr>
        <td><code>--copy</code></td>
        <td>Copy the files in place instead of linking (gitconfig is always copied)<br>"Copy mode" also suppresses initiallizing a Git repo and pulling updates from Github</td>
    </tr>
    <tr>
        <td><code>--no-packages</code></td>
        <td>Suppress package installations and updates (including casks)</td>
    </tr>
</table>

#### Extras file

During the first run of the setup process, a file called 'extras' will be created at ~/.extras. You'll be prompted to enter your Git credentials and save the file. This is to prevent certain information from being commited to a public repository. The '.extras' file is also a great place to store functions and aliases that you don't want overwritten by future installations.

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

#### gitconfig file

Also, during setup, if a .gitconfig file already exists in your home folder you will be prompted to confirm that you want to overwrite it with the [gitconfig](https://github.com/goodguyry/dotfiles/edit/master/gitconfig) file from this repository. Basically what I'm saying is, pay attention to what you're doing.

## Package managers

- Homebrew

- Homebrew Cask (native applications)

- RVM

The full list of installed software is available [here](http://github.com/goodguyry/dotfiles/blob/master/lib/software_list.md).

## OS X defaults

During the setup process you will be asked if you'd like to apply the OS X defaults. You can also apply them independently, if you'd rather, by running the following command:

```bash
$ osx
```

I encourage you to take the time to read through the [osx](http://github.com/goodguyry/dotfiles/blob/master/bin/osx) file so you know what settings and applications will be impacted before executing the file.

## Acknowledgements

[Necolas Gallagher](http://github.com/necolas/dotfiles)

[Mathias Bynens](http://github.com/mathiasbynens/dotfiles)

[Shawn Pearce](https://github.com/spearce/)

---

Copyright (C) Ryan Domingue

Offered as-is with no guarantee or warranty, offered nor implied.
