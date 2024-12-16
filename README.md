# Instalaci-n-de-CMS-en-arquitectura-de-3-4-capas-en-alta-disponibilidad
# INTRODUCCION
En esta práctica se llevará a cabo el despliegue automatizado de un CMS Joomla sobre una infraestructura dividida en cuatro capas, con el objetivo de garantizar un sistema eficiente, escalable y altamente disponible.

La primera capa estará compuesta por un balanceador de carga, cuya función principal será distribuir las solicitudes de los usuarios entre los diferentes servidores web. Este balanceador se encargará de optimizar el tráfico, garantizando que la carga se gestione de manera equitativa entre los servidores disponibles y, por ende, manteniendo la disponibilidad del servicio alta. De esta forma, se logra una mejor experiencia de usuario al evitar sobrecargar a un único servidor.

En la segunda capa se ubicarán los servidores encargados de procesar las solicitudes del lado del servidor (BackEnd). Esta capa incluirá dos servidores web que ejecutarán el CMS Joomla, junto con un servidor NFS (Network File System) y un servidor PHP. Estos componentes trabajarán en conjunto para gestionar los archivos estáticos y el procesamiento dinámico de PHP, lo cual es fundamental para el funcionamiento adecuado de Joomla. Además, el servidor NFS permitirá compartir archivos entre los servidores, lo que facilita la administración y sincronización de datos.

La tercera capa estará dedicada a otro balanceador de carga que distribuirá las solicitudes entre los servidores de bases de datos. De esta manera, las consultas a la base de datos se distribuyen de manera equilibrada entre los servidores disponibles, asegurando que no se sobrecargue ningún servidor en particular y manteniendo una alta disponibilidad para el acceso a la base de datos.

Finalmente, en la cuarta capa se encontrará un clúster de bases de datos, compuesto por dos servidores que albergarán la base de datos de Joomla. Estos servidores se configuran para trabajar en conjunto, con el objetivo de ofrecer redundancia y evitar cualquier punto único de fallo. Así, si uno de los servidores de base de datos falla, el otro puede continuar proporcionando los datos necesarios para el funcionamiento del sistema.

# Índice

1. [Introducción](#introducción)
2. [Capa 1: Balanceador de Carga](#capa-1-balanceador-de-carga)
3. [Capa 2: Servidores Web y PHP](#capa-2-servidores-web-y-php)
4. [Capa 3: Balanceador de Carga para Bases de Datos](#capa-3-balanceador-de-carga-para-bases-de-datos)
5. [Capa 4: Servidores de Bases de Datos](#capa-4-servidores-de-bases-de-datos)
6. [Conclusión](#conclusión)

# Introducción
# Infraestructura de la práctica.
## Dirección IP de las Máquinas

A continuación se muestra el direccionamiento IP elegido para las máquinas en la infraestructura:

- **Balanceador Web:**
  - **Red 1 (Conexión a la red externa)
  - **Red 2 (Red Privada):** 10.0.10.10 (Red interna para balanceo de carga)

- **Servidor NFS-PHP:**
  - **Red 1 (Conexión Interna - Red Local):** 172.16.0.100 (Servidor compartido de archivos)

- **Servidor Web 1:**
  - **Red 1 (Red Local - Frontend):** 10.0.10.101 (Conexión para procesamiento de solicitudes web)
  - **Red 2 (Red Local - Backend):** 172.16.0.101 (Conexión para comunicación con servidor PHP)

- **Servidor Web 2:**
  - **Red 1 (Red Local - Frontend):** 10.0.10.102 (Conexión para procesamiento de solicitudes web)
  - **Red 2 (Red Local - Backend):** 172.16.0.102 (Conexión para comunicación con servidor PHP)

- **Balanceador de Base de Datos::**
  - **Red 1 (Conexión Interna - Red de Base de Datos):** 172.16.0.200 (Distribución de tráfico hacia las bases de datos)
  - **Red 2 (Red Pública - Administración):** 192.168.20.200 (Acceso administrativo al balanceador de base de datos)

- **Servidor de Base de Datos 1:**
  - **Red 1 (Red de Base de Datos):** 192.168.20.201 (Almacenamiento de datos)

- **Servidor de Base de Datos 2:**
  - **Red 1 (Red de Base de Datos):** 192.168.20.202 (Almacenamiento de datos)


# Capa 1: Balanceador de Carga
El balanceador de carga distribuye las solicitudes de los usuarios entre los servidores web (Capa 2), garantizando que la carga se reparta de manera equitativa. Su objetivo principal es mejorar la disponibilidad y el rendimiento, asegurando que ningún servidor se sobrecargue, y permitiendo que el sistema maneje grandes volúmenes de tráfico de manera eficiente.

# Capa 2: Servidores Web y PHP
En esta capa, los servidores web procesan las solicitudes entrantes de los usuarios, sirviendo contenido estático y dinámico. Estos servidores también incluyen el entorno PHP para gestionar aplicaciones como Joomla, lo que permite que el contenido dinámico se genere y entregue al usuario final. Los servidores en esta capa trabajan en conjunto para asegurar que las solicitudes se manejen rápidamente y sin interrupciones.

# Capa 3: Balanceador de Carga para Bases de Datos
Este balanceador se encarga de distribuir las solicitudes de acceso a la base de datos entre los servidores de bases de datos en la Capa 4. De manera similar al balanceador de carga en la Capa 1, su función es asegurar que el tráfico hacia las bases de datos esté equilibrado, lo que mejora la escalabilidad y la disponibilidad de los datos, especialmente cuando hay múltiples servidores de base de datos.

# Capa 4: Servidores Bases de Datos
En la Capa 4 se encuentran los servidores de bases de datos. Estos servidores gestionan toda la información almacenada en el sistema y responden a las consultas realizadas por los servidores web en la Capa 2. El clúster de bases de datos permite la replicación de datos y una alta disponibilidad, lo que garantiza que los datos no se pierdan y que el sistema siga funcionando incluso si uno de los servidores de base de datos falla.

# Conclusión
Resumen y conclusiones de la práctica.


Es importante destacar que todas las máquinas dentro de esta infraestructura tendrán restringida la conexión a su propia red, asegurando así que las comunicaciones sean seguras y controladas. Sin embargo, el balanceador de carga en la capa 1 tendrá acceso a Internet para recibir las solicitudes externas y distribuirlas a los servidores adecuados.
Este diseño de infraestructura proporciona una solución robusta y escalable para el despliegue de Joomla, permitiendo gestionar el tráfico de manera eficiente, asegurar la alta disponibilidad del sistema y facilitar su mantenimiento a largo plazo.
