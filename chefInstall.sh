#!/bin/bash

echo BEGIN
sudo apt-get update

sudo echo $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) | xargs sudo hostname

sudo apt-get install -y wget
wget https://packages.chef.io/files/stable/chef-server/12.16.2/ubuntu/16.04/chef-server-core_12.16.2-1_amd64.deb
sudo dpkg -i chef-server*

sudo chef-server-ctl reconfigure
sudo chef-server-ctl status
sudo chef-server-ctl test

sudo mkdir .chef
sudo chef-server-ctl user-create admin harish chander admin@agilityroots.com password -f /vagrant/admin.pem
sudo chef-server-ctl org-create agilityroots "harish chander" --association_user admin -f /vagrant/agility.pem

sudo chef-server-ctl install chef-manage 
sudo chef-server-ctl reconfigure
sudo chef-manage-ctl reconfigure --accept-license

sudo chef-server-ctl install opscode-push-jobs-server
sudo chef-server-ctl reconfigure
sudo opscode-push-jobs-server-ctl reconfigure

sudo chef-server-ctl install opscode-reporting
sudo chef-server-ctl-reconfigure
sudo opscode-reporting-ctl reconfigure --accept-license

sudo chef-manage-ctl restart
sudo chef-server-ctl restart

ip=`curl ifconfig.me`
echo "your Chef Server URL = $ip"
echo "USERNAME=admin"
echo "PASSWORD=password"

echo DONE
