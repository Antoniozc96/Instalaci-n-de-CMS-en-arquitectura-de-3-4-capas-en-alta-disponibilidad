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
5. [Capa 4: Clúster de Bases de Datos](#capa-4-clúster-de-bases-de-datos)
6. [Conclusión](#conclusión)

# Introducción
Aquí empieza la introducción de tu documento.

# Capa 1: Balanceador de Carga
Detalles sobre el balanceador de carga.

# Capa 2: Servidores Web y PHP
Detalles sobre los servidores web y PHP.

# Capa 3: Balanceador de Carga para Bases de Datos
Detalles sobre el balanceador de carga de bases de datos.

# Capa 4: Clúster de Bases de Datos
Detalles sobre el clúster de bases de datos.

# Conclusión
Resumen y conclusiones de la práctica.


Es importante destacar que todas las máquinas dentro de esta infraestructura tendrán restringida la conexión a su propia red, asegurando así que las comunicaciones sean seguras y controladas. Sin embargo, el balanceador de carga en la capa 1 tendrá acceso a Internet para recibir las solicitudes externas y distribuirlas a los servidores adecuados.
Este diseño de infraestructura proporciona una solución robusta y escalable para el despliegue de Joomla, permitiendo gestionar el tráfico de manera eficiente, asegurar la alta disponibilidad del sistema y facilitar su mantenimiento a largo plazo.
