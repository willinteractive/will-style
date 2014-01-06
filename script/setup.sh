#!/bin/sh

echo "Installing Gems"
echo "==============="
echo "  running bundler..."
bundle install
echo "==============="
echo "done!"

echo "Setting Up Rails"
rake rails:update:bin

echo ""
echo "Reseting Database"
echo "================="
echo "  dropping databases..."
rake db:drop
echo "  creating databases..."
rake db:setup
rake db:setup RAILS_ENV=test
#rake db:fixtures:load
echo "================="
echo "done!"

echo ""
echo "Adding app to pow & restarting"
echo "======================="
echo "  Adding symlink..."
ln -s $PWD/ ~/.pow/will-style

echo "  restart..."
touch tmp/restart.txt
echo "================="
echo "done!"
