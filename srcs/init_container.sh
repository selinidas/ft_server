#!/bin/sh

service php7.3-fpm start
service mysql start
service nginx start
mysql -e "
create database wordpress;
create user root@localhost identified by 'password';
grant all privileges on wordpress.* to 'root@'localhost';
flush privileges;"
/bin/sh