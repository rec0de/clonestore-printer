#!/usr/bin/env bash
echo "Installing brother_ql..."
sudo pip install brother_ql
echo "Installing sinatra gem..."
sudo gem install sinatra
echo "Installing rqrcode gem..."
sudo gem install rqrcode
echo "Adding user to lp group..."
user="$(whoami)"
sudo usermod -a -G lp $user
echo "Attempting auto-config..."
ruby configure.rb