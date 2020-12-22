HISTFILE=$HOME/.config/zsh/.history
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

# Load wal theme
(cat ~/.cache/wal/sequences &)

# oh-my-zsh


# Ignore duplicate entries in history
setopt hist_ignore_all_dups

# Autostart X on tty1
if [[ "$(tty)" == "/dev/tty1" ]]; then
    prgep xinit || xinit
fi

function chpwd {
    set_title "st - `basename $PWD`"
}

# setopt nobanghist

unsetopt auto_cd

# Git
git_prompt() {
    changes=`git status --porcelain | wc -l` > /dev/null 2>/dev/null
    # untracked=`git clean -n | wc -l` > /dev/null 2>/dev/null

    ref=$(git symbolic-ref HEAD | cut -d'/' -f3) > /dev/null 2>/dev/null
    [ -n "$ref" ] && echo -n " (%F{3}$ref%F{white}"
    # [ "$untracked" != "0" ] && echo -n "+"
    [ "$changes" != "0" ] && echo -n "•"
    [ -n "$ref" ] && echo ")"
}

setopt prompt_subst

# Configure Shell state
PS1='%F{white}%F{10}%n%F{white} %F{blue}%3~%F{white}$(git_prompt)%F{white}%(?.%F{white}.%F{red} [%?])%(!.#.>)%F{white} '

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
# Quick movement aliases
# alias d='cd `find -maxdepth 3 -type d | fzf` && exa'
# alias n='cd `find -maxdepth 3 | fzf` && nvim .'

d() {
    res=`find -maxdepth 3 -type d | fzf`
    [ -z $res ] && return 1
    cd $res
    exa || ls
}

n() {
    res=`find -maxdepth 3 | fzf`
    [ -z $res ] && return 1
    [ -d $res ] && (cd $res; nvim .)
    [ -f $res ] && (cd `dirname $res`; nvim `basename $res`)
}

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias la='ls -a'
alias l='ls -F'
alias ll='ls -lhF'
alias cl="clear"

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
alias cw='cargo watch -c'
alias cwr='cargo watch -cx run'
cto() { cargo test $@ -- --show-output }
# Git aliases
alias log='git log --oneline'
alias graph='git log --graph --all --abbrev-commit'
alias subupdate='git submodule foreach git pull origin master'
alias status='git status'
alias branch='git checkout'

alias gc='git commit'
alias ga='git add -v'
alias gp='git push'
alias gl='git log --oneline'
alias gpl='git pull'
alias gs='git status'
alias gd='git diff'

alias remote='ssh timmer@dsu.uk.to'

# Void linux aliases
alias xi='sudo xbps-install'
alias xq='xbps-query'
alias xr='sudo xbps-remove'

# Emacs aliases
alias esync='~/.emacs.d/bin/doom sync'
alias doom='~/.emacs.d/bin/doom'
alias e='emacsclient -nw -a ""'

alias spt='spotify-tui'

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Load syntax highlighting
source $HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

alias pipes='pipes.sh -t `shuf -i 0-9 -n 1` -R -p 2 -f 20'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

return 0
