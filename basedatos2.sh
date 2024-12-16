#!/bin/bash
sudo apt update

# Instalación de mariadb-server
echo "=========================================="
echo "Instalando el servidor de base de datos."
echo "=========================================="
sleep 1
sudo apt install -y mariadb-server

# Configuración de la base de datos
echo "=========================================="
echo "Configurando la base de datos."
echo "=========================================="
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
wsrep_node_address=192.168.20.202"  # Asegúrate de que esta IP sea la del nodo actual

if [ ! -f $HOME/.flag ]; then
    # Creo la bandera para evitar que la configuración se vuelva a ejecutar.
    sudo touch $HOME/.flag
    sudo chmod +t $HOME/.flag

    # Configuración 50-server.cnf 
    sudo systemctl stop mariadb
    echo "$configuracion" | sudo tee -a /etc/mysql/mariadb.conf.d/50-server.cnf

    sudo systemctl start mariadb

    # Creación de la base de datos y usuario para Joomla
    echo "==================================================="
    echo "Creando la base de datos y el usuario de Joomla."
    echo "==================================================="
    sleep 1
    sudo mysql -u root -e "CREATE DATABASE joomla_db;"
    sudo mysql -u root -e "CREATE USER 'joomla_user'@'192.168.20.%' IDENTIFIED BY 'joomla1234';"
    sudo mysql -u root -e "GRANT ALL PRIVILEGES ON joomla_db.* TO 'joomla_user'@'192.168.20.%';"
    sudo mysql -u root -e "FLUSH PRIVILEGES;"
    sudo mysql -u root -e "USE joomla_db; CREATE TABLE \`jos_extensions\` (
        \`extension_id\` int(10) unsigned NOT NULL AUTO_INCREMENT,
        \`name\` varchar(100) DEFAULT NULL,
        \`type\` varchar(20) DEFAULT NULL,
        \`element\` varchar(50) DEFAULT NULL,
        \`folder\` varchar(20) DEFAULT NULL,
        \`client_id\` tinyint(3) unsigned NOT NULL DEFAULT '0',
        \`enabled\` tinyint(3) unsigned NOT NULL DEFAULT '1',
        \`access\` int(10) unsigned NOT NULL DEFAULT '1',
        \`protected\` tinyint(3) unsigned NOT NULL DEFAULT '0',
        \`params\` text NOT NULL,
        \`ordering\` int(11) NOT NULL DEFAULT '0',
        \`state\` tinyint(3) unsigned NOT NULL DEFAULT '0',
        \`manifest_cache\` text NOT NULL,
        \`update_sites\` text NOT NULL,
        \`customizations\` text NOT NULL,
        \`system_data\` text NOT NULL,
        \`checked_out\` int(10) unsigned NOT NULL DEFAULT '0',
        \`checked_out_time\` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
        \`params_hash\` varchar(32) NOT NULL,
        PRIMARY KEY (\`extension_id\`),
        UNIQUE KEY (\`extension_id\`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;"


fi


    
sleep 1
# Denegar el acceso a internet
sudo ip route del default

echo "==============================================================================================="
echo "Despliegue finalizado. Para acceder a su Joomla visita http://localhost:9090 en su navegador"
echo "==============================================================================================="
sleep 5
