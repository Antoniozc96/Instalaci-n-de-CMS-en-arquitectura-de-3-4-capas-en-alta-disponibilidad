#!/bin/bash
sudo apt update
sleep 1

# Instalación de mariadb-server
sudo apt install -y mariadb-server
sleep 1

# Creación de la configuración para Galera
configuracion="
[galera]
wsrep_on                 = 1
wsrep_cluster_name       = \"MariaDB_Cluster\"
wsrep_provider           = /usr/lib/galera/libgalera_smm.so
wsrep_cluster_address    = gcomm://192.168.20.201,192.168.20.202
binlog_format            = row
default_storage_engine   = InnoDB
innodb_autoinc_lock_mode = 2

# Allow server to accept connections on all interfaces.
bind-address = 0.0.0.0
wsrep_node_address=192.168.20.202"  

if [ ! -f $HOME/.flag ]; then
    # Creación la bandera para evitar que la configuración se vuelva a ejecutar.
    sudo touch $HOME/.flag
    sudo chmod +t $HOME/.flag

    # Configuración 50-server.cnf 
    sudo systemctl stop mariadb
    echo "$configuracion" | sudo tee -a /etc/mysql/mariadb.conf.d/50-server.cnf

    sudo systemctl start mariadb

    # Creación de la base de datos y usuario para Joomla
    sudo mysql -u root -e "CREATE DATABASE joomla_db;"
    sudo mysql -u root -e "CREATE USER 'joomla_user'@'192.168.20.%' IDENTIFIED BY 'joomla1234';"
    sudo mysql -u root -e "GRANT ALL PRIVILEGES ON joomla_db.* TO 'joomla_user'@'192.168.20.%';"
    sudo mysql -u root -e "FLUSH PRIVILEGES;"
fi

# Denegar el acceso a internet
sudo ip route del default

echo "==============================================================================================="
echo "Despliegue finalizado. Para acceder a su Joomla visita http://localhost:9090 en su navegador"
echo "==============================================================================================="
sleep 5
