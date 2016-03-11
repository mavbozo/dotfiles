install

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
