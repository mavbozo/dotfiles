install

```shell
git clone
cd dotfiles
git submodule init
git submodule update
cd submodules/xah-fly-keys
git checkout mavbozo
git pull origin mavbozo
mkdir -p ~/.lein
cd ~/.lein
ln -s ~/dotfiles/.lein/profiles.clj profiles.clj
cd ~/
ln -s dotfiles/.inputrc .inputrc
cd ~/
mkdir -p .ssh
cd .ssh
ln -s ~/dotfiles/.ssh/config 

```
