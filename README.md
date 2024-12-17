# Instalaci-n-de-CMS-en-arquitectura-de-3-4-capas-en-alta-disponibilidad


![Diagrama1](https://github.com/user-attachments/assets/40335b9e-91c1-450d-b4d7-2ac9d5993b46)

# Índice

1. [Introducción](#1-introducción)  
2. [Requisitos previos](#2-requisitos-previos)  
3. [Roles de las máquinas](#3-roles-de-las-máquinas)  
4. [Estructura por Capas de la Infraestructura](#4-estructura-por-capas-de-la-infraestructura)  
5. [Preparar el Vagrantfile](#5-preparar-el-vagrantfile)  
6. [Iniciar Vagrant y ejecutar los scripts de provisión](#6-iniciar-vagrant-y-ejecutar-los-scripts-de-provisión)  
7. [Acceder a OwnCloud](#7-acceder-a-owncloud)  

---

## 1. Introducción

Este proyecto consiste en crear un entorno virtualizado para instalar y configurar **OwnCloud**, una plataforma de almacenamiento y colaboración en la nube. La infraestructura estará compuesta por varias máquinas virtuales gestionadas con **Vagrant**, cada una con un rol específico:

- **Balanceador de carga**
- **Servidor NFS**
- **Servidores web**
- **Base de datos**

Se emplearán **scripts de configuración automatizada** para garantizar que la instalación sea consistente y reproducible.

### Direccionamiento IP de la Infraestructura:  

#### Balanceador
- **192.168.56.2 e IP pública automática**

#### Servidor NFS
- **192.168.56.12 y 192.168.60.13**

#### Servidor web 1
- **192.168.56.10 y 192.168.60.11**

#### Servidor web 2
- **192.168.56.11 y 192.168.60.12**

#### Servidor de base de datos  
- **192.168.60.10**

---

## 2. Requisitos previos

Para implementar la infraestructura, se necesitan los siguientes elementos:

- **Vagrant** instalado en la máquina anfitriona.  
- **VirtualBox** como herramienta de virtualización.  
- Una imagen de **Debian**.  
- **Conexión a internet** para descargar paquetes necesarios.  

---

## 3. Roles de las máquinas

1. **Balanceador de carga**  
   Administra y distribuye el tráfico hacia los servidores web.

2. **Servidor NFS**  
   Proporciona almacenamiento compartido para los servidores web.  

3. **Servidores web**  
   Ejecutan **OwnCloud** y acceden al almacenamiento compartido proporcionado por el servidor NFS.  

4. **Servidor de base de datos**  
   Aloja la base de datos **MariaDB**, necesaria para el funcionamiento de OwnCloud.  

---

## 4. Estructura por Capas de la Infraestructura

### Capa 1: Expuesta a la red pública  
- **Máquina:** `balanceadorZancadaAntonio`  
- **Rol:** Balanceador de carga basado en **Nginx**.  
- **Función:** Redirige el tráfico entrante desde la red pública hacia los servidores web en la Capa 2.

### Capa 2: BackEnd  
- **Máquinas:**  
  - `serverweb1ZancadaAntonio`  
  - `serverweb2ZancadaAntonio`  
- **Rol:** Cada máquina ejecuta un **servidor web Nginx**.  
- **Función:** Procesar y servir las solicitudes de los usuarios a través del balanceador de carga.  

- **Máquina adicional:** `serverNFSZancadaAntonio`  
  - **Rol:** Proporciona un sistema de archivos compartido con **NFS** y ejecuta **PHP-FPM**.  
  - **Función:** Facilita el acceso al almacenamiento compartido y la ejecución del código PHP de OwnCloud.

### Capa 3: Datos  
- **Máquina:** `serverdatosZancadaAntonio`  
- **Rol:** Servidor de base de datos **MariaDB**.  
- **Función:** Almacenar y gestionar los datos requeridos por OwnCloud.  

---

## 5. Preparar el Vagrantfile  

Configura el archivo `Vagrantfile` siguiendo los pasos establecidos. Es importante que las máquinas se inicien en el siguiente orden:  
   - Base de datos  
   - Servidor NFS  
   - Servidores web  
   - Balanceador de carga  

Asegúrate de utilizar preferiblemente la imagen `debian/bullseye64` para todas las máquinas.

---

## 6. Iniciar Vagrant y ejecutar los scripts de provisión  

Desde la terminal, ejecuta uno de los siguientes comandos:  
   - `vagrant up --provision` para iniciar las máquinas y aplicar las configuraciones en un solo paso.  
   - O bien, primero `vagrant up` para iniciar las máquinas, seguido de `vagrant provision` para aplicar los scripts de configuración.

---

## 7. Acceder a OwnCloud  

- Conéctate a la máquina del balanceador usando `vagrant ssh balanceador`.  
- Ejecuta el comando `ip a` para identificar la IP pública asignada al balanceador.  
- Abre un navegador y accede a: `http://<ip_pública_balanceador>/owncloud`.  
- Ingresa tus credenciales de administrador para iniciar sesión.

# RESULTADO FINAL
![imagen](https://github.com/user-attachments/assets/f0f9b986-55d3-4b71-9ace-c0579304ce72)

# Después de poner las credenciales: 
![imagen](https://github.com/user-attachments/assets/66c3294a-6ca5-41d6-a1dc-026c8f474e1f)





