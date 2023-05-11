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

### Fonts

Install SourceCodePro:

```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/SourceCodePro.zip
unzip SourceCodePro.zip -d ~/.local/share/fonts/
```
