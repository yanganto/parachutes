tput setf 3
echo ""
echo "Wing of liberty,\n\nHeart of Lion,\n\nRobust of Gear" | cowsay
echo ""
tput rev

setopt PROMPT_SUBST

export VIRTUAL_ENV_DISABLE_PROMPT=1
export ZSH_THEME_GIT_PROMPT_DIRTY="*"

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

PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;$(user_color)m%}%n%{\e[1;30m%}@%{\e[0m%}%{\e[0;$(hostname_color)m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %b%{\e[0;34m%}%B[$(virtual_env_path)%b%{\e[1;37m%}% $(virtual_env_rpath)%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"%a %b %d, %H:%M"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$(virtual_env_promp)%{\e[0;34m%}%B] <$(git_prompt_info)>%{\e[0m%}%b '
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '

export GNUPGHOME=~/.gnupg/trezor

# Rust
export SCCACHE_DIR=~/data/sccache
export RUSTC_WRAPPER=sccache
export PATH=$PATH:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.usr/bin


export LANG=en_US.UTF-8
export EDITOR='nvim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.kube/_kubectl ] && source ~/.kube/_kubectl

alias gu="gitui"
alias g="git"
alias gp="git push"
alias ga="git add"
alias gco="git checkout"
alias gcp="git cherry-pick"

[ -f ~/.zinit/bin ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
# zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZL::git.zsh

eval "$(direnv hook zsh)"

[ -f ~/.my.zsh ] && source ~/.my.zsh

# Defined these arrays to check
# HOST_CHECK_LIST WEB_CHECK_LIST

server_info=/tmp/server_info
server_error=/tmp/server_error

if [ -f $server_info ]; then
    if [ -f $server_error ]; then
        eecho "Looks bad at `ls -l /tmp/server_info | awk '{print $8}'`"
        cat $server_info
    else
        secho "Server Looks great at `ls -l /tmp/server_info | awk '{print $8}'`"
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

outdate_packages=/tmp/outdate_packages.txt
function ghTagCheck() {
    catch_file=/tmp/tag-check-${1}-${2}
    if [ ! -f $catch_file ]; then
        curl -s https://github.com/${1}/${2}/releases \
            | hxnormalize -x  \
            | hxselect -s '\n' -c "span.css-truncate-target" \
            | head -n 1 \
            > $catch_file
    fi

    version=$(cat $catch_file)

    if [ $version != $3 ]; then
        eecho "The package for ${1}/${2} ($3) is out of update, current is $version"
        echo "${1}/${2} ${3} -> $version" >> $outdate_packages
    fi
}

ghTagCheck "soywod" "himalaya" "v0.2.7"
ghTagCheck "extrawurst" "gitui" "v0.14.0"
ghTagCheck "qarmin" "czkawka" "3.0.0"

# TODO handle manually tags here
# tagCheck "acj" "krapslog" "0.1.2"
# tagCheck "arp242" "find-cursor" "v1.6"

if [ -f $outdate_packages ]; then
    eecho "Packages out of date"
    cat $outdate_packages
else
    secho "All package updated"
fi

fpath=(~/.zsh/functions $fpath)
autoload -Uz compinit
compinit -u
