#!/bin/zsh
#
# ~/.zshrc
#

# misc options
setopt AUTO_CD
setopt EXTENDED_HISTORY
bindkey -v

# history
HISTFILE=~/.zsh_history
SAVEHIST=100000
HISTSIZE=100000
# use INC_APPEND_HISTORY instead of SHARE_HISTORY because of hidehist
setopt INC_APPEND_HISTORY HIST_IGNORE_ALL_DUPS

# prompt
setopt PROMPT_SUBST

source ~/Dotfiles/extras/zsh-git-prompt/zshrc.sh
source ~/Dotfiles/zsh/pwd_shorten.sh
PROMPT='%b%f%k'\
'%B%F{magenta}'\
'%D{%a, %b %-d, %H:%M:%S}'\
'%b%f%k'\
$'\n'\
'%(1000#.%F{white}%K{blue}.%F{black}%K{red})'\
's%Le%? %n@%M'\
'%f%k'\
$'\n'\
'%F{cyan}$(pwds_status)%f'\
$'\n'\
'$(git_super_status)'\
'%F{cyan}$(hidehist)%(#.#.%%)%f '\
'%b%f%k'

source ~/.zshenv
source ~/.zsh/zstyles.zsh

# binding to edit the current command line with $EDITOR
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# zbell.sh
source ~/Dotfiles/extras/zbell.sh

# source aliases and commands
source ~/.zsh/aliases.zsh
source ~/.zsh/commands.zsh
source ~/.zsh/terminals.zsh
source ~/.zsh/microshell.zsh quiet
