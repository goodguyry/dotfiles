#!/bin/bash

# Switch to projects folder; optionally add a project directory
function p() {
  cd ~/Projects/"$@"
}


# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}


# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$@"
}


# Recursively delete files that match a certain pattern
# (by default delete all `.DS_Store` files)
cleanup() {
    local q="${1:-*.DS_Store}"
    find . -type f -name "$q" -ls -delete
}


# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg .[^.]* *
	fi
}


# Create a data URI from a file
function datauri() {
	local mimeType=$(file -b --mime-type "$1")
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8"
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')" | pbcopy
	e_header "The data URI is on the clipboard."
}


# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
	function diff() {
		git diff --no-index --color-words "$@"
	}
fi


# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar"
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
	)

	local cmd=""
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli"
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz"
		else
			cmd="gzip"
		fi
	fi

	echo "Compressing .tar using \`${cmd}\`…"
	"${cmd}" -v "${tmpFile}" || return 1
	[ -f "${tmpFile}" ] && rm "${tmpFile}"
	echo "${tmpFile}.gz created successfully."
}


# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1")
	local gzipsize=$(gzip -c "$1" | wc -c)
	local ratio=$(echo "$gzipsize * 100/ $origsize" | bc -l)
	printf "orig: %d bytes\n" "$origsize"
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}


# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}"
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}


# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
function phpserver() {
	local port="${1:-4000}"
	local ip=$(ipconfig getifaddr en1)
	sleep 1 && open "http://${ip}:${port}/" &
	php -S "${ip}:${port}"
}

# ----------------------------------------------
# Renames all files with an appended number; directories are skipped by defult
#
#		Usage: rn string [-[1-999]] [1-999] [-d] [-a] [.ext]
#
#		string : A string representing the new filename
#
#				-n : (optional) A number, with a preceeding dash, representing the total
#						 number of digit places for the count. Default is 2 (01) unless reset
#						 Example: -5 -> 00001
#
#		     n : (optional) A number representing the starting point for the count
#
#		    -d : (optional) Flag to rename only directories
#
#		    -a : (optional) Flag to rename both files and directories
#
#		  .ext : (optional) File extension (including the .) of the file type to rename
#
#		TODO:
#			Remove item's number on rename
#			Count folders and files seperately
#			Remove strict argument order (name being first)
#			Check if file already exists; increment counter if so
# ----------------------------------------------

