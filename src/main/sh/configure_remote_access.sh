#!/bin/bash

sudo sed -i "s/^bind-address.*/bind-address=0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf

#sudo mysql -uroot -pwelcome#123 -e "create user 'fithealthuser'@'%' IDENTIFIED BY 'welcome1';"
#sudo mysql -uroot -pwelcome#123 -e "grant all privileges ON *.* to 'fithealthuser'@'%';"
#sudo  mysql -uroot -pwelcome#123 -e "flush privileges;"

sudo mysql -uroot -pwelcome123 < /tmp/mysql-add-user.sql
sudo mysql -uroot -pwelcome123 < /tmp/db-schema.sql

sudo systemctl restart mysql