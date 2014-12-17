#!/bin/bash

# upgrade packages
apt-get update && apt-get upgrade -y

# install curl
apt-get install curl -y

# add gpg for rvm signature
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

# install rvm 
curl -L get.rvm.io | bash -s stable

# create system environment
source /etc/profile.d/rvm.sh

# install a recent version of ruby
rvm reload
rvm install 2.1.5

# install javascript engine
gem install therubyracer

# install jekyll
gem install jekyll

# install RedCloth for textile support
gem install RedCloth

# add a script to start jekyll in detached mode
echo 'jekyll s --host 0.0.0.0 -w --drafts --future -s /vagrant -d /vagrant/_site --detach' > /home/vagrant/start_jekyll.sh
chown vagrant:vagrant /home/vagrant/start_jekyll.sh
chmod u+x /home/vagrant/start_jekyll.sh

