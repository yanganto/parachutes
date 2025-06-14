neofetch

setopt PROMPT_SUBST

export VIRTUAL_ENV_DISABLE_PROMPT=1
export ZSH_THEME_GIT_PROMPT_DIRTY="*"
export HISTFILE=$HOME/.zsh_history
export SAVEHIST=1000

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

function virtual_env_rpath () {
    if [ ${#PWD} -gt ${#VIRTUAL_ENV} ]; then
        echo ${$(pwd)#$VIRTUAL_ENV}
    elif [ ${#PWD} -eq ${#VIRTUAL_ENV} ]; then
        echo "/"
    else
        echo " - ${$(pwd)#$VIRTUAL_ENV}"
    fi
}

function virtual_env_path () {
    echo ${VIRTUAL_ENV:-}
}

function virtual_env_promp () {
    if [ -z ${VIRTUAL_ENV+x} ]; then
        echo "$";
    else
        echo $(python --version);
    fi
}

function secho() {
    echo -e "\e[38;5;82m[SUCCESS]\e[0m $1"
}

function eecho() {
    echo -e "\e[38;5;196m[ERROR]\e[0m $1"
}

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function hostname_color {
    HOST=`hostname`
    echo "3$(( ${#HOST} % 6 ))"
}

function user_color {
    if [ $USER = 'root' ]; then
        echo "31"
    else
        echo "3$(( ${#USER} % 4 + 2))"
    fi
}


PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;$(user_color)m%}%n%{\e[1;34m%}@%{\e[0m%}%{\e[0;$(hostname_color)m%}%m%{\e[0;34m%}%B]-[$(virtual_env_path)%b%{\e[1;37m%}% $(virtual_env_rpath)%{\e[0;34m%}%B]-[%b%{\e[0;33m%}'%D{"%F, %H:%M (%s)"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$(virtual_env_promp)%{\e[0;34m%}%B] <$(_omz_git_prompt_info)>%{\e[0m%}%b '
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '

export GNUPGHOME=~/.gnupg/trezor

# Rust
#export SCCACHE_DIR=~/data/sccache
#export RUSTC_WRAPPER=sccache
export PATH=$PATH:$HOME/.cargo/bin:$HOME/.usr/bin


export LANG=en_US.UTF-8
export EDITOR='nvim'

[ -f ~/.kube/_kubectl ] && source ~/.kube/_kubectl

export GITUI_SSH_KEY_PATH=~/.ssh/id_rsa
alias gu="nix run github:yanganto/gitui/flake"
alias g="git"
alias n="npm"
alias gp="git push"
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gcp="git cherry-pick"

alias c="cargo"
alias cb="cargo build"
alias cc="cargo check"
alias cl="cargo clean"
alias ct="cargo test"
alias cr="cargo run"

alias tg="terragrunt"
alias tf="terraform"
alias ta="terraform apply"

typeset -Ag ZI
typeset -gx ZI[HOME_DIR]="${HOME}/.zi"
typeset -gx ZI[BIN_DIR]="${HOME}/.zi/bin"
if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
    command mkdir -p "$ZI[BIN_DIR]"
    command git clone https://github.com/z-shell/zi.git "$ZI[BIN_DIR]"
fi
source "${ZI[BIN_DIR]}/zi.zsh"

autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

zi snippet OMZL::git.zsh

eval "$(direnv hook zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.my.zsh ] && source ~/.my.zsh
[ -f ~/.mcfly.zsh ] && source ~/.mcfly.zsh
[ -f ~/.zoxide.zsh ] && source ~/.zoxide.zsh

# Defined these arrays to check
# HOST_CHECK_LIST WEB_CHECK_LIST

server_info=/tmp/server_info
server_error=/tmp/server_error

if [ -f $server_info ]; then
    if [ -f $server_error ]; then
        eecho "Looks bad at `ls -l /tmp/server_info | awk '{print $8}'`"
        cat $server_info
    else
        secho "Server looks great at `ls -l /tmp/server_info | awk '{print $8}'`"
    fi
else
    for host in $HOST_CHECK_LIST; do
        echo $host >> $server_info
        ping -c 1 $host >>  $server_info
        if [ $? -eq 0 ]; then
            secho "$host server ready"
        else
            touch $server_error
            eecho "$host server down"
        fi
    done

    for web in $WEB_CHECK_LIST; do
        curl --head $web >> $server_info
        if [ $? -eq 0 ]; then
            secho "$web ready"
        else
            touch $server_error
            eecho "$web Web down"
        fi
    done
fi

set -o emacs
fpath=(~/.zsh/functions $fpath)
