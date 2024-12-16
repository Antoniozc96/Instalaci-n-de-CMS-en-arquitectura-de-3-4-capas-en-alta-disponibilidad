#! /bin/bash
# Configuración para evitar problemas con fechas en repositorios archivados
echo 'Acquire::Check-Valid-Until "false";' | sudo tee /etc/apt/apt.conf.d/99no-check-valid-until

# Actualización de paquetes
sudo apt update && sudp apt upgrade

# Instalación de nginx
sudo apt install -y nginx

# Creación de la configuración del balanceador
configuracion="
upstream servidoresweb {
    server 10.0.10.101;
    server 10.0.10.102;
}
    
server {
    listen      80;
    server_name balanceador;

    location / {
        proxy_redirect      off;
        proxy_set_header    X-Real-IP \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    Host \$http_host;
        proxy_pass          http://servidoresweb;
    }
}"

# Borrado del archivo default de sites-enabled
if [ -f /etc/nginx/sites-enabled/default ]; then
    sudo rm /etc/nginx/sites-enabled/default
fi

# Creación del archivo de configuración del balanceador
if [ ! -f /etc/nginx/conf.d/balanceo.conf ]; then
    sudo touch /etc/nginx/conf.d/balanceo.conf

    # Edición del archivo de configuración para el balanceador
    echo "$configuracion" | sudo tee /etc/nginx/conf.d/balanceo.conf > /dev/null

    # Reinicio del servicio
    sudo systemctl restart nginx
fi
