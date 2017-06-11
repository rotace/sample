#!/bin/bash
# bashrc: excuted by bash for non-login shells.

file=$1

## check last column
if expr "`tail -n 1 ${file}`" :  [A-Za-z0-9] >/dev/null; then
cat  >> ${file} <<EOF

EOF
fi

## write setting
cat >>  ${file} <<EOF
#!#! header( do not remove )


### USER SETTING (updated by bashrc.sh) ###
# bashの色を変える
export PS1="\[\e[1;33m\][\u@\h:\W]\\$\[\e[00m\] "

# デフォルトエディタの設定
export EDITOR=vim

# manページに色をつける
man() {
	env \\
		LESS_TERMCAP_mb=\$(printf "\e[1;31m") \\
		LESS_TERMCAP_md=\$(printf "\e[1;31m") \\
		LESS_TERMCAP_me=\$(printf "\e[0m") \\
		LESS_TERMCAP_se=\$(printf "\e[0m") \\
		LESS_TERMCAP_so=\$(printf "\e[1;44;33m") \\
		LESS_TERMCAP_ue=\$(printf "\e[0m") \\
		LESS_TERMCAP_us=\$(printf "\e[1;32m") \\
		man "\$@"
}

# Git
alias gitlog="git log --graph --oneline --decorate"

# emacs
alias emd="emacs --daemon"
alias ee="emacsclient -e '(kill-emacs)'"
alias ec="emacsclient -c"
alias en="emacsclient -nw"

EOF
