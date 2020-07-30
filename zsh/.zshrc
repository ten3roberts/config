HISTFILE=$HOME/.config/zsh/.history
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

# oh-my-zsh


# Ignore duplicate entries in history
# setopt hist_ignore_all_dups

# Autologin
# if [[ "$(tty)" == "/dev/tty1" ]]; then
# 	prgep xinit || xinit
# fi

setopt nobanghist

source $HOME/.config/zsh/oh-my-zshrc
source $HOME/.config/zsh/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle pip
antigen bundle zsh-users/zsh-syntax-highlighting
# antigen bundle zsh-history-substring-search
# antigen bundle zsh-users/zsh-autosuggestions

# Syntax highlighting bundle.

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply

unsetopt auto_cd


zstyle :compinstall filename '/home/ten3roberts/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# Git
git_prompt() {
        changes=`git status --porcelain | wc -l` > /dev/null 2>/dev/null
        ref=$(git symbolic-ref HEAD | cut -d'/' -f3) > /dev/null 2>/dev/null
        [ -z "$ref" ] || echo -n " (%F{3}$ref%F{white}"
        [ "$changes" = "0" ] || echo -n "*$changes"
        [ -z "$ref" ] || echo ")"
}

setopt prompt_subst

# Configure Shell state

PS1='%F{white}%F{10}%n%F{white} %F{blue}%3~%F{white}$(git_prompt)%F{white}%(?.%F{white}.%F{red})>%F{white} '


# Bind Ctrl+x to open CLI edit in $EDITOR
export KEYTIMEOUT=1
autoload edit-command-line; zle -N edit-command-line
zle -N edit-command-line
bindkey '^x' edit-command-line 

# Ctrl Arrow key navigation
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Fix delete key
bindkey "^[[3~" delete-char
# Fix Ctrl backspace
bindkey "^H" backward-kill-word

# Control key navigation
bindkey '\e[1;5C' forward-word            # C-Right
bindkey '\e[1;5D' backward-word           # C-Left

# Helper functions
mkcd() { mkdir -p "$@" && cd "$1" }
conf() { $EDITOR $(find .config -maxdepth 2 -type f | fzf) }
# Quick movement functions
# d() { cd $(du -a ~/dev -d 1 | awk '{print $2}' | sed "s|~|$HOME|g" | fzf) }
# rs() { cd $(du -a ~/dev/rust -d 1 | awk '{print $2}' | sed "s|~|$HOME|g" | fzf) }



d() { cd ~/dev/$1 }
rs() { cd ~/dev/rust/$1 }

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias la='ls -a'
alias l='ls -F'
alias ll='ls -lhF'
alias cl="clear"

# Vim remove cache
alias vimrmc='rm $HOME/.cache/vim/swap/*'

# For config file access
alias bspwmrc="$EDITOR $HOME/.config/bspwm/bspwmrc"
alias sxhkdrc="$EDITOR $HOME/.config/sxhkd/sxhkdrc"
alias polyrc="$EDITOR $HOME/.config/polybar/config"
alias picomrc="$EDITOR $HOME/.config/picom/picom.conf"
alias build="cmake . && make"
alias rebuild="cmake . && make clean && make"

# Rust cargo
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'
alias clippy='cargo clean && cargo clippy'
cto() { cargo test $@ -- --show-output }
# Git aliases
alias log='git log --oneline'
alias graph='git log --graph --all --abbrev-commit'
alias subupdate='git submodule foreach git pull origin master'
alias status='git status'
alias branch='git checkout'
alias gs='git status'


alias remote='ssh timmer@dsu.uk.to'

# Void linux aliases
alias xi='sudo xbps-install'
alias xq='xbps-query'
alias xr='sudo xbps-remove'

# Emacs aliases
alias esync='~/.emacs.d/bin/doom sync'
alias doom='~/.emacs.d/bin/doom'
alias e='emacsclient -nw -a ""'

ec() {
    emacsclient -n -e "(if (> (length (frame-list)) 1) 't)" | grep -q t
    if [ "$?" = "1" ]; then
        emacsclient -c -n -a "" "$@"
    else
        emacsclient -n -a "" "$@"
    fi
}

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

