tput setf 3
echo ""
echo "Wing of liberty,\n\nHeart of Lion,\n\nRobust of Gear" | cowsay
echo ""
tput rev

export GNUPGHOME=~/.gnupg/trezor

# Rust
export SCCACHE_DIR=~/data/sccache
export RUSTC_WRAPPER=sccache
export PATH=$PATH:$HOME/.cargo/bin:$HOME/bin

plugins=(git)

export LANG=en_US.UTF-8
export EDITOR='nvim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export ZSH=/usr/share/oh-my-zsh
ZSH_THEME="xiong-chiamiov-plus"
source $ZSH/oh-my-zsh.sh

[ -f ~/.kube/_kubectl ] && source ~/.kube/_kubectl
alias gu="gitui"
