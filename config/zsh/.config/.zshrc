# FSN v3b - 2020-July-10
# FSN v3c - 2020-09-27 added DIFFPROG for pacdiff using meld
# FSN v3d - 2021-03-05 using node // cargo (for rust) // pk10 as per documentation
# FSN v3e - 2021-04-08 added stuff at end similar to neofetch
# FSN v3f - 2021-08-02 cleaned up different paths git installation
# FSN v4  - part of Garuda
# FSN v5 -  2021-Aug-18 total-rewrite for zsh completion & using zshenv
#           file now in ~/.config/zsh
# FSN v5a - Aug-20-2021 - more changes to setopy etc
# FSN v51 - Sept-05-2021 - added powerlevel10 at top
# FSN v52-debian - May-24-2022
# FSN v53-manjaro - July 17 2022
# FSN v54 changed history size & added MANPAGER using bat Aug 01 2022
# FSN v55 removed all pyenv and rust stuff Aug 07 2022

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# don't use 'url-quote-magic in oh-my-zsh/lib/misc.zsh
DISABLE_MAGIC_FUNCTIONS=true


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# FSN resetting all path
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

_comp_options+=(globdots) # With hidden files

# Load antigen plugin manager
source "$HOME/.antigen/bin/antigen.zsh"

# Load Antigen Configurations
# antigen init "$ZDOTDIR/.antigenrc"
antigen init "$HOME/.config/antigenrc"

# Completion -- load after sourcing plugins
. "$ZDOTDIR/.completion.zsh"


# +------------+
# | NAVIGATION |
# +------------+

setopt auto_cd         # if cmd is directory than cd to that directory

setopt auto_pushd               # make cd push old dir in dir stack
setopt pushd_ignore_dups        # no duplicates in dir stack
setopt pushd_silent             # no dir stack after pushd or popd
setopt pushd_to_home            # `pushd` = `pushd $HOME`

setopt correct                  # spelling correction for commands
setopt correct_all
setopt cd_able_vars          # Change directory to a path stored in a variable.

setopt complete_in_word         # allow completion from within a word/phrase
setopt complete_aliases          # complete alisases

setopt always_to_end            # when completing from middle of word, move the cursor to end of word

setopt extended_glob        # Use extended globbing syntax.
setopt glob_dots
setopt no_case_glob         # globbing and tab-completion to be case-insensitive
## setopt nonomatch means wildcard * works - does this globally like in bash
setopt nonomatch

# autoload -Uz bd; bd


setopt hash_list_all            # hash everything before completion
setopt interactivecomments      # Make commenting with '#' work
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.

# +---------------+
# | HISTORY |
# +---------------+

export HISTSIZE=100000
export SAVEHIST=100000
export HISTORY_IGNORE="(ls|cd|pwd|exit|cd ..)"

setopt extended_history          # write the history file in the ':start:elapsed;command' format.
setopt share_history             # share history between all sessions.
setopt hist_expire_dups_first    # expire a duplicate event first when trimming history.
setopt hist_ignore_dups          # do not record an event that was just recorded again.
setopt hist_ignore_all_dups      # delete an old recorded event if a new event is a duplicate.
setopt hist_find_no_dups         # do not display a previously found event.
setopt hist_ignore_space         # do not record an event starting with a space.
setopt hist_save_no_dups         # do not write a duplicate event to the history file.
setopt hist_verify               # do not execute immediately upon history expansion.
setopt hist_reduce_blanks        # remove superfluous blanks from command
setopt inc_append_history        # append to the history immediately, not when the shell exits

### end history

##  Autoload

autoload -U colors && colors

(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help
alias help=run-help

autoload run-help-git
autoload run-help-sudo

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

# gives emacs style of line editing at the prompt = binkey -e
# Set vim mode for zsh
bindkey -e

# use Ctrl-P to accept suggestion
bindkey '^P' autosuggest-accept

# FSN to search history up arrow or down arrow
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# +---------------------------+
# |    PATH                   +
# Custom binaries and scripts +
# +---------------------------+

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

# for pacdiff
export DIFFPROG='sudo meld'

# Make nano the default editor
export EDITOR='nano'
export VISUAL='nano'

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Include aliases dotfile

# $ZOOTDIR -> $HOME/.config/zsh
[[ -f "$ZDOTDIR/.zsh-aliases" ]] && source  "$ZDOTDIR/.zsh-aliases"

[[ -f "$ZDOTDIR/.fzf.zsh" ]] && source  "$ZDOTDIR/.fzf.zsh"


# Key bindings
# ------------
source "/home/nicholas/.fzf/shell/key-bindings.zsh"

# fsn added for tilix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"

# neofetch
