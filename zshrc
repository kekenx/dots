#!/bin/zsh

if [ -z "$TMUX" ] && [ -z "$STY" ] ;then
    if tmux list-sessions >& /dev/null; then
        exec tmux a
    else
        exec tmux new -s main
    fi
fi

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

prompt() {
    echo "%F{green}%n@%m:%f%F{blue}%~%f%F{green}$(parse_git_branch)%f$ "
}
export PS1='$(prompt)'
setopt PROMPT_SUBST

use_emacs() {
    # use emacs daemon if running.
    emacsclient -nw --no-wait -c "$1" 2> /dev/null || emacs -nw "$1"
}

clipin() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	xclip -selection clipboard
    elif [[ "$OSTYPE" == "darwin"* ]]; then
	pbcopy
    fi
}

alias ls="ls --color=auto"
alias ll="ls -l"
alias sl="ls"
alias e='use_emacs'
alias emacs='use_emacs'
alias updatedb='sudo /usr/libexec/locate.updatedb'
alias rm="rm -i"

# For zsh
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_no_store

# For python environment
PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# For rust environment
source $HOME/.cargo/env
alias cr="cargo run"
alias cb="cargo build"

# For Node
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
