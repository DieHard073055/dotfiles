#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


PS1="\n\[\e[30;1m\]\[\016\]\[\017\](\[\e[34;1m\]\u@\h\[\e[30;1m\])-(\[\e[34;1m\]\j\[\e[30;1m\])-(\[\e[34;1m\]\@ \d\[\e[30;1m\])->\[\e[30;1m\]\n\[\016\]\[\017\](\[\[\e[32;1m\]\w\[\e[30;1m\])-(\[\e[32;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[30;1m\])--> \[\e[0m\]"

# turn on vi mode
set -o vi

# my aliases
alias ls='ls --color=auto'
alias vi="vim"
# alias all config files
alias rfbash="source ~/.bashrc"
alias bashrc="vim ~/.bashrc"
alias vimrc="vim ~/.vimrc"
alias i3rc="vim ~/.config/i3/config"
alias rangerrc="vim ~/.config/ranger/rc.conf"
alias urxvtrc="vim ~/.Xresources"
alias rfurxvt="xrdb ~/.Xresources"
alias djangosw="cd /home/eshan/dev/w/web/django-switchdin/switchdin; source /home/eshan/dev/w/web/django-switchdin/venv/bin/activate"
alias pixel="/home/eshan/Android/Sdk/emulator/emulator -avd Pixel_2_XL_API_27_2"


# exports
# Set Editor as vim
export REACT_EDITOR=vim

export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend
export PROMPT_COMMAND='history -a'

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
