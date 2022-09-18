#!/bin/bash

service mysql start

mysql -u root -e "create database dvwa"; 

mysql -u root -e "grant all on dvwa.* to dvwa@localhost identified by 'p@ssw0rd'";

exec apachectl -D FOREGROUND