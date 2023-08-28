#!/bin/zsh

# edits on 20190510_045208
# fpath="$fpath /home/alex/Working/zsh/completion/fdir"
zstyle ':completion:*' verbose yes
# fpath=(/home/alex/Working/zsh/completion/fdir $fpath)
zstyle ':completion:*' mpd-music-directory ~/Music

eval $(dircolors) # necessary to make list-colors work properly
#zstyle _bash_completions
zstyle ':completion:*' completer _complete _ignored _approximate _correct _match _extensions # enables completion:
zstyle ':completion:*' expand prefix suffix # jumps to longest unambiguous string
zstyle ':completion:*' format '%F{cyan}Completing: %d%f' # displays above completion lists
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # sets colors of file and dir completions
zstyle ':completion:*' menu select=1 # enables selection menu unconditionally
zstyle ':completion:*' prefix-hidden true # hides common prefixes
zstyle ':completion:*' select-prompt '%SScrolling completion: line %l, %p%s' # string to display when scrolling selection
zstyle ':completion:*' show-ambiguity true # marks the first common character in completions
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit && compinit

compdef _youtube-dl yt_to_pl yt_to_mpv yt_to_vlc
