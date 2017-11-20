# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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
alias gsu="git submodule update"
alias gsur="git submodule update --remote"

export EDITOR='vim'

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
