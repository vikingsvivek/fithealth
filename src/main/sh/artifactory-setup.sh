#!/bin/bash

sudo apt update -y 
sudo apt install -y apache2
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests
sudo systemctl restart apache2
sudo cp /tmp/repo.fithealth.com.conf /etc/apache2/sites-available/repo.fithealth.com.conf
cd /etc/apache2/sites-available
sudo a2ensite repo.fithealth.com
sudo systemctl reload apache2
sudo systemctl restart apache2
### Setup Artifactory
sudo mkdir -p $HOME/middleware
cd $HOME/middleware
sudo wget --no-check-certificate https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/[RELEASE]/jfrog-artifactory-oss-[RELEASE]-linux.tar.gz
sudo gunzip jfrog-artifactory-oss-[RELEASE]-linux.tar.gz
sudo tar -xvf jfrog-artifactory-oss-[RELEASE]-linux.tar
sudo rm -rf jfrog-artifactory-oss-[RELEASE]-linux.tar
sudo ./artifactory-oss-7.29.8/app/bin/artifactoryctl start