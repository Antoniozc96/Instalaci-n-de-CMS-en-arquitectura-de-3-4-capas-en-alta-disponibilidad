#!/bin/bash

# Actualizar repositorios e instalar MariaDB
sudo apt-get update -y
sudo apt-get install -y mariadb-server

# Configurar MariaDB para permitir acceso remoto desde los servidores web
sed -i 's/bind-address.*/bind-address = 192.168.30.10/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Reiniciar MariaDB
sudo systemctl restart mariadb

# Crear base de datos y usuario para OwnCloud
mysql -u root <<EOF
CREATE DATABASE owncloud;
CREATE USER 'owncloud'@'192.168.30.%' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'192.168.30.%';
FLUSH PRIVILEGES;
EOF

#Eliminar puerta de enlace por defecto de Vagrant
sudo ip route del default 
