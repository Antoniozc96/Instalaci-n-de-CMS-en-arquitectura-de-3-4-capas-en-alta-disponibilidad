#!/bin/bash
sudo apt update && sudp apt upgrade
sleep 1

# Instalación de nfs-kernel-server y PHP
sudo apt install -y nfs-kernel-server nfs-common php7.4-fpm php7.4-imagick php7.4-common php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-pgsql php7.4-ssh2 php7.4-sqlite3 php7.4-xml php7.4-zip

# Creación del directorio compartido
if [ ! -d /var/nfs/joomla ]; then
    sudo mkdir -p /var/nfs/joomla
    sudo chown -R nobody:nogroup /var/nfs/joomla
    sudo chmod -R 755 /var/nfs/joomla
    echo "/var/nfs/joomla     172.16.0.101(rw,sync,no_subtree_check) 172.16.0.102(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
    sudo systemctl restart nfs-kernel-server
fi

# Configuración de php-fpm e instalación de Joomla
if [ ! -f $HOME/.flag ]; then
    # Creo la bandera para evitar que se vuelva a ejecutar la configuración.
    sudo touch $HOME/.flag
    sudo chmod +t $HOME/.flag

    # Editar la directiva listen de fpm
    sudo sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 172.16.0.100:9000|' /etc/php/7.4/fpm/pool.d/www.conf

    # Instalación de Joomla
    sudo apt install -y wget
    sudo apt-get install zip unzip
    sudo wget https://downloads.joomla.org/cms/joomla4/4-0-0/Joomla_4-0-0-Stable-Full_Package.tar.gz
    sudo tar -xzvf Joomla_4-0-0-Stable-Full_Package.tar.gz -C /var/nfs/joomla

    # Editar configuration.php
    sudo cp /var/nfs/joomla/installation/configuration.php-dist /var/nfs/joomla/configuration.php
    #sudo sed -i "s/public \$host\s*=.*/public \$host = '172.16.0.200';/" /var/nfs/joomla/configuration.php
    #sudo sed -i "s/public \$user\s*=.*/public \$user = 'joomla_user';/" /var/nfs/joomla/configuration.php
    #sudo sed -i "s/public \$password\s*=.*/public \$password = 'joomla1234';/" /var/nfs/joomla/configuration.php
    #sudo sed -i "s/public \$db\s*=.*/public \$db = 'joomla_db';/" /var/nfs/joomla/configuration.php

    # Transferir propiedad
    sudo chown -R www-data:www-data /var/nfs/joomla
    sudo chmod -R 755 /var/nfs/joomla

    # Reinicio del servicio
    sudo systemctl restart php7.4-fpm
fi

# Denegar el acceso a internet
sudo ip route del default

