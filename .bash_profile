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

# bash prompt
PS1="[\[\033[32m\]\w]\[\033[0m\]\n\[\033[1;36m\]\u\[\033[1;33m\]-> \[\033[0m\\]"
# Reset the cursor color.
PS1="$PS1\[\e]12;#c0c0c0\a\]"

# xmodmap ~/.Xmodmap

export PATH=~/.local/bin:$PATH

if [ -e /home/mavbozo/.nix-profile/etc/profile.d/nix.sh ]; then . /home/mavbozo/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export XDG_CONFIG_HOME="$HOME/.config"
