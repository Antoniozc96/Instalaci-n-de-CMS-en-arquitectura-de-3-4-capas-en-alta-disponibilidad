# Instalaci-n-de-CMS-en-arquitectura-de-3-4-capas-en-alta-disponibilidad


# Índice

1. [Introducción](#1-introducción)  
2. [Requisitos previos](#2-requisitos-previos)  
3. [Roles de las máquinas](#3-roles-de-las-máquinas)  
4. [Estructura por Capas de la Infraestructura](#4-estructura-por-capas-de-la-infraestructura)  
5. [Preparar el Vagrantfile](#5-preparar-el-vagrantfile)  
6. [Iniciar Vagrant y ejecutar los scripts de provisión](#6-iniciar-vagrant-y-ejecutar-los-scripts-de-provisión)  
7. [Acceder a OwnCloud](#7-acceder-a-owncloud)  
8. [Conclusión](#8-conclusión)  

---

## Introducción

Este proyecto tiene como objetivo la creación de un entorno virtualizado dedicado a la instalación y configuración de **OwnCloud**, una plataforma de almacenamiento y colaboración en la nube. **OwnCloud** permite a los usuarios almacenar, compartir y colaborar en archivos de forma segura y eficiente, y se ha convertido en una de las soluciones más populares para la gestión de datos en la nube en entornos corporativos y personales.

Para llevar a cabo esta implementación, se utilizará una infraestructura compuesta por varias máquinas virtuales gestionadas con **Vagrant**. **Vagrant** es una herramienta que facilita la creación y administración de entornos virtuales de desarrollo, lo que permite automatizar la configuración de las máquinas virtuales de manera sencilla y reproducible. En este caso, se aprovecharán sus capacidades para gestionar la infraestructura de **OwnCloud**.

La infraestructura estará organizada en varias capas que se asignarán a diferentes máquinas virtuales, cada una de las cuales tendrá un rol específico. Esto proporciona una mayor escalabilidad, flexibilidad y seguridad, ya que cada componente de la arquitectura está aislado y puede ser modificado de forma independiente sin afectar a los demás.

### Componentes de la infraestructura

A continuación, se detallan los roles que tendrán las distintas máquinas virtuales dentro de este entorno:

1. **Balanceador de carga**  
   El balanceador de carga es un componente clave en la infraestructura, ya que su función principal es distribuir el tráfico entrante entre los servidores web. Esto asegura que el sistema pueda manejar múltiples solicitudes simultáneamente sin que ningún servidor individual se sobrecargue. En este caso, se utilizará **Nginx** como balanceador de carga, un servidor web ligero y altamente eficiente que permite una distribución eficiente de las solicitudes.

2. **Servidor NFS (Network File System)**  
   El servidor **NFS** se encargará de proporcionar almacenamiento compartido para los servidores web. **NFS** es un protocolo que permite que una máquina virtual acceda a los archivos de otra máquina a través de la red. En este proyecto, el servidor **NFS** permitirá a los servidores web compartir los mismos archivos y asegurará que las actualizaciones en los archivos sean reflejadas instantáneamente en todas las instancias de la aplicación **OwnCloud**.

3. **Servidores web**  
   Los servidores web son las máquinas encargadas de ejecutar la aplicación **OwnCloud** y manejar las solicitudes de los usuarios. Cada servidor web se conectará al servidor **NFS** para acceder al almacenamiento compartido y servirá los archivos a los usuarios. Los servidores web ejecutarán **Nginx** como servidor HTTP y **PHP-FPM** para manejar la ejecución de los scripts PHP, que es el lenguaje utilizado por **OwnCloud**.

4. **Base de datos**  
   El servidor de base de datos será responsable de almacenar toda la información estructurada de **OwnCloud**, como los datos de los usuarios, configuraciones y metadatos de los archivos. Para este proyecto, se utilizará **MariaDB**, una base de datos de código abierto y altamente confiable, compatible con **MySQL**. La base de datos estará diseñada para soportar un gran volumen de operaciones de lectura y escritura, asegurando que la aplicación funcione de manera eficiente incluso cuando se gestionen grandes cantidades de datos.

### Objetivo y ventajas de la arquitectura

La separación de estos roles en diferentes máquinas virtuales proporciona varios beneficios importantes:

- **Escalabilidad**: Cada componente puede escalar de forma independiente. Por ejemplo, si se incrementa el número de usuarios o el volumen de datos, es posible añadir más servidores web sin necesidad de modificar la infraestructura completa.
  
- **Flexibilidad**: Al tener cada servicio en una máquina virtual separada, se pueden hacer cambios o actualizaciones en un servicio sin afectar a los demás. Esto facilita el mantenimiento y la evolución de la infraestructura a lo largo del tiempo.

- **Redundancia y fiabilidad**: Al utilizar un balanceador de carga y servidores web distribuidos, la infraestructura se vuelve más resistente a fallos. Si un servidor web falla, el balanceador de carga puede redirigir el tráfico a otros servidores disponibles, garantizando que el servicio continúe funcionando sin interrupciones.

- **Gestión centralizada de datos**: El uso de un servidor **NFS** centralizado facilita la administración de los archivos y la sincronización de datos entre los servidores web. Los archivos están almacenados en un solo lugar y pueden ser accedidos desde cualquier servidor web en la infraestructura.

- **Automatización**: La utilización de **Vagrant** permite la automatización de la creación y configuración de todas las máquinas virtuales, lo que facilita la implementación y hace que el entorno sea reproducible en cualquier otra máquina. Esto es particularmente útil para entornos de desarrollo, pruebas y producción.

En resumen, este proyecto no solo se centra en la instalación de **OwnCloud**, sino también en la construcción de una infraestructura sólida y escalable para soportar su funcionamiento de manera eficiente. Utilizando herramientas como **Vagrant** y **Nginx**, podemos asegurar una configuración automatizada y una gestión simplificada, lo que permite que el entorno crezca y se adapte a las necesidades cambiantes de los usuarios.

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

En mi caso la imagen `debian/bullseye64` para todas las máquinas.

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

---

## 8. Conclusión

En esta práctica, hemos aprendido a configurar un entorno virtualizado para implementar **OwnCloud** utilizando **Vagrant** y **scripts automatizados**. A través de la separación de roles en diferentes máquinas, hemos logrado garantizar una infraestructura escalable y flexible. El uso de un balanceador de carga permite distribuir el tráfico entre los servidores web, lo que mejora la disponibilidad y el rendimiento de la aplicación. 

Además, la integración de un servidor NFS centralizado como almacenamiento compartido facilita la gestión de los datos, permitiendo que los servidores web accedan a los mismos archivos sin importar en qué servidor estén alojados. Esta arquitectura no solo mejora la eficiencia, sino que también proporciona un alto grado de redundancia y escalabilidad, lo que es fundamental para proyectos de colaboración en la nube como OwnCloud.  

Con esta configuración, hemos logrado crear un entorno robusto y fácil de mantener para ejecutar **OwnCloud**, con un alto nivel de automatización y facilidad de gestión a largo plazo.


# RESULTADO FINAL
![imagen](https://github.com/user-attachments/assets/c966f6ad-f5e6-47ad-8e26-bef259436ed8)


# Después de poner las credenciales: 
![imagen](https://github.com/user-attachments/assets/66c3294a-6ca5-41d6-a1dc-026c8f474e1f)








