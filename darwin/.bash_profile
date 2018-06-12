export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"
export HISTTIMEFORMAT="%d/%m/%y %T"


alias ll="ls -l"
alias sl="ls"
alias emacs='emacs -nw'
alias updatedb='sudo /usr/libexec/locate.updatedb'
alias rm="rm -i"

# export PATH="$HOME/.goenv/bin:$PATH"
# eval "$(goenv init -)"
#export PROMPT_COMMAND="echo -n \[\$(date +%H:%M:%S)\]\ "
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

function promps {
    local BLUE="\[\e[1;34m\]"
    local RED="\[\e[1;31m\]"
    local GREEN="\[\e[1;32m\]"
    local WHITE="\[\e[00m\]"
    local GRAY="\[\e[1;37m\]"

    case $TERM in
	xterm*) TITLEBAR='\[\e]0;\W\007\]';;
	*)      TITLEBAR="";;
    esac
    local BASE="`hostname`"
    PS1="${TITLEBAR}${GREEN}[${BASE}:${WHITE}${BLUE}\W${GREEN}] \D{%H:%M:%S}\$(parse_git_branch)${BLUE}\$${WHITE} "
}
promps

