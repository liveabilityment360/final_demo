#! /bin/bash
sudo apt upgrade
sudo apt -y install apache2
#apt-get update
sudo apt install git
sudo apt-get install apache2 php7.0
sudo apt-get -y install python3-pip
#sudo apt install python3-pip
sudo pip install google-cloud
sudo pip install google-cloud-pubsub
sudo python3 -m pip install --upgrade pip
sudo pip install apache-beam
sudo pip install apitools
sudo pip install api-base
sudo pip install --upgrade google-cloud-storage
cat <<EOF > /var/www/html/index.html
<html><body><p>Linux startup script from a local file.</p></body></html>