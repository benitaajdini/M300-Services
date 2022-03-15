# **Dokumentation LB2**

---

# Inhaltsverzeichnis

- [Einführung](#einführung)
- [Grafische Übersicht des Services](#grafische)
- [Code](#code)
	- [Code-Quelle](#code-quelle)
	- [Vagrantfile](#vagrantfile)
	- [Bootstrap.sh](#bootstrap)
- [Service Anwendung](#anwendung)
- [Service testen](#testen)

---

# Einführung

Ich habe mich für das Projekt **MySQL automatischen einrichten** entschieden.
Mein Projekt umfasst die Virtualisierung und Automatisierung die Einrichtung von Ubuntu zum 
Ausführen eines MySQL-Servers und die Installation der erforderlichen Abhängigkeiten und 
Konfigurationen, die erforderlich sind, damit der MySQL-Server ordnungsgemäß funktioniert.
Damit es angenehmer die MySQL-Datenbank und ihre Benutzer zu verwalten und zu konfigurieren
habe ich mich entschieden noch einen GUI mit einzubinden. Dazu verwenden ich das webbasierte 
phpmyadmin und die entsprechenden Webtools Apache2 und php7.

---
<a name="grafische"></a>
# Grafische Übersicht des Services

---

# Code

## Code-Quelle

Ich habe die Anleitung, [HIER](https://www.yourtechy.com/technology/mysql-server-vagrant-virtualbox/)
auf dieser Seite gefunden. Dort wird der Code für das vagrantfile und das bootstrap.sh aufgezeigt. 
Mein vagrantfile ist nur ein bisschen anders als das in der Anleitung.

Ich werde nun meine beiden files aufzeigen und erklären, was welcher Schritt macht. 

## Vagrantfile

Mein Vagrantfile sieht folgendermassen aus:


    Vagrant.configure("2") do |config|
    
      # General Vagrant VM configuration
      config.vm.box = "ubuntu/bionic64"

      config.vm.define "db-server" do |db|
        db.vm.network :forwarded_port, guest: 3306, host: 3306
        db.vm.network :forwarded_port, guest: 80, host: 3306
        db.vm.provision "shell", path: "bootstrap.sh"
      end

      # Adjustment for VM
      config.vm.provider :virtualbox do |vb|
        vb.customize [
            'modifyvm', :id,
            '--natdnshostresolver1', 'on',
            '--memory', '1024',
            '--cpus', '4'
        ] 
      end
    end



<a name="bootstrap"></a>
## Bootstrap.sh

Mein bootstrapfile sieht folgendermassen aus:

    #!/usr/bin/env bash

    DBHOST=localhost
    DBNAME=MySQL
    DBUSER=root
    DBPASSWD=root

    apt-get update
    apt-get install vim curl build-essential python-software-properties git
    debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"


    # install mysql and admin interface

    apt-get -y install mysql-server phpmyadmin

    mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
    mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'%' identified by '$DBPASSWD'"

    cd /vagrant

    #update mysql conf file to allow remote access to the db

    sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

    sudo service mysql restart


    # setup phpmyadmin

    apt-get -y install php apache2 libapache2-mod-php php-curl php-gd php-mysql php-gettext a2enmod rewrite

    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

    rm -rf /var/www/html
    ln -fs /vagrant/public /var/www/html

    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini

    service apache2 restart



---
<a name="anwendung"></a>
# Service Anwendung

---
<a name="testen"></a>
# Service teseten

---


