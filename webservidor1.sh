
#!/bin/bash
sudo apt update
sleep 1

# Instalación de nginx y módulos de php
sudo apt install -y nginx
sudo apt install -y nfs-kernel-server nfs-common php7.4-fpm php7.4-imagick php7.4-common php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-pgsql php7.4-ssh2 php7.4-sqlite3 php7.4-xml php7.4-zip

# Instalación de nfs-common
sudo apt install -y nfs-common

# Creación de punto de montaje
if [ ! -d /var/nfs/joomla ]; then
    sudo mkdir -p /var/nfs/joomla
fi
sudo mount 172.16.0.100:/var/nfs/joomla /var/nfs/joomla

# Configuración de nginx
joomla="
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/nfs/joomla;

        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                try_files \$uri \$uri/ =404;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass 172.16.0.100:9000;
        }
        location ~ /\.ht {
                deny all;
        }
}"

if [ -f /etc/nginx/sites-enabled/default ]; then
    # Eliminación del site predeterminado y creación del site de Joomla
    sudo rm /etc/nginx/sites-enabled/default
    sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/joomla
    
    # Configuración y activación del site
    echo "$joomla" | sudo tee /etc/nginx/sites-available/joomla
    sudo ln -s /etc/nginx/sites-available/joomla /etc/nginx/sites-enabled/

    # Reinicio del servicio
    sudo systemctl restart nginx
fi

# Denegar el acceso a internet
sudo ip route del default
