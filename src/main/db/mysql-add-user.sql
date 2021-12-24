create user 'fithealthuser'@'%' IDENTIFIED BY 'welcome1';
grant all privileges ON *.* to 'fithealthuser'@'%';
flush privileges;