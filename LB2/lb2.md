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




| Code| Beschreibung|
| --------------| -----------------|
| Vagrant.configure("2") do |config| | Diese Zeile im Code beschreibt die API Version, in diesem Fall die Nummer 2, vom Vagrantfile. In diesem Block beschreibe ich dann die Konfigurationen die ich vornehmen werde.  |
| config.vm.box | Hier habe musste ich mich für ein Betirebssystem entscheiden, welches ich auf dem VM laufen haben möchte. |
| db.vm.network | Da definiere ich den Port auf welchen dann die VM zugreift. In diesem Fall wäre es für MySQL Port 3306 und für die web applikation phpmyadmin Port 80.  |
| db.vm.provision | In diesem Schritt erlaube ich die Ausführung von einem Shell Skript nachdem das Guest OS gebootet hat. |
| config.vm.provider :virtualbox do |vb| | Hier definiere ich den Provider der VM, in diesem Fall Virtualbox. Zusätzlich habe ich noch Anpassungen gemacht, z.b mehr RAM und CPUs. |



<a name="bootstrap"></a>
## Bootstrap.sh

Mein bootstrapfile sieht folgendermassen aus:

    DBHOST=localhost
    DBNAME1=Modul300
    DBNAME2=TBZ
    DBROOTUSER=root
    DBROOTPASSWD=root
    DBUSER=testuser
    DBPASSWD=test123

    apt-get update
    apt-get install curl build-essential
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



| Ausgabe       | Eingabe          |
| --------------| -----------------|
| DBHOST=localhost | Ganz am Anfang habe ich die Variablen definiert, die ich dann später im Code einsetzten werde. Ich habe zum einen den Datenbank Host und Namen definiert sowie den Datenbank User und Passwort.  |
| apt-get install curl build-essential | `## Überschrift` |
| Überschrift 3 | `### Überschrift`|
| Überschrift 3 | `### Überschrift`|
| Überschrift 3 | `### Überschrift`|
| Überschrift 3 | `### Überschrift`|
| Überschrift 3 | `### Überschrift`|
| Überschrift 3 | `### Überschrift`|


---
<a name="anwendung"></a>
# Service Anwendung

---
<a name="testen"></a>
# Service testen

---


