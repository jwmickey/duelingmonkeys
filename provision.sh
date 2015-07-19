#!/bin/bash

# upgrade packages
apt-get update && apt-get upgrade -y

# install some packages
apt-get install curl git nodejs npm libmagickwand-dev -y

# symlink node to nodejs
ln -s /usr/bin/nodejs /usr/bin/node

# install bower
npm install -g bower

# add gpg for rvm signature
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

# install rvm 
curl -L get.rvm.io | bash -s stable

# create system environment
source /etc/profile.d/rvm.sh

# install a recent version of ruby
rvm reload
rvm install 2.1.5

# install gems
bundle install

# install bower assets
bower install --config.interactive=false

# add a script to start jekyll in detached mode
echo 'jekyll s --host 0.0.0.0 -w --drafts --future -s /vagrant -d /vagrant/_site --detach' > /home/vagrant/start_jekyll.sh
chown vagrant:vagrant /home/vagrant/start_jekyll.sh
chmod u+x /home/vagrant/start_jekyll.sh

