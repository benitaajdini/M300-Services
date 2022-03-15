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

Ich habe die Anleitung [HIER](https://www.yourtechy.com/technology/mysql-server-vagrant-virtualbox/)
auf dieser Seite gefunden.

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

---


