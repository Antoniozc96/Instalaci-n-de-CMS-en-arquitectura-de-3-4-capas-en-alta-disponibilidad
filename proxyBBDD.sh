
#!/bin/bash
sudo apt update
sleep 1

# Instalación de nginx
sudo apt install -y nginx

# Configuración del Balanceador
sleep 1

# Creación de la configuración
configuracion="
stream {
    upstream servidoresdb {
        server 192.168.20.201:3306;
        server 192.168.20.202:3306;
    }

    server {
        listen 3306;
        proxy_pass servidoresdb;
        proxy_connect_timeout 3s;
        proxy_timeout 10s;
    }
}"

# Borrado del archivo default de site-enabled
if [ -f /etc/nginx/sites-enabled/default ]; then
    sudo rm /etc/nginx/sites-enabled/default

    # Edición del archivo de configuración para el balanceador 
    echo "$configuracion" | sudo tee -a /etc/nginx/nginx.conf

    # Reinicio del servicio
    sudo systemctl restart nginx
fi

# Denegar el acceso a internet
sudo ip route del default
