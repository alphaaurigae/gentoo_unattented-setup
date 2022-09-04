#  (!NOTE: .bash.rc by alphaaurigae 11.08.19)
#  ~/.bashrc: executed by bash(1) for non-login shells.
#  Examples: /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
[[ $- != *i* ]] && return  # If not running interactively, don't do anything
shopt -s histappend  # append to the history file.
HISTSIZE=1000  # max bash history lines.
HISTFILESIZE=2000  # max bash history filesize in bytes.
shopt -s checkwinsize  # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
case "$TERM" in  # set a fancy prompt (non-color, unless we know we "want" color)
    xterm-color|*-256color) color_prompt=yes;;
esac
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi
if [ "$color_prompt" = yes ]; then
	PS1='\t\[$(tput sgr0)\] ${debian_chroot:+($debian_chroot)}\[\033[01;38;5;201m\][\[\033[01;38;5;228m\]\u\[\033[01;38;5;135m\]@\[\033[01;38;5;87m\]\h\[\033[01;38;5;15m\]:\[\033[01;38;5;249m\]\w\[\033[01;38;5;201m\]]\[\033[01;38;5;249m\]\$\[\033[01;38;5;220m\] '
else
    PS1='${gentoo_chroot:+($gentoo_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
case "$TERM" in  # If this is an xterm set the title to user@host:dir
xterm*|rxvt*)
    PS1="\[\e]0;${arch_chroot:+($)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
# aliases for the bash shell.
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'  # colored GCC warnings and errors
if [ -f ~/.bash_aliases ]; then  # ~/.bash_aliases, instead of adding them here directly.
    . ~/.bash_aliases
fi
GITCOMMIT () {
	git add .
	git commit -a -m "$1"
	git status
}
alias santa=GITCOMMIT
alias hohoho='git push'
