# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system : `git` and `stow`

You can use your favorite package manager, e.g. `pacman`, `brew`, etc...

## Create your `dotfiles` folder

```bash
# Create the folder
mkdir ~/dotfiles
cd ~/dotfiles

# Move all dotfiles to the folder (with a copy before)
# rename them with the `dot-` prefix instead of `.`.
# This has the advantage of having visible files and the `--dotfiles` options handles them
cp ~/.zshrc ~/.zshrc_bak
mv ~/.zshrc dot-zshrc
...

# Create the simlinks
stow --dotfiles .

# Manage your git repository
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/mygithub/dotfiles.git
git push -u origin main
```

## Installation of this configuration on another machine

First, check out the dotfiles repo in $HOME directory using git

```
$ git clone https://github.com/thomasarsouze/dotfiles.git
$ cd dotfiles
```

then rename all dotfile that will be imported

```
mv ~/.zshrc ~/.zshrc_bak
...
```

then use stow

```
$ stow --dotfiles .
```

## Ressources

`stow` main website : https://www.gnu.org/software/stow/manual/stow.html
Youtuve video with good explaination : https://www.youtube.com/watch?v=y6XCebnB9gs
