DBHOST=localhost
DBNAME1=Modul300
DBNAME2=TBZ
DBROOTUSER=root
DBROOTPASSWD=root
DBUSER=testuser
DBPASSWD=test123

apt-get update
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBROOTPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBROOTPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBROOTPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBROOTPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBROOTPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"


apt-get -y install mysql-server phpmyadmin

mysql -uroot -p$DBROOTPASSWD -e "CREATE DATABASE $DBNAME1"
mysql -uroot -p$DBROOTPASSWD -e "CREATE DATABASE $DBNAME2"
mysql -uroot -p$DBROOTPASSWD -e "grant all privileges on $DBNAME1.* to '$DBROOTUSER'@'%' identified by '$DBROOTPASSWD'"
mysql -uroot -p$DBROOTPASSWD -e "grant all privileges on $DBNAME2.* to '$DBROOTUSER'@'%' identified by '$DBROOTPASSWD'"
mysql -uroot -p$DBROOTPASSWD -e "grant select on $DBNAME1.* to '$DBUSER'@'%' identified by '$DBPASSWD'"
mysql -uroot -p$DBROOTPASSWD -e "grant select on $DBNAME2.* to '$DBUSER'@'%' identified by '$DBPASSWD'"

cd /vagrant


sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo service mysql restart


service apache2 restart
