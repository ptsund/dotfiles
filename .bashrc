#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*|alacritty)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

if [ -z "$(pgrep ssh-agent)" ]; then
  rm -rf /tmp/ssh-*
  eval $(ssh-agent -s) > /dev/null
else
  export SSH_AGENT_PID=$(pgrep ssh-agent)
  export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
fi

if [ "$(ssh-add -l)" == "The agent has no identities." ]; then
  ssh-add
fi

alias config="/usr/bin/git --git-dir=/home/psm/.dotfiles/ --work-tree=/home/psm/"

alias ls="ls -lAh --color=auto"
alias lst="ls -lAht --color=auto"
alias lss="ls -lAhS --color=auto"
alias grep="grep --colour=auto"
alias egrep="egrep --colour=auto"
alias fgrep="fgrep --colour=auto"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias df="df -h"
alias pacup="sudo pacman -Syu"
alias pacupd="sudo pacman -Sy"
alias pacupg="sudo pacman -Su"
alias pacsr="sudo pacman -Ss --color=auto"
alias pacin="sudo pacman -S"
alias pacrm="sudo pacman -R"
alias free="free -m"
alias np="nano -w PKGBUILD"
alias more=less
alias ssh="TERM=xterm-256color ssh"

alias gfe='git fetch -p'
alias gcm='git commit'
alias gcmm='git commit -m'
alias gcma='git commit -a'
alias gcmam='git commit -am'
alias gcmad='git commit --amend'
alias gcmadch='git commit --amend -C HEAD'
alias ga='git add'
alias gaa='git add .'
alias gap='git add -p .'
alias gau='git add -u'
alias gp='git push'
alias gpu='git push -u origin HEAD'
alias gpf='git push -f'
alias gb='git branch'
alias gbv='git branch -v'
alias gbvv='git branch -vv'
alias gbr='git branch -r'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gbm='git blame'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias gdw='git diff -w'
alias gdc='git diff --cached'
alias gre='git reset'
alias greh='git reset --hard'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gst='git status'
alias gl='git log'
alias glgo='git log --graph --oneline'
alias gref='git reflog'
alias gm='git merge'
alias gs='git show'
alias gss='git show --stat'
alias gsmur='git submodule update --remote'

xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend
set -o vi

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

export LS_COLORS="ow=01;36;40"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

export PATH="$PATH:$HOME/.local/bin/jetbrains-2021.3.4/bin:$HOME/.emacs.d/bin:$HOME/.dotnet:$HOME/Applications"
export DOTNET_ROOT="$HOME/.dotnet"
export HISTTIMEFORMAT='%F %T '
export curseforge=CurseForge-0.198.1-29_703140e0b962037d84be40bac6be84e0.AppImage


export PATH=$PATH:/home/psm/bin

source '/home/psm/lib/azure-cli/az.completion'

eval "$(starship init bash)"
