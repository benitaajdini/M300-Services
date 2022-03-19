DBHOST=localhost
DBNAME1=TBZ
DBNAME2=Modul300
DBROOTUSER=root
DBROOTPASSWD=root
DBUSER=testuser
DBPASSWD=test123
DBTABLECLASS=ST19d
DBTABLENOTEN=Noten

apt-get update
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBROOTPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBROOTPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBROOTPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBROOTPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBROOTPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"


apt-get -y install mysql-server phpmyadmin

mysql -uroot -p$DBROOTPASSWD -e "grant all privileges on $DBNAME1.* to '$DBROOTUSER'@'%' identified by '$DBROOTPASSWD'"
mysql -uroot -p$DBROOTPASSWD -e "grant all privileges on $DBNAME2.* to '$DBROOTUSER'@'%' identified by '$DBROOTPASSWD'"
mysql -uroot -p$DBROOTPASSWD -e "grant select on $DBNAME1.* to '$DBUSER'@'%' identified by '$DBPASSWD'"
mysql -uroot -p$DBROOTPASSWD -e "grant select on $DBNAME2.* to '$DBUSER'@'%' identified by '$DBPASSWD'"

mysql -uroot -p$DBROOTPASSWD <<%EOF%
	CREATE DATABASE $DBNAME1;
	CREATE DATABASE $DBNAME2;
	USE $DBNAME2;
	CREATE TABLE ST19d(SchuelerID INT, Name VARCHAR(20), Vorname VARCHAR(20), PRIMARY KEY (SchuelerID));
	CREATE TABLE Noten(NotenID INT(50), Prüfung VARCHAR(50), Note VARCHAR(50), SchuelerID INT(50), PRIMARY KEY (NotenID), FOREIGN KEY (SchuelerID) REFERENCES ST19d(SchuelerID));
	INSERT INTO $DBTABLECLASS VALUE (1,"Ajdini","Benita");
	INSERT INTO $DBTABLECLASS VALUE (2,"Istrefi","Meset");
	INSERT INTO $DBTABLECLASS VALUE (3,"Zgraggen","Mark");
	INSERT INTO $DBTABLENOTEN VALUE ("1","LB1", "5", "1");
	INSERT INTO $DBTABLENOTEN VALUE ("2","LB1", "6", "2");
	INSERT INTO $DBTABLENOTEN VALUE ("3","LB1", "5.5", "3");
	quit
%EOF%



cd /vagrant


sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo service mysql restart


service apache2 restart
