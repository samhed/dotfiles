# Samuels dotfiles

## Bootstrapping

Install required packages:
```
sudo dnf install neovim nodejs gcc-c++ golang libsqlite3x-devel ripgrep pip alacritty
pip install pynvim
```

Install font SourceCodePro:

```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/SourceCodePro.zip
unzip SourceCodePro.zip -d ~/.local/share/fonts/
```

Setup symlinks to deploy dotfiles:
```
rm -r ~/.config/nvim ~/.config/pycodestyle ~/.gitignore ~/.gitconfig ~/.bashrc ~/.alacritty.yml

ln -sf ~/devel/dotfiles/config/nvim ~/.config/nvim
ln -sf ~/devel/dotfiles/config/pycodestyle ~/.config/pycodestyle
ln -sf ~/devel/dotfiles/gitignore ~/.gitignore
ln -sf ~/devel/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/devel/dotfiles/bashrc ~/.bashrc
ln -sf ~/devel/dotfiles/alacritty.yml ~/.alacritty.yml
```

## Neovim usage

* Lazy plugin manager `:lazy`, `U`
* Treesitter update `:TSUpdate`
* LSP update `:CocUpdate`
* Keybindings `:WhichKey`
