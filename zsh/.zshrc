# Path to your oh-my-zsh installation.
export ZSH=/Users/ilyatimofeev/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="clean"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git bundler osx rake ruby)

# User configuration

# export PATH="/Users/ilyatimofeev/.rvm/gems/ruby-2.3.0/bin:/Users/ilyatimofeev/.rvm/gems/ruby-2.3.0@global/bin:/Users/ilyatimofeev/.rvm/rubies/ruby-2.3.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/ilyatimofeev/.rvm/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

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

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

# Helper function.
git_current_branch() {
  cat "$(git rev-parse --git-dir 2>/dev/null)/HEAD" | sed -e 's/^.*refs\/heads\///'
}
alias gpthis='gp --set-upstream origin $(git_current_branch)'

export EDITOR='vim'
export DISABLE_SPRING=1
export HUSKY_SKIP_HOOKS=1

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
# for ‘rspec’ instead of ‘bin/rspec’
export PATH="./bin:$PATH"

alias jrun=jrun.sh
