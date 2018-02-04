# BigData
> *Volumen masivo de datos, tanto estructurados como no-estructurados, los cuales son demasiado grandes y difíciles de procesar con las bases de datos y el software tradicionales.*

Técnicamente progresó al bajar los costos de almacenamiento y haberse y haberse mantenido estable el costo de procesamiento por valor energía. También porque la potencia de los procesadores se mantuvo estable, solamente se agregan más a las computadoras, lo que benefició la programación en paralelo y el escalamiento horizontal.

**4Vs**
* Volumen: en el inicio los datos eran creados por los propios empleados, pero ahora son generados automáticamente por máquinas, redes sociales.
* Variedad: Antes se almacenaba la data en hojas de cálculo y bases de datos. Ahora la data llega en muchos formatos, esto hace que los datos sean desestructurados.
* Velocidad: ritmo de entrada de los datos.
* Veracidad: sesgo ruido o alteración de los datos. Los datos que se almacenan deben ser relevantes al dominio del problema y válidos.

## Temas
- [Conceptos base](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#conceptos-base)
- [Modelos de escalamiento](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#modelos-de-escalamiento)
- [Modelos de distribución y redundancia](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#modelos-de-distribución-y-redundancia).
    - [Replicación Maestro-Esclavo (Master/Slave)](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#replicación-maestro-esclavo-masterslave)
    - [Replicación Esclavo-Maestro-Esclavo (Slave-Master-Slave)](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#replicación-slave-master-slave)
    - [Replicación entre pares (peer to peer)](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#replicación-entre-pares-peer-to-peer)
    - [Particionamiento](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#particionamiento)
- [Modelos de persistencia y procesamiento](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#modelos-de-persistencia-y-procesamiento)
    - [Tipos de bases de datos](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#tipos-de-bases-de-datos)
    - [Arquitectura lambda](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#arquitectura-lambda)
- [Armado datalake](https://github.com/NormanPerrin/CapacitacionMongoBigData/blob/master/Teoria/bigdata.md#armado-datalake)

## Conceptos base.

### Redundancia de datos.
* Sube costo almacenamiento
* Baja costo procesamiento
* Pierdo consistencia
* Pierdo integridad

### Cluster.
Grupo de servidores independientes interconectados a través de una red dedicada que trabajan como un único recurso de procesamiento.

**Los clusters:**
* Distribuyen la carga entre los servidores interconectados.
* Mejoran la disponibilidad de los usuarios.
* Mejoran la performance total.
* Mejoran la tolerancia a fallas.
* Un servidor caído es inmediatamente inactivado y los usuarios redirigidos al resto.

## Modelos de escalamiento.

### Vertical.
Se mejora 1 servidor aplicándole más recursos.

**Características:**
* Más simple de gestionar, tanto el hardware como la arquitectura.
* Una aplicación puede separar funcionalidades en distintos módulos, que escalen verticalmente. Esto no es escalamiento horizontal.
* SPOF (Single Point of Failure).

### Horizontal.
Se mejora agregando más servidores a un cluster, los datos se replican y particionan en diferentes servidores.

**Características:**
* Distribución de carga.
* Tolerancia a fallos.
* Un nodo no tiene que persistir todos los datos.
* Queries dirigidos por geolocalización.
* Más potencia de procesamiento en paralelo.
* Más flexibilidad para agregar / sacar nodos, según convenga.

## Modelos de distribución y redundancia.
Casos en los que se desafían la disponibilidad cuando hay un solo servidor:
* BD con grandes volúmenes de datos: podría superar capacidad almacenamiento en una máquina.
* Gran cantidad de usuarios concurrentes con alta interacción: podría superar la capacidad respuesta de la CPU.

### Replicación Maestro-Esclavo (Master/Slave).
* Un nodo es maestro o primario, los otros son esclavos o secundarios.
* Solo el nodo maestro puede hacer inserciones o actualizaciones.
* La lectura se le puede pedir a cualquier nodo.
* La replicación se hace desde el nodo maestro a los secundarios.
* Ante una falla:
    * Se siguen procesando lecturas.
    * Se puede elegir a un nuevo maestro.
* Óptimo para pocas escrituras y muchas lecturas.
* No puede escalar escrituras, solo lecturas.

### Replicación Slave-Master-Slave.
* Todas las réplicas tienen el mismo peso.
* Todas aceptan escrituras.
* Cuando se escribe en nodo esclavo, se actualiza el master y de ahí se replica a los otros esclavos.

### Replicación entre pares (Peer to Peer).
* Todas las réplicas tienen el mismo peso.
* Todas aceptan escrituras.
* Conflicto escritura-escritura: se moficica el mismo dato en 2 lugares distintos.
* Pueden existir problemas de consistencia.

### Particionamiento.
* Distribuye partes del conjunto de datos en servidores de un cluster.
* Es importante asegurara que los datos que se acceden en conjunto estén en un mismo nodo.
* No ayuda tanto a la resistencia ante fallas, si un nodo falla, solo afecta a los usuarios que usaban ese nodo, pero sin replicación no tienen forma de acceder a esos datos.
