# Samuels dotfiles

## Requirements

* Neovim v0.9
* Node.JS v18
* GitHub Copilot (optional)

## Installation

Install required packages:
```
sudo dnf install neovim nodejs gcc-c++ golang libsqlite3x-devel ripgrep pip util-linux-user fish
pip install pynvim
```

Configure fish shell (and set theme):
```
chsh -s /usr/bin/fish
curl -L https://get.oh-my.fish | fish
omf install bobthefish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install rkbk60/onedark-fish
```

Install font SourceCodePro:

```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/SourceCodePro.zip
unzip SourceCodePro.zip -d ~/.local/share/fonts/
```

Clone this repo:
```
mkdir ~/devel/dotfiles
git clone https://github.com/samhed/dotfiles.git ~/devel/dotfiles
```

Setup symlinks to deploy dotfiles (note that this will remove
any pre-existing configuration covered by these dotfiles):
```
rm -r ~/.config/nvim ~/.config/pycodestyle ~/.gitignore ~/.gitconfig ~/.bashrc ~/.bash_profile ~/.bash_logout

ln -sf ~/devel/dotfiles/config/nvim ~/.config/nvim
ln -sf ~/devel/dotfiles/config/fish ~/.config/fish
ln -sf ~/devel/dotfiles/config/pycodestyle ~/.config/pycodestyle
ln -sf ~/devel/dotfiles/gitignore ~/.gitignore
ln -sf ~/devel/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/devel/dotfiles/bashrc ~/.bashrc
ln -sf ~/devel/dotfiles/bash_logout ~/.bash_logout
ln -sf ~/devel/dotfiles/bash_profile ~/.bash_profile
```

## Neovim usage

* Lazy plugin manager `:lazy`, `U`
* Treesitter update `:TSUpdate`
* LSP update `:CocUpdate`
* Keybindings `:WhichKey`
