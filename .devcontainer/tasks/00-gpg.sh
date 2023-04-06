#!/bin/sh
echo 'export GPG_TTY=$(tty)' | tee -a "$HOME/.bashrc"
echo 'export GPG_TTY=$(tty)' | tee -a "$HOME/.bash_profile"
echo 'export GPG_TTY=$(tty)' | tee -a "$HOME/.profile"
