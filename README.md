# Instalaci-n-de-CMS-en-arquitectura-de-3-4-capas-en-alta-disponibilidad
# Índice

1. [Introducción](#introducción)  
2. [Requisitos previos](#requisitos-previos)  
3. [Estructura de la Infraestructura y Direccionamiento IP](#estructura-de-la-infraestructura-y-direccionamiento-ip)  
4. [Roles de las máquinas](#roles-de-las-máquinas)  

---

## 1. Introducción

Este proyecto consiste en crear un entorno virtualizado para instalar y configurar **OwnCloud**, una plataforma de almacenamiento y colaboración en la nube. La infraestructura estará compuesta por varias máquinas virtuales gestionadas con **Vagrant**, cada una con un rol específico:

- **Balanceador de carga**
- **Base de datos**
- **Servidor NFS**
- **Servidores web**

Se emplearán **scripts de configuración automatizada** para garantizar que la instalación sea consistente y reproducible.

### Direccionamiento IP de la Infraestructura:
##  Balanceador
-  **192.168.56.2 e IP pública automática**

## Servidor NFS
- **192.168.56.12 y 192.168.60.13**
## Servidor web 1

- **192.168.56.10 y 192.168.60.11**

## Servidor web 2
- **192.168.56.11 y 192.168.60.12**

Servidor de base de datos  
- **192.168.60.10**

---

## 2. Requisitos previos

Para implementar la infraestructura, se necesitan los siguientes elementos:

- **Vagrant** instalado en la máquina anfitriona.  
- **VirtualBox** como herramienta de virtualización.  
- Una imagen de **Debian**.  
- **Conexión a internet** para descargar paquetes necesarios.  

---

## 3. Estructura de la Infraestructura y Direccionamiento IP


## 3. Roles de las máquinas

1. **Balanceador de carga**  
   Administra y distribuye el tráfico hacia los servidores web.

2. **Servidor NFS**  
   Proporciona almacenamiento compartido para los servidores web.  

3. **Servidores web**  
   Ejecutan **OwnCloud** y acceden al almacenamiento compartido proporcionado por el servidor NFS.  

4. **Servidor de base de datos**  
   Aloja la base de datos **MariaDB**, necesaria para el funcionamiento de OwnCloud.  



