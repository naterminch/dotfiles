
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

## HISTORY
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

### Zsh Options
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
setopt HIST_EXPIRE_DUPS_FIRST
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt auto_cd

### Functions
gcob() {
  git checkout "$(git branch --all | fzf | tr -d '[:space:]')"
}

### Alias
alias grep='grep --color=auto'
alias zinit-update="zinit update --parallel 40"


### Zsh Packages
zinit pack for dircolors-material


### Setup plugins
zinit light zsh-users/zsh-completions
# Initialize completion.
# See: https://github.com/Aloxaf/fzf-tab/issues/61
zpcompinit; zpcdreplay

zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search

zinit load zdharma-continuum/history-search-multi-word
zstyle ":history-search-multi-word" page-size "8"

# Autosuggestion plugin config.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
#ZSH_AUTOSUGGEST_MANUAL_REBIND=1
zinit light zsh-users/zsh-autosuggestions

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
zi ice from"gh-r" as"program"
zi light junegunn/fzf

# sharkdp/bat
zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

# Load x from OMZ
zi snippet OMZL::git.zsh
zi snippet OMZP::git

zi cdclear -q
zi snippet OMZP::kubectx
zi snippet OMZP::kubectl

### Load Other files
source <(pkgx --shellcode)
source /opt/homebrew/opt/asdf/libexec/asdf.sh

if [ -d "$HOME/.zsh_variables" ]; then
  for i in $HOME/.zsh_variables/*; do
    source $i
  done
else
  echo "Directory $HOME/.zsh_variables does not exist."
fi

# bun completions
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"

### Theme
# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship