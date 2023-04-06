#!/bin/sh
[ -e "$HOME/.asdf" ] && exit 0

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3

printf 'source "$HOME/.asdf/asdf.sh"\n' | tee -a "$HOME/.bashrc"

printf 'source "$HOME/.asdf/completions/asdf.bash"\n' | tee -a "$HOME/.bashrc"
