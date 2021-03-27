export QT_QPA_PLATFORMTHEME='qt5ct'


# Default programs
export BROWSER="firefox"
# export TERMINAL="kitty"
export EDITOR="nvim"
export VISUAL="nvim"

# export MANPAGER='nvim +Man!'
# export MANPAGER="bat -l man -p'"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export TERMINAL="st"

export PATH=$HOME/.nimble/bin:$HOME/.scripts:$HOME/.cargo/bin:$HOME/.local/bin::/usr/local/go/bin:$PATH

# Cleanup home
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOMR="$HOME/.config"
export ZDOTDIR="$HOME/.config/zsh"
export INPUTRC="$HOME/.config/inputrc"
export LESSHISTFILE="-"

# Vim color scheme
# Favourites
# base16-horizon-dark
# nord
export VIM_COLORSCHEME="nord"
