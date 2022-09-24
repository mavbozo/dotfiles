if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi


PS1="[\[\033[32m\]\w]\[\033[0m\]\n\[\033[1;36m\]\u\[\033[1;33m\]-> \[\033[0m\\]"

# xmodmap ~/.Xmodmap

export PATH=~/.local/bin:$PATH

export DATOMIC_USERNAME=""
export DATOMIC_PASSWORD=""

alias "shadow-cljs-web-app-repl"="shadow-cljs -d cider/cider-nrepl:0.21.0 -d nrepl/nrepl:0.6.0 watch web-app"

alias "lein-mavbozo-repl"="lein with-profile +mavbozo repl"

export DISPLAY_NUMBER="0.0"
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):$DISPLAY_NUMBER

# enable passphrase prompt for gpg
export GPG_TTY=$(tty)

export MY_TODO_FILE=/mnt/c/Users/maver/SpiderOak/Archive/T/todo.txt
. "$HOME/.cargo/env"


# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
    eval "$("$BASE16_SHELL/profile_helper.sh")"

# Reset the cursor color.
PS1="$PS1\[\e]12;#c0c0c0\a\]"