function rn() {

	if [ $# -lt 1 ]; then echo "Error: New filename required."; return; fi

	x=1
	renameAllItems=false
	renameDirectoriesOnly=false
	renameSpecificExtension=false

	for arg in "$@"; do

		newName="${1}"

		currentArg="${@:x:1}"

		regFlagAlpha="\-[a|d|0-999]"
		regNum="[0-999]"
		regExt="\.[a-z|0-9]"
		
		if [[ "$currentArg" =~ $regFlagAlpha ]]; then
			flag=$(echo ${arg} | cut -d '-' -f 2)

			if [[ "$flag" == "a" ]]; then
				renameAllItems=true
			elif [[ "$flag" == "d" ]]; then
				renameDirectoriesOnly=true
			else
				zeroPadding=$flag; fi

			if ($renameAllItems) && ($renameDirectoriesOnly); then
				echo "Error: Cannot flag \"All files\" and \"Directories only\" together"
				unset renameAllItems
				unset renameDirectoriesOnly
				return
			fi

		elif [[ "$currentArg" =~ $regExt ]]; then
			fileExtension=$(echo ${arg} | cut -d '.' -f 2)
			renameSpecificExtension=true

		elif [[ "$currentArg" =~ $regNum ]]; then
			startingPoint=$arg
		fi

		x=$((x+1))

	done

	#default startingPoint and zeroPadding if all else fails
	if [[ -z $startingPoint ]]; then startingPoint=1; fi
	if [[ -z $zeroPadding ]]; then zeroPadding=2; fi

	fileCount=$(ls -1 | wc -l)

	# increase the base digits places for large numbers
	if [[ $(( $fileCount + $startingPoint )) -gt 999 ]]; then
		zeroPadding=4
	elif [[ $(( $fileCount + $startingPoint )) -gt 99 ]]; then
		zeroPadding=3
	fi
	
	# function to rename files
	renameFile() {
    fileName="${1%.*}"
    ext="${1##*.}"
		if $renameSpecificExtension ; then
			if [[ "$fileExtension" == "${ext}" ]]; then
				mv "$i" "${newName}_${2}.${ext}"
			else
				return
			fi
		else
			mv "$i" "${newName}_${2}.${ext}"
		fi
	}

	# function to rename folders
	renameDirectory() {
    folderName="$1"
		mv "$i" "${newName}_${2}"	
	}

	for i in *; do
		n=$(printf "%0*d" $zeroPadding $startingPoint)

		if $renameAllItems ; then
			if [[ -d "$i" ]]; then
				renameDirectory $i $n
			elif [[ -f "$i" ]]; then
				renameFile $i $n
			fi
		fi

		if $renameDirectoriesOnly ; then
			if [[ -d "$i" ]]; then
				renameDirectory $i $n
			fi
		fi

		if ! $renameAllItems && ! $renameDirectoriesOnly ; then
			if [[ -f "$i" ]]; then
				renameFile $i $n
			fi
		fi

    startingPoint=$(($startingPoint+1))
	done
		
	# cleanup
	unset zeroPadding
	unset startingPoint
	unset currentArg
	unset renameAllItems
	unset renameDirectoriesOnly
	unset renameSpecificExtension
	unset fileExtension
	unset flag
}


# ----------------------------------------------
# Create a new file and open it in a text editor
#
# 	Uses GUI_EDITOR defined in .bashrc
#     Change to $VISUAL if you'd prefer using vim
#
# 	Usage: nf string1 [string2]
#
#		string1 : A string representing the new file's name. Can be entered
#							with or without the file extension, or as the extension
#							(with the preceeding '.'). When the name or extension are
#							not provided, the default name and extension is used.
#
#							Examples: nf name			 ->  name.[$ext]
#												nf name.ext	 ->	 name.ext
#												nf .ext			 ->	 [$name].ext
#
#		string2 : The new file's extension, separated from the name by a space.
#
#							Example:  nf name ext	 ->	 name.ext
#
#		To change the default filename, change $defaultpre
#		To change the default filetype, change $ext
# ----------------------------------------------

function nf() {
	# declared in this manner so it only has to be
	# updated in one place if I want to change it
	defaultpre=$(date +%y%j%H%M%S)

	# default name & ext
	name=$defaultpre
	ext="md"

	# there are args... 
	if [ $# -gt 0 ]; then

		# entire filename.ext was entered
		if [[ "$1" == .* ]]; then
			ext="$1"
			filename="$name$ext"
    else
  		filename="$1"
		fi
  else
    filename="$name.$ext"
	fi	

	echo "$filename"
  touch $filename
  open -a "$GUI_EDITOR" $filename
  
  unset filename
}


function check_for_homebrew() {
  if ! type_exists 'brew'; then
    e_header "Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    brew doctor
    [[ $? ]] && e_success "Homebrew installed."
  fi
}

function run_brew() {
  # Check for Homebrew
  check_for_homebrew

  e_header "Updating Homebrew..."
  brew update

  e_header "Upgrading installed formulae..."
  brew upgrade

  # Install GNU core utilities (those that come with OS X are outdated)
  brew install coreutils
  
  # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
  brew install findutils
  
  # Install Bash 4
  brew install bash
  
  # Install wget with IRI support
  brew install wget --enable-iri
  
  # Install more recent versions of some OS X tools
  brew tap homebrew/dupes
  brew install homebrew/dupes/grep
  brew tap josegonzalez/homebrew-php
  brew install php55
  
  # Install other useful binaries
  brew install mysql
  brew install node
  brew install rename
  brew install tree
  brew install webkit2png

  brew install phantomjs
  brew install casperjs

  [[ $? ]] && e_success "Homebrew packages installed."  
  e_warning "Don't forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
  
  # Remove outdated versions from the Cellar
  brew cleanup
}

function run_cask() {  
  # Check for Homebrew
  check_for_homebrew

  e_header "Updating Homebrew..."
  brew update

  # Install native apps
  brew tap phinze/homebrew-cask
  brew install brew-cask
  
  [[ $? ]] && e_success "Homebrew Cask installed"

  function installcask() {
    e_header "Installing ${@}..."
  	brew cask install "${@}" 2> /dev/null
  }
  
  installcask dropbox
  installcask firefox
  installcask firefox-aurora
  installcask gitbox
  installcask google-chrome
  installcask google-chrome-canary
  installcask handbrake
  installcask imageoptim
  installcask nv-alt
  installcask one-password
  installcask onyx
  installcask opera
  installcask sequel-pro
  installcask skype
  installcask sublime-text
  installcask things
  installcask tower
  installcask transmission
  installcask transmit
  installcask vlc
  
  [[ $? ]] && e_success "Casks installed"

  # Remove outdated versions from the cellar
  brew cleanup
}

function run_gem() {
  # Check for rvm
  if ! type_exists 'rvm' ; then
    e_header "Installing RVM..."
    \curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3 --autolibs=enabled
    [[ $? ]] && e_success "RVM installed."
  fi
  
  rvm --default use 2.0.0-p353

  e_header "Updating gem..."
  gem update --system

  if ! type_exists 'sass' ; then
    e_header "Installing Sass..."
    gem install sass
  fi

  if ! type_exists 'jekyll' ; then  
    e_header "Installing Github Pages..."
    gem install jekyll
  fi
  
  gem update

  [[ $? ]] && e_success "Gems installed"
}

function run_npm() {
  # Check for npm
  if type_exists 'npm'; then
    e_header "Installing Node.js packages..."

    # List of npm packages
    local packages="bower grunt-cli jshint"

    # Install packages globally and quietly
    npm install $packages --g --quiet

    [[ $? ]] && e_success "Done"
  else
    printf "\n"
    e_error "Error: npm not found."
    e_warning "Run 'brew install node' to install npm."
    printf "Aborting...\n"
    exit
  fi
}

function run_wget() {

  old_pwd=$(pwd)
  cd ~/Downloads

  function getdownload() {
    e_header "Downloading from $@"
    wget -nv --progress=bar "$@"
  }
  
  # Application versions
  coda_v="2.0.9"
  gawker_v="0.8.4"
  grandperspective_v="1_5_1"
  totalfinder_v="1.4.18"

  ChronoSync="http://downloads.econtechnologies.com/CS4_Download.dmg"
  
  ChronoAgent="http://downloads.econtechnologies.com/CA_Mac_Download.dmg"

  Coda2="https://panic.com/coda/d/Coda%20$coda_v.zip"
  
  Gawker="http://downloads.sourceforge.net/sourceforge/gawker/Gawker_$gawker_v.zip"
  
  GrandPerspective="http://sourceforge.net/projects/grandperspectiv/files/grandperspective/1.5.1/GrandPerspective-$grandperspective_v.dmg"
  
  ServicesManager="http://www.macosxautomation.com/services/servicesmanager/pkg/ServicesManagerInstaller.zip"

  Structurer="http://nettuts.s3.amazonaws.com/892_structurer/Structurer.zip"

  TotalFinder="http://downloads.binaryage.com/TotalFinder-$totalfinder_v.dmg"
  
  Webbla="http://www.celmaro.com/files/webbla/Webbla.zip"

  getdownload "$Coda2"
  getdownload "$ChronoSync"
  getdownload "$ChronoAgent"
  getdownload "$Gawker"
  getdownload "$GrandPerspective"
  getdownload "$ServicesManager"
  getdownload "$Structurer"
  getdownload "$TotalFinder"
  getdownload "$Webbla"

  cd "$old_pwd"
  
  e_header "System Preferences panes..."
  
  prefpanes=(Hazel PastebotSync Clusters TVShows)
  
  for a in ${prefpanes[@]} ; do
    echo "${a}"
  done

  [[ $? ]] && e_success "Done"
  open ~/Downloads
}

# ----------------------------------------------
# Add a timestamp to a file or folder
#
# 	Usage: ts [-d] string
#
#			-d (optional) : duplicate item before appending the timestamp
#
#		Change date format in $stamp to alter output
# ----------------------------------------------

function ts() {
	errormsg="Error: A file or folder is required for timestamping"
  stamp=$(date +%y%j%H%M%S)
	if [[ $# -gt 0 && "$1" == "-d" ]]; then
		dup=true
		item="$2"
		# only "-d" was entered
		if [ -z "$item" ]; then echo "$errormsg"; return; fi
	else
		dup=false
		item="$1"
	fi

  # Split the name from the extension
  name="${item%.*}"
  ext="${item##*.}"

	# no args were given 
	if [ $# -lt 1 ]; then echo "$errormsg"; return; fi

	if [ -d "$item" ]; then
		# split off the trailing slash (if it's there)
		name="${item%/*}"
		itemname="${name}_${stamp}"
	else
		itemname="${name}_${stamp}.${ext}"
	fi

	if [ $dup == true ]; then
		# duplicate the item with timestamp
	  cp -r "$item" "$itemname"
	else
		# timestamp the item without duplication
	  mv "$item" "$itemname"
	fi
}
