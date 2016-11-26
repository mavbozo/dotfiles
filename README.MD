install

```shell
git clone
cd dotfiles
git submodule init
git submodule update
cd submodules/xah-fly-keys
git checkout master
git pull origin master
mkdir -p ~/.lein
cd ~/.lein
ln -s ~/dotfiles/.lein/profiles.clj profiles.clj
cd ~/
ln -s dotfiles/.inputrc .inputrc
ln -s dotfiles/.Xmodmap .Xmodmap
ln -s dotfiles/.bash_profile .bash_profile
cd ~/
mkdir -p .ssh
cd .ssh
ln -s ~/dotfiles/.ssh/config 
source ~/dotfiles/submodules/base16-gnome-terminal/base16-default.dark.sh 
```
