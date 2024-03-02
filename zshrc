#!/bin/zsh
#
# ~/.zshrc
#
# vim: fdm=marker fdl=0 nornu

## Miscellaneous ##

# This has to be done early for stuff later on.
autoload -U add-zsh-hook

### General settings ### {{{

# globs
setopt GLOB_COMPLETE
setopt BARE_GLOB_QUAL EXTENDED_GLOB
# setopt BARE_GLOB_QUAL NO_EXTENDED_GLOB
# setopt EXTENDED_GLOB NO_BARE_GLOB_QUAL
# setopt GLOBDOTS
setopt NULL_GLOB
	# null glob removes param instead of err
setopt GLOB_STAR_SHORT
	# **/* abbrev to ** and ***/* abbrev to ***

# zle
setopt INTERACTIVE_COMMENTS
setopt CORRECT DVORAK
CORRECT_IGNORE='_*'
# setopt CORRECTALL
setopt HIST_SUBST_PATTERN

# misc
setopt NO_CLOBBER
setopt RM_STAR_WAIT
# }}}

### History ### {{{
HISTFILE=~/.zsh_history
SAVEHIST=10000 # 10k lines in file
HISTSIZE=10000 # 10k lines in memory

setopt APPEND_HISTORY # enabled by default
setopt EXTENDED_HISTORY INC_APPEND_HISTORY_TIME # timestamp, save after completion
# setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE HIST_NO_STORE HIST_VERIFY
# prefix with space to ignore, ignore all `fc' events, and
# load history references into the line editor
# }}}

### Source-ry ### {{{
source ~/.zsh/zstyles.zsh
source ~/.zsh/prompt.zsh
# source aliases and commands
source ~/.zsh/aliases_commands.zsh
source ~/.zsh/uwu.zsh
# heavier custom stuff
source ~/.zsh/ansi_title.zsh
source ~/.zsh/microshell.zsh quiet
source ~/.zsh/youtube.zsh
# this one is really hacky
source ~/.zsh/interactive.zsh
# some stuff has to go in a separate file, so it doesn't end up on github
[[ -f ~/Dotfiles/extras/secrets/secrets.zsh ]] &&
source ~/Dotfiles/extras/secrets/secrets.zsh
# }}}

### Key binding ### {{{
bindkey -v
bindkey "^[^M" self-insert-unmeta

# bind to expand variables
bindkey "^X*" expand-word
bindkey "^Xe" expand-word

# bind to open buffer in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
# }}}

### Unsorted ### {{{
# 2023-01-30 01:20:15
# Why is this section such a mess?

autoload -U zargs zcalc
autoload -U colors

# # 2023-01-30 01:20:09
# autoload -U url-quote-magic
# zle -N self-insert url-quote-magic

# default behavior
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n&|'
# default, but added ';'
ZLE_SPACE_SUFFIX_CHARS=$'&|;'

zbell_ignore=($EDITOR $PAGER startx man ssh tmux tmx vlc feh weechat watch mpv)
source ~/.zsh/zbell.sh
# }}}

#### ZLE Highlighting ### {{{
#local zsh_syntax_colors=/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#local zsh_syntax_colors=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#if [[ $USER != root ]] && source \
#	$zsh_syntax_colors \
#	>/dev/null \
#	2>/dev/null \
#; then
#	# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)
#	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root)

#	# default settings
#	ZSH_HIGHLIGHT_STYLES=( [arg0]='fg=green' [assign]=none [back-dollar-quoted-argument]='fg=cyan' [back-double-quoted-argument]='fg=cyan' [back-quoted-argument]=none [bracket-error]='fg=red,bold' [bracket-level-1]='fg=blue,bold' [bracket-level-2]='fg=green,bold' [bracket-level-3]='fg=magenta,bold' [bracket-level-4]='fg=yellow,bold' [bracket-level-5]='fg=cyan,bold' [commandseparator]=none [comment]='fg=black,bold' [cursor]=standout [cursor-matchingbracket]=standout [default]=none [dollar-double-quoted-argument]='fg=cyan' [dollar-quoted-argument]='fg=yellow' [double-hyphen-option]=none [double-quoted-argument]='fg=yellow' [globbing]='fg=blue' [history-expansion]='fg=blue' [line]='' [path]=underline [path_pathseparator]='' [path_prefix_pathseparator]='' [precommand]='fg=green,underline' [redirection]=none [reserved-word]='fg=yellow' [root]=standout [single-hyphen-option]=none [single-quoted-argument]='fg=yellow' [suffix-alias]='fg=green,underline' [unknown-token]='fg=red,bold' )

#	# my settings
#	ZSH_HIGHLIGHT_STYLES[arg0]='fg=white'
#	ZSH_HIGHLIGHT_STYLES[arg0]='fg=default' # Mon, Mar 13 2023, 15:45
#	ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan'
#	# ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='bold'
#	# ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='bold'
#	ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='italics'
#	ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='italics'
#	# ZSH_HIGHLIGHT_STYLES[commandseparator]='bold,fg=red'
#	ZSH_HIGHLIGHT_STYLES[commandseparator]='bold'
#	ZSH_HIGHLIGHT_STYLES[redirection]='bold'
#	# ZSH_HIGHLIGHT_STYLES[path]='bold,'
#	# ZSH_HIGHLIGHT_STYLES[path_pathseparator]=''
#	# ZSH_HIGHLIGHT_STYLES[path_prefix]='bold'
#	# ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=''

#	if false ; then # 2021-01-28 09:36:00
#	ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=yellow,bold'
#	# ZSH_HIGHLIGHT_STYLES[cursor]='none'
#	# ZSH_HIGHLIGHT_STYLES[line]='none'
#	#
#	ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan'
#	ZSH_HIGHLIGHT_STYLES[arg0]='bold,fg=cyan'
#	ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='bold'
#	ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='bold'
#	ZSH_HIGHLIGHT_STYLES[commandseparator]='bold,fg=red'
#	ZSH_HIGHLIGHT_STYLES[redirection]='bold,fg=red'
#	#
#	ZSH_HIGHLIGHT_STYLES[path]='bold,fg=blue'
#	ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=cyan'
#	ZSH_HIGHLIGHT_STYLES[path_prefix]='bold,fg=cyan,bg=blue'
#	ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=cyan,bg=blue'
#	#
#	ZSH_HIGHLIGHT_STYLES[globbing]='fg=green,bold'
#	# typeset -A ZSH_HIGHLIGHT_PATTERNS
#	# ZSH_HIGHLIGHT_PATTERNS=()
#	# ZSH_HIGHLIGHT_PATTERNS+=('mpc' 'bg=white,fg=black')
#	fi
#fi
## }}}

## Janky extras that we maybe want to load last? Potentially? ##

# guarantee catgirl joke
[[ -f ~/girl ]] || echo 'nya~' > ~/girl
# less cat and more dog?
woof() { < ~/Dotfiles/extras/woof.txt gay -i 2d $@ }
woof

# # more weird testing stuff
# autoload -Uz url-quote-magic bracketed-paste-magic
# zle -N self-insert url-quote-magic
# zle -N bracketed-paste bracketed-paste-magic

#unimatrix.py -w -s 99
