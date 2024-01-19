####################
# Theme
####################

set -g theme_display_git_default_branch yes
set -g theme_display_k8s_context no
set -g theme_display_vagrant no
set -g theme_display_virtualenv no
set -g theme_display_nix no
set -g theme_display_ruby no
set -g theme_display_node no
set -g theme_date_format "+%H:%M:%S"
set -g theme_date_timezone Europe/Stockholm
set -g theme_powerline_fonts no
set -g theme_nerd_fonts yes
set -g default_user no

####################
# Utility functions
####################

function git
    switch $argv[1]
        case "rshow"
            if test (count $argv) -lt 2
                echo "Usage: git rshow <revision>"
                return 1
            end
            set -l svnrev $argv[2]

            if not string match 'r*' $svnrev
                set svnrev (string join '' 'r' $svnrev)
            end

            set -l githash (command /usr/bin/git svn find-rev $svnrev)

            command /usr/bin/git show $githash $argv[3..-1]
        case "*"
            command /usr/bin/git $argv[1..-1]
    end
    return $status
end

####################
# Aliases
####################

alias vim="nvim"

alias lf="less --follow-name +F"

alias px="ps aux | grep"

alias vecka='date +%V'
alias diskspace="du -S | sort -n -r |more"

alias sudo='sudo '

alias untar='tar -xvf'

alias cdc='cd ~/devel/ctc-git'

# git diff for any diff
alias diff="git diff --no-index"

if status is-interactive
    # Commands to run in interactive sessions can go here
end
