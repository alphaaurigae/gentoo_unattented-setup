#  (!NOTE: .bash.rc by alphaaurigae 13.06.2025)

# reference https://github.com/gentoo/gentoo/blob/master/app-shells/bash/files/bashrc

[[ $- != *i* ]] && return

shopt -s histappend
shopt -s checkwinsize
shopt -s no_empty_cmd_completion

HISTSIZE=0
HISTFILESIZE=0

use_color=false
if type -P dircolors >/dev/null ; then
    LS_COLORS=
    if [[ -f ~/.dir_colors ]] ; then
        eval "$(dircolors -b ~/.dir_colors)"
	elif [[ -f /etc/DIR_COLORS ]] ; then
		eval "$(dircolors -b /etc/DIR_COLORS)"
	else
		eval "$(dircolors -b)"
	fi
	[[ -n ${LS_COLORS:+set} ]] && use_color=true || unset LS_COLORS
else
	case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|screen|tmux|cons25|*color) use_color=true ;;
	esac
fi

if $use_color ; then
	if [[ ${EUID} == 0 ]] ; then
		PS1='\t\[$(tput sgr0)\] \[\033[01;38;5;15m\][\[\033[01;38;5;196m\]\u\[\033[01;38;5;15m\]@\[\033[01;38;5;87m\]\h\[\033[01;38;5;15m\]:\[\033[01;38;5;249m\]\w\[\033[01;38;5;15m\]]\[\033[01;38;5;249m\]\$\[\033[01;38;5;220m\] '
	else
		
		PS1='\t\[$(tput sgr0)\] \[\033[01;38;5;201m\][\[\033[01;38;5;228m\]\u\[\033[01;38;5;135m\]@\[\033[01;38;5;87m\]\h\[\033[01;38;5;15m\]:\[\033[01;38;5;249m\]\w\[\033[01;38;5;201m\]]\[\033[01;38;5;249m\]\$\[\033[01;38;5;220m\] '
	fi
    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
else
    PS1='\u@\h \w \$ '
fi

case ${TERM} in
    [aEkx]term*|rxvt*|gnome*|konsole*|interix|tmux*)
        PS1='\[\033]0;\u@\h:\w\007\]'$PS1
        ;;
    screen*)
        PS1='\[\033_\u@\h:\w\033\\\]'$PS1
        ;;
esac

alias dir='dir --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01:quote=01'

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

for sh in /etc/bash/bashrc.d/* ; do
    [[ -r ${sh} ]] && source "${sh}"
done

unset use_color sh

GITCOMMIT() {
	git add .
	git commit -a -m "$1"
	git status
}
alias santa=GITCOMMIT
alias hohoho='git push'