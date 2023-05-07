# Samuels dotfiles

### Bootstrapping

```
sudo dnf install neovim nodejs gcc-c++ golang libsqlite3x-devel ripgrep

rm -r ~/.config/nvim ~/.config/pycodestyle ~/.vimrc ~/.gitignore ~/.gitconfig ~/.bashrc

ln -sf ~/devel/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/devel/dotfiles/.config/pycodestyle ~/.config/pycodestyle
ln -sf ~/devel/dotfiles/.gitignore ~/.gitignore
ln -sf ~/devel/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/devel/dotfiles/.bashrc ~/.bashrc
```

### Other packages:

 * google chrome
 * gnome console
 * gnome extensions
   - vertical overview
   - launch new instance
 * gnome tweaks
 * epiphany
 * microsoft edge
 * cronie
 * slack
 * screenruler

### crontab

```
$ crontab -l
15 3 * * * /home/samuel/bin/gettlserver
20 3 * * * /home/samuel/bin/gettlclient
1 * * * * /usr/bin/rsync -r -u --delete /local/home/samuel/.vim/ /home/samuel/backup/.vim/
2 * * * * /usr/bin/rsync -r -u --delete /local/home/samuel/.config-nvim/ /home/samuel/backup/.config-nvim/
3 * * * * /usr/bin/rsync -r -u --delete /local/home/samuel/* /home/samuel/backup/
```

### Fonts

Install SourceCodePro:

```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/SourceCodePro.zip
unzip SourceCodePro.zip -d ~/.local/share/fonts/
```
