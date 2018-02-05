# Hadoop
Hadoop es un sistema de código abierto que se utiliza para almacenar, procesar y analizar grandes volúmenes de datos.

## Características
* Abstrae al programador de la programación en paralelo, tiene distintos motores o frameworks de procesamiento distribuido.
* No está pensada para velocidad de consultas, sino para tener velocidad de procesamiento. Consultas simples son más baratas de consultar en una BD común.
* Puede correr sobre servers básicos (commodity servers), pero necesita varios.
* Corre en un data center, no hace distribución geográfica. No funciona bien con una latencia alta, es mejor que corra lan.
* No pensado para consultas interactivas.

## Productos
Hadoop es un montón de productos.

### HDFS
* FS escrito en Java y basado en GFS (Google File System).
* Puede montarse sobre casi cualquier FS (ext3, ext4, ntfs, fat23).
* Todo en hadoop está guardado en HDFS.
* El tamaño de página de Hadoop son 128 Mb, cuando un FS común suele ser de 4 Mb. Por default lo replica 3 veces la partición.
* Hadoop corre sobre un SO anfitrión.
* Pensado para:
    * Archivos y volúmenes de datos grandes.
    * Trabajar con un esquema write once / read many times.
    * Los contenidos del archivo no se modifican, sí se pueden appendear datos al archivo.
    * La latencia para obtener un archivo total es más importante para una línea de un archivo.
    
### YARN
* Yet another resource negotiator.
* Surge por necesidad de
  * Escalabilidad
  * Alta disponibilidad
  * Multitenancy
* Entre todos los nodos tiene un “manager” y un “resource manager”, con el cual arma un container para distribuir recursos entre servidores.
* Si ya tenés algo armado con YARN, podés integrarte más fácil con Hadoop.

### Frameworks MapReduce
* Creado por google
* Modelo y FW de procesamiento.
* Graba datos temporales en disco.
* Usado por YARN.

### TEZ
* Creado por Apache.
* Entre los procesos se pasa datos por memoria.
* Es un poco mejor que MapReduce.
* Usado por HIVE y PIG.
* Modela su procesamiento con un DAG (gráfo).

### Spark
* Creado por la Universidad de Beklin.
* Provee análisis de datos en memoria.
* Diseñada para ejecutar iterativamente algoritmos y análisis predictivos.
* Permite desarrollar programas con varios lenguajes de programación.
* Es más pesado para armado de contexto.
* Para procesos heavy está piola.
* Tiene un sub fw para procesar streaming.

### HIVE
* Intérprete SQL, que traduce a proceso MapReduce que lo toma algún FW para responder la consulta.
* Creado por Facebook.
* Puede usar Spark, TEZ o MapReduce para su ejecución.
* Se pueden crear tablas, pero por atrás te lo guarda en el FS.
* Provee facilidades de Datawarehouse sobre un cluster Hadoop.

### Pig
* Desarrollado por Yahoo!
* De alto nivel, te reemplaza scripting de algunas otras tecnologías y te lo hace más fácil.
* Plataforma para análisis de granes conjuntos de datos.
* Programas MapReduce simples de desarrollar usando Pig.
* No se usa mucho, porque es complicado de usar.
* Como ventaja, con archivos grandes te puede servir, y sabiendo, te acelera el proceso de desarrollo.

### HUE
* Hadoop User Experience.
* Herramienta de Claudera.
* Como una IDE de queries.
* Podés tirar queries interactivamente.
* Deprecado por Hortonworks.

### Zookeeper
* Herramienta medio oculta, no se suele utilizar frecuentemente.
* Clave para que ande Hadoop.
* Labura consistencia, concurrencia, coordinación de procesos distribuídos de Hadoop.
* Administra todos los servicios.

### FLUME
* Tiene un montón de drivers de I/O para ir acumulando datos de entrada.
* Permite recolectar de distintas fuentes datos.
* Te arma paquetes para escribir en el FS.
* Va guardando en un buffer toda la data entrante y cuando ve q va bien, inserta lo del buffer.

### KAFKA
* Desarrollada originalmente por linkdin, liberada en 2011.
* Message broker, un middleware, recibe mensajes, los encola en un buffer (topic determinado), y los puedo ir tomando.
* Maneja un offset y a medida que voy leyendo se va desplazando el offset. O sea que no tira el dato después de leerlo, sino cuando queda deprecado por el offset.
* Tiene productores, consumidores que interactúan con el buffer.
* Para alto nivel de concurrencia, hay que configurar bien el offset.
* Hace poco salió Pulser, que es una herramienta OS que maneja un poco mejor la concurrencia que KAFKA supuestamente.

### Sqoop
* Extractor y carga. No tiene mucho de transformación.
* Permite exportar e importar información fácilmente desde distintas BDs.
* Se le pueden dividir los queries de búsquedas en threads.

### OOZIE
* Herramienta de sinc de procesos.
* No se usa mucho, porque ya suelen configurarse este tipo de procesos con otras herramientas.

### Knutch
* Te permite hacer crawling.
* Motor de búsqueda OS.
* Va buscando patrones que le configurás.
* Corre sobre hadoop.

### MAHOUT
* Para machine learning.
* Va aprendiendo de lo procesado.
* Va quedando deprecado por cond del mercado, Spark va ganando impulso con una librería.

### HBASE
* Column family
* Opera sobre HDFS.
* Pensada para correr sobre Hadoop, no vale la pena casi sino.

### Accumulo
* Proyecto Apache
* Compite contra Redis.

### Ranger
* Herramienta de seguridad sobre Hadoop.
* Autorización y autentificación para acciones, su fuerte es autorizar.
* Internamente maneja un montón de agentes distribuidos en cada nodo, que son los encargados de validar.
* A parte tiene un módulo de encriptación y auditoría.

### Knox
* Interactúa con ranger, pero es más de autentificación, te deja o no pasar, pero a través de él.

### ATLAS
* Producto para data governance.
* Mantiene historia del dato y su linaje.
* Permite clasificación de datos.
* Arma una metadata de negocio sobre una data y podés determinar de dónde y cómo surge.
* Bueno para auditoría.
* Lo más complicado es qué dirección maneja esta información, ya que debe ser autorizada.
* Para obtener la historia del dato, todos tienen que colaborar.
* Herramienta con implicaciones más funcionales.

### Redis
* Te recomienda que empieces con 50 nodos. Agregar nodos es complicado con sharding.

### Ambari
* Herramienta de monitoreo.
* Su fuerte está en administrar y provisionar cluster Hadoop.
* Monitorea clusters.
* A parte tiene Ambari views, que reemplazan algunas otras herramientas de Hadoop. En esta parte Ambari no crea muy cohesivo, tiene responsabilidades diversas.
* Usa por abajo Nagios.

### Nagios
* Herramienta de monitoreo madura y muy utiliza en sistemas Unix

### Apache Zeppelin
* Data ingest, discovery, analysis, visualization.
* Herramienta para visualización de datos en tiempo real.
* Me deja ir visualizando procesos, queries y demases, entonces tengo un informe de cómo están las cosas.
* Podés administrar para dar “fotos” del sistema.
