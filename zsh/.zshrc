# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/timofeev/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="clean"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git bundler macos rake ruby)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias v="nvim"

alias g="git"
alias ga="git add"
alias gb="git branch"
alias gba="git branch -a"
alias gbd="git branch -d"
alias gbdr="git push origin --delete"
alias gc="git commit"
alias gca="git commit -a"
alias gcm="git commit -m"
alias gch="git checkout"
alias gl="git log --pretty=format:'%Cred%h%Creset %s %Cgreen(%cr)%Creset %Cblue[%an]%Creset' --date=relative"
alias gchp="git cherry-pick"
alias gs="git status"
alias gsb="gs -sb"
alias gst="git stash"
alias gf="git fetch"
alias gm="git merge"
alias gpsh="git push --tags"
alias gpl="git pull"
alias gpsho="gpsh origin"
alias gplo="gpl origin"
alias gd="git diff --color"
alias gdpat="gd --patience"
alias gds="gd --stat"
alias gdl="gl --cherry-pick"
alias gt="git tag"
alias gsh="git show --color"
alias gshs="gsh -s"
alias gshst="gsh --stat"
alias gbl="git blame --date=short"
alias gp='git push'
alias lkd='lein kibit $(git diff --name-only)'
alias gum="git fetch origin master:master"
alias grm="gum && git rebase master --autostash"
alias gmm="gum && git merge master --autostash"
alias gkm="git branch | grep -v \"master\" | xargs git branch -D"
alias gbr='git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff master...{1} --color=always" --pointer="" | xargs git checkout'
# gh extension install davidraviv/gh-clean-branches
alias gcb="gh clean-branches --verbose"
alias ghpr="gh pr create -a @me -w"

# Helper function.
git_start_new_branch_from_master() {
  gum && gch -b "$@" master
}
alias gsf="git_start_new_branch_from_master"

fzf_git_log_pickaxe() {
   if [[ $# == 0 ]]; then
       echo 'Error: search term was not provided.'
       return
   fi
   local selections=$(
     git log --oneline --color=always -S "$@" |
       fzf --ansi --no-sort --no-height \
           --preview "git show --color=always {1}"
     )
   if [[ -n $selections ]]; then
       local commit=$(echo "$selections" | cut -d' ' -f1)
       local remote=$(git remote -v | head -n 1 | awk -F "@" '{print $2}' | awk -F " " '{print $1}' | sed 's/:/\//g' | sed 's/.git//g' | awk '{print "https://"$1"/commit/"}')
       open $remote$commit
   fi
}

alias gls='fzf_git_log_pickaxe'

# Helper function.
git_current_branch() {
  cat "$(git rev-parse --git-dir 2>/dev/null)/HEAD" | sed -e 's/^.*refs\/heads\///'
}
alias gpthis='gp --set-upstream origin $(git_current_branch)'

export EDITOR='nvim'
export DISABLE_SPRING=1
export HUSKY_SKIP_HOOKS=1
export HOMEBREW_NO_AUTO_UPDATE=1

# for ‘rspec’ instead of ‘bin/rspec’
export PATH="./bin:$PATH"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@11/bin:$PATH"
export PATH="$HOME/projects/deploy:$PATH"

alias jrun=jrun.sh

eval "$(rbenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
