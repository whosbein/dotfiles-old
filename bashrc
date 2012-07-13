#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# prompt
# from blog.sanctum.geek.nz
prompt_git() {
    git branch &>/dev/null || return 1
    HEAD="$(git symbolic-ref HEAD 2>/dev/null)"
    BRANCH="${HEAD##*/}"
    [[ -n "$(git status 2>/dev/null | \
        grep -F 'working directory clean')" ]] || STATUS="!"
    printf '(git:%s)' "${BRANCH:-unknown}${STATUS}"
}
prompt_hg() {
    hg branch &>/dev/null || return 1
    BRANCH="$(hg branch 2>/dev/null)"
    [[ -n "$(hg status 2>/dev/null)" ]] && STATUS="!"
    printf '(hg:%s)' "${BRANCH:-unknown}${STATUS}"
}
prompt_svn() {
    svn info &>/dev/null || return 1
    URL="$(svn info 2>/dev/null | \
        awk -F': ' '$1 == "URL" {print $2}')"
    ROOT="$(svn info 2>/dev/null | \
        awk -F': ' '$1 == "Repository Root" {print $2}')"
    BRANCH=${URL/$ROOT}
    BRANCH=${BRANCH#/}
    BRANCH=${BRANCH#branches/}
    BRANCH=${BRANCH%%/*}
    [[ -n "$(svn status 2>/dev/null)" ]] && STATUS="!"
    printf '(svn:%s)' "${BRANCH:-unknown}${STATUS}"
}
prompt_vcs() {
    prompt_git || prompt_svn || prompt_hg
}
prompt_jobs() {
    [[ -n "$(jobs)" ]] && printf '{%d}' $(jobs | sed -n '$=')
}

#PS1='[\u@\h \W]$(prompt_vcs) \$ '
PROMPT_COMMAND='DIR=`pwd|sed -e "s!$HOME!~!"`; if [ ${#DIR} -gt 30 ]; then CurDir=${DIR:0:12}...${DIR:${#DIR}-15}; else CurDir=$DIR; fi'
prompt_on() {
    PS1="\$(prompt_jobs)[\$CurDir]\$(prompt_vcs) \$ "
}
prompt_off() {
    PS1='\$ '
}
prompt_on

# GENERAL SETTINGS
PATH=$PATH:/home/$(whoami)/bin
set -o vi
shopt -s cdspell        # corrects typos in cd commands
shopt -s checkwinsize   # updates value of LINES and COLUMNS after each command

export EDITOR="/usr/bin/vim"

export PYTHONSTARTUP=/home/$(whoami)/.pystartup

#export TERM=xterm-256color # !! FIGURE OUT A BETTER WAY TO DO THIS !!
# better way:
# in ~/.Xresources put:
# XTerm*termName: xterm-256color
# all I really care about this thus far is happy colors in vim - might be other reasons

# pretty colors 
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ALIASES
# ls aliases
alias la='ls -A'           # show hidden files - no . and ..
alias ll='ls -l'           # long listing (details)
alias lsl='ls --group-directories-first' # see --
alias lal='la --group-directories-first' # see --
alias lll='ll --group-directories-first' # see --
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lShr'        # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last

# feh
#alias feh='feh --magick-timeout -1'

# COMPLETIONS

#complete -cf sudo       # enable tab completion with sudo
#complete -cf man

# MISC FUNCTIONS

function swap()  # Swap 2 filenames around, if they exist
{
    local TMPFILE=tmp.$$ 

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE 
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function displaycolors()
{
    # Original: http://frexx.de/xterm-256-notes/
    #           http://frexx.de/xterm-256-notes/data/colortable16.sh
    # Modified by Aaron Griffin
    # and further by Kazuo Teramoto
    FGNAMES=(' black ' '  red  ' ' green ' ' yellow' '  blue ' 'magenta' '  cyan ' ' white ')
    BGNAMES=('DFT' 'BLK' 'RED' 'GRN' 'YEL' 'BLU' 'MAG' 'CYN' 'WHT')

    echo "     ┌──────────────────────────────────────────────────────────────────────────┐"
    for b in {0..8}; do
    ((b>0)) && bg=$((b+39))

    echo -en "\033[0m ${BGNAMES[b]} │ "
    
    for f in {0..7}; do
        echo -en "\033[${bg}m\033[$((f+30))m ${FGNAMES[f]} "
    done
    
    echo -en "\033[0m │"
    echo -en "\033[0m\n\033[0m     │ "
    
    for f in {0..7}; do
        echo -en "\033[${bg}m\033[1;$((f+30))m ${FGNAMES[f]} "
    done

    echo -en "\033[0m │"
    echo -e "\033[0m"

    ((b<8)) &&
    echo "     ├──────────────────────────────────────────────────────────────────────────┤"
    done
    echo "     └──────────────────────────────────────────────────────────────────────────┘"
}

##################################################
# Print a cron formatted time for 2 minutes in 	 #
# the future (for crontab testing)		 #
##################################################

function crontest() { date '-d +2 minutes' +'%M %k %d %m *'; }

function currency_convert() { wget -qO- "http://www.google.com/finance/converter?a=$1&from=$2&to=$3&hl=es" | sed '/res/!d;s/<[^>]*>//g'; }

##################################################
# Dirsize - finds directory sizes and lists	 #
# them for the current directory		 #
##################################################

function dirsize()
{
du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
egrep '^ *[0-9.]*M' /tmp/list
egrep '^ *[0-9.]*G' /tmp/list
rm /tmp/list
}
