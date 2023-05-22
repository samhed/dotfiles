# .bashrc

## ---------------------
## Environment variables
## ---------------------

export PATH=$PATH:/home/samuel/bin/:/home/samuel/.local/bin/
export SVN_EDITOR=nvim
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

## ---------------------
## Shell settings
## ---------------------

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite
shopt -s histappend

# Increase size of history file
HISTSIZE=1000
HISTFILESIZE=2000

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
function __setprompt() {
	#local RED="0;31m"
	#local WHITE="0;37m"
	local RESET=$(tput sgr0)
	local BOLD=$(tput bold)
	local BLACK=$(tput setaf 0)
	local RED=$(tput setaf 1)
	local GREEN=$(tput setaf 2)
	local YELLOW=$(tput setaf 3)
	local BLUE=$(tput setaf 4)
	local MAGENTA=$(tput setaf 5)
	local CYAN=$(tput setaf 6)
	local WHITE=$(tput setaf 7)

	# Set the color for the bash prompt to red if root, else white
	#if [ "$(id -u)" == "0" ]; then
	#	color="$RED"
	#else
	#	color="$WHITE"
	#fi
	#
	#export PS1='\e[${color}[\u@\h \W]\$ \e[m'
	export PS1="\n[\[$CYAN\]\$(date +%H:%M)\[$RESET\]]\
	\[$GREEN\]\u@\h\[$RESET\]: \[$BOLD\]\w\[$RESET\]\n\$ "
}
if [[ $- == *i* ]]; then
	__setprompt
fi

# zsh style TAB completion (TAB: next, Shift+TAB: prev)
#bind 'set show-all-if-ambiguous on'
#bind 'TAB:menu-complete'
#bind '"\e[Z":menu-complete-backwards'

## ---------------------
## Utility functions
## ---------------------

# Function to set the title of the terminal
function set-title() {
	if [[ -z "$ORIG" ]]; then
		ORIG=$PS1
	fi
	TITLE="\[\e]2;$@\a\]"
	PS1=${ORIG}${TITLE}
}

svn()
{
	case "$1" in
	grep)
		local flags expr paths

		shift

		flags=""
		expr=""
		paths=""
		while [ $# -gt 0 ]; do
			case "$1" in
			"-"*)
				flags="$flags $1"
				;;
			*)
				if [ -z "$expr" ]; then
					expr="$1"
				else
					paths="$paths $1"
				fi
				;;
			esac
			shift
		done
		if [ -z "$paths" ]; then
			paths="."
		fi
		(for path in ${paths}; do
			/usr/bin/svn ls -R ${path} | grep -v /$ | sed "s@^@${path}/@"
		 done) | xargs --delimiter "\n" grep --no-messages --color=always ${flags} "${expr}" | less -FR
		return $?
		;;
	cdiff)
		shift

		if [[ $rev != r* ]]; then
			rev="r$1"
		fi
		shift

		svn diff -c "$rev" "$@" svn://svn
		return $?
		;;
	esac

	if ! [ -t 1 ]; then
		/usr/bin/svn "$@"
		return $?
	fi

	case "$1" in
	diff)
		/usr/bin/svn "$@" | colordiff | perl /home/samuel/bin/diff-highlight | less -FR
		;;
	log|blame)
		/usr/bin/svn "$@" | less -F
		;;
	*)
		/usr/bin/svn "$@"
		;;
	esac

	return $?
}

git()
{
	case "$1" in
	rshow)
		local svnrev githash

		shift

		if [ $# -ne 1 ]; then
			echo "Please specify a revision number"
			return 1
		fi

		svnrev="$1"

		if [[ $svnrev != r* ]]; then
			svnrev="r$svnrev"
		fi

		githash=`git svn find-rev "$svnrev"`
		shift

		/usr/bin/git show "$githash" "$@"
		;;
	*)
		/usr/bin/git "$@"
		;;
	esac

	return $?
}

## ---------------------
## Aliases
## ---------------------

alias vim="nvim"

alias vecka='date +%V'
alias diskspace="du -S | sort -n -r |more"

alias sudo='sudo '

alias untar='tar -xvf'

alias cdc='cd ~/devel/ctc-git'

# git diff for any diff
alias diff="git diff --no-index"

## ---------------------
## Completion
## ---------------------

source /home/samuel/devel/dotfiles/fzf-tab-completion/bash/fzf-bash-completion.sh
bind -x '"\t": fzf_bash_completion'
