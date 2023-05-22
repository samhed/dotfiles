# Samuels dotfiles

## Requirements

* Neovim v0.9
* Node.JS v18
* GitHub Copilot (optional)

## Bootstrapping

Install required packages:
```
sudo dnf install neovim nodejs gcc-c++ golang libsqlite3x-devel ripgrep fzf pip
pip install pynvim
```

Install font SourceCodePro:

```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/SourceCodePro.zip
unzip SourceCodePro.zip -d ~/.local/share/fonts/
```

Clone this repo and update submodules:
```
mkdir ~/devel/dotfiles
git clone https://github.com/samhed/dotfiles.git ~/devel/dotfiles
cd ~/devel/dotfiles
git submodules update --init --recursive
```

Setup symlinks to deploy dotfiles (note that this will remove
any pre-existing configuration covered by these dotfiles):
```
rm -r ~/.config/nvim ~/.config/pycodestyle ~/.gitignore ~/.gitconfig ~/.bashrc

ln -sf ~/devel/dotfiles/config/nvim ~/.config/nvim
ln -sf ~/devel/dotfiles/config/pycodestyle ~/.config/pycodestyle
ln -sf ~/devel/dotfiles/gitignore ~/.gitignore
ln -sf ~/devel/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/devel/dotfiles/bashrc ~/.bashrc
```

## Neovim usage

* Lazy plugin manager `:lazy`, `U`
* Treesitter update `:TSUpdate`
* LSP update `:CocUpdate`
* Keybindings `:WhichKey`
