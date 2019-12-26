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

xmodmap ~/.Xmodmap

export PATH=~/.local/bin:$PATH

export DATOMIC_USERNAME=""
export DATOMIC_PASSWORD=""

alias "shadow-cljs-web-app-repl"="shadow-cljs -d cider/cider-nrepl:0.21.0 -d nrepl/nrepl:0.6.0 watch web-app"

alias "lein-mavbozo-repl"="lein with-profile +mavbozo repl"
