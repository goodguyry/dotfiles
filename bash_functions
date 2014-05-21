#!/bin/bash

# Concatenate function files into bash_functions
# For use in updating and testing dotfiles
# Should only be run from the dotfiles root
function catfunctions() {
  CAT_LIST="";
  
  for i in functions/* ; do 
    if [[ -r "$i" && "$i" != "functions/core" ]] ; then
      CAT_LIST+="$i "
    fi
  done
  
  cat functions/core $CAT_LIST > bash_functions
}


# Switch to projects folder; optionally add a project directory
function p() {
  cd ~/Projects/"$@"
}


# Create a temporary plain text file
# Usage: `temp ext` (creates file: temp.[date string].ext)
# If no extension is passed, defaults to "md"
function temp() {
  prefix="temp"
  suffix=$(date +%Y%m%d%H%M%S)
  ext="${1:-md}"
  filename="$prefix.$suffix.$ext"
  touch $filename
}


# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}


# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$@"
}


# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
  function diff() {
    git diff --no-index --color-words "$@"
}
fi


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
#!/bin/bash

# Concatenate function files into bash_functions
# For use in updating and testing dotfiles
# Should only be run from the dotfiles root
function catfunctions() {
  CAT_LIST="";
  
  for i in functions/* ; do 
    if [[ -r "$i" && "$i" != "functions/core" ]] ; then
      CAT_LIST+="$i "
    fi
  done
  
  cat functions/core $CAT_LIST > bash_functions
}


# Switch to projects folder; optionally add a project directory
function p() {
  cd ~/Projects/"$@"
}


# Create a temporary plain text file
# Usage: `temp ext` (creates file: temp.[date string].ext)
# If no extension is passed, defaults to "md"
function temp() {
  prefix="temp"
  suffix=$(date +%Y%m%d%H%M%S)
  ext="${1:-md}"
  filename="$prefix.$suffix.$ext"
  touch $filename
}


# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}


# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$@"
}


# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
  function diff() {
    git diff --no-index --color-words "$@"
}
fi


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
