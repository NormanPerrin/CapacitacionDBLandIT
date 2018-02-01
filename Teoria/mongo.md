# Mongo
Algunas caractersticas generales:
* Flexible a cambios en el modelo.
* Permite trabajar con data desestructurada.
* Forma de escala sencilla
* Fácil de integrar con Node
* Mayor disponibilidad de datos.
* Automatic failover (50 réplicas) y no tarda más de 2 sg.
* Escala horizontal (sharding).
* Bueno para realtime.
* Transacciones a nivel documento.
* Al estar orientada a documentos, no hace falta hacer joins entre servers y la lectura es más rápida aunque esté en el mismo servidor.
* Se puede diferenciar data de poco uso para meterla en servers más sencillos.

## Temas
- CRUD.
- Aggregation Framework.
- Transacciones.
- Índices.
- Replica Sets.
- Sharding.
- Journal.
- Motores.
- Monitoreo.

## CRUD
* Create => `db.coleccion.insert({ */doc*/ }, { /*opciones*/ })`
* Read => `db.coleccion.find({ */criterio*/ }, { */proyección*/ })`
* Update => `db.coleccion.update({ /*criterio*/ }, { */doc*/ }, { /*opciones*/ })`
* Delete => `db.coleccion.remove({ /*criterio*/})`

Algunas operaciones como el find, devuelve un cursor, el cual podemos chainearle algunas operaciones para modificar el resultado de ejecución del mismo:
* `.limit()`
* `.skip()`
* `.hasNext()`
* `.next()`

## Aggregation Framework
```js
db.coleccion.aggregate(
   {}, // el resultado de este pipe va a ser el input del que le sigue
   {},
   ...
)
```
**Operaciones posibles de pipes:**
* HAVING => `$match`
* GROUP => `$group: {_id: campoAgrupar | {nombre: campoAgrupar, ...}, funcAgregación}`
* Aplanar documentos por array => `$unwind: campoArray`
* 

**Tener en cuenta:**
* Usar búsquedas por índices al principio, después las búsquedas se hacen por resultado de pipe anterior.

## Transacciones.
**Two Phase Commits (MongoDB):**
* Una forma de obtener atomicidad de transacciones, o maso, usando una colección intermedia en la operación.
* Se usa una colección "transactions", en donde se especifica la info para después poder cancelarla si quedó a medio completarse o rollbackearla. Se guarda info relevante a la operación, como la fecha, estado y entidades involucradas.
* Cuando inicia el sistema se verifica si hay alguna transacción con estado diferente a "done". De ser así se maneja a mano el rollback o cancelación de todo según la info que se tenga.
* Cuando inicia el sistema se verifica si hay alguna transacción con estado diferente a "done". De ser así se maneja a mano el rollback o cancelación de todo según la info que se tenga.

## Índices
**Tipos de índices:**
* Simple
* Compuesto
* Basdo en Hash
* Geoespacial
* Multikey
* Full text

**Propiedades de los índices:**
* `{ unique: boolean }`
* `{ sparse: boolean }` - No crea entradas para documentos que no tengan ese atributo, se los saltea.
* `{ expireAfterSeconds: 3600 }` - TTL (Time To Leave), el motor borrará el índice cuando se alcance la fecha del índice (si expireAfterSeconds es 0) o cuando pase el tiempo.

**Operaciones sobre índices:**
```js
db.collname.createIndex(...)

db.collname.dropIndex(...)

db.collname.getIndexes()

db.collname.reIndex()
```

**Creación según tipos de índices**
```js
// Simple
db.facturas.createIndex({ fechaEmision: 1 }) // 1 ascendente, -1 descendente

// Compuesto
db.facturas.createIndex({ "cliente.region": 1, condPago: 1 }) // es importante el orden en que van

// Hash
db.facturas.createIndex({ "nroFactura": "hashed" })

// Geo2d
db.comercios.createIndex({ "ubicacion": "2d" }) // pueden ser compuestos también

// Geo2dSphere
db.comercios.createIndex({ ubicacion: "2dsphere" })

// Text
db.facturas.createIndex({ "item.producto": "text" }) // solo puede haber 1 índice text por cada colección

// Se le pueden pasar opciones:
//   default_language: "spanish"
//   language_override: "idioma" - idioma sería un atributo de la colección, con un string indicando el idioma

// Full Text
db.facturas.createIndex({ "$**": "text" })
```

**Búsqueda de índices:**
```js
// Geo2d (se usa $near y $maxDistance)
db.comercios.find({ ubicacion: {$near:[ -58.432929, -34.588042 ], $maxDistance: 1} }) // si se utiliza 2 puntos de coordenadas, el maxDistance queda en radianes

// Geo2d se puede hacer esta búsqueda también, pero acá la distancia va a estar en metros.
$near: {
   $geometry: {type: "Point", coordinates: [ <longitud>, <latitud> ]},
   $maxDistance: <distancia en metros>,
   $minDistance: <distancia en metros>
}

// Geo2dSphere
db.comercios.find({ ubicacion: {$near: [ -58.432929, -34.588042 ], spherical: true, $maxDistance: 5} })

// Text
db.facturas.find({ $text: { $search: "12mm Manoni" } }).count() // búsca 12mm y Manoni, si quiero buscar todo junto se pone en un regexp: /12mm Manoni/

// Text ordenado por match
db.libros
   .find({ $text: {$search: "argentina gaucho fierro"} }, { titulo: 1, score: {$meta:"textScore"} })
   .sort({ score: {$meta: "textScore"} })
```

**Tener en cuenta:**
* Estructura de índices basados en árbol B+
* El `_id` que se autogenera en una colección, es un índice creciente (rango), se compone de:
   * Fecha
   * PC
   * PID
   * Contador
* Cuando se crea un índice con un atributo de un objeto de un array, mongo crea una clave de índice por cada elemento del array referenciado. Esto es un **ìndice multikey**. Como limitaciones, no puede crear hashed indexes, no puede crear shared multikey index.

## Replica Set.
* Grupo de instancias mongod.
* Proveen failover automático y alta dispinibilidad.
* Usan esquema maestro-esclavo.
* Una réplica puede tener hasta 50 nodos, pero solo 7 votantes.
* La replicación es asincrónica, salvo que se especifique.
* Si el nodo primario no está disponible, se elige a un secundario por quorum, teniendo en cuenta el que esté más actualizado y con prioridad mayor. Algo importante a tener en cuenta es que aunque se caiga un server, el quorum sigue siendo el mismo.
* Se le puede poner prioridad para hacerlo más o menos elegible para ser master. Si se le da prioridad 0 a un nodo, significa que no puede ser master nunca, algunos casos útiles:
    * Si prefiero que las escrituras las reciba otro nodo.
    * Nodo de backup o reportes.
    
**Tipos de nodos**
* Primario: recibe escrituras y replica data a través de su OPLOG, que leen los secundarios.
* Secundarios:
   * Prioridad 0: no puede ser primario ni disparar elecciones. Útiles para evitar que un nodo sea primario, puede ser debido a que no es óptimo para escrituras, o por una razón geográfica del nodo.
   * Oculto: son prioridad 0 siempre. No dan acceso a lectura externa. Útiles para reporting o backups.
   * Retardados: prioridad 0. Ocultos. Con retardo. Útiles para guardar operaciones en caso de errores replicados.
* Árbitro: 
   * Puede votar en elecciones.
   * No guarda data.
   * Tienen prioridad 0.

**Write concern:**
Se determina cuando una operación de escritura es considerada exitosa. Puede especificarse para todo el RS, conexión u operación. Las opciones son:
  * w: <número|mayority|tag> si es un número, espeficica la cantidad de nodos que deben confirmar operación. Con *mayority* es quorum. *tag* mayor control sobre escritura.
  * j: confirma la escritura cuando el servidor guardó un log (write ahead log) en disco.
  * wtimeout: tiempo en ms que da error si no se confirmó la operación.

Modificando write concern por default:
```js
cfg = rs.conf()
cfg.settings.getLastErrorDefaults = { w: "majority", wtimeout: 5000 }
rs.reconfig(cfg)
```

En un insert:
```js
db.products.insert(
   { item: "envelopes", qty : 100, type: "Clasp" },
   { writeConcern: { w: 2, wtimeout: 5000 } }
)
```

**Read preference:**
Describe cómo los clientes MongoDB leen data de un RS.

*Default:* Dirigen sus lecturas al primario. Las lecturas que no son default, pueden retornar data desactualizada ya que pueden llegar a leer de nodos en los que no se llegó a replicar una operación.

Clientes que usen read "local" o "available" pueden ver resultados de un write antes de que se replique, sin importar el *write concern*. Pueden estar leyendo data que luego sea rollbackeada, aunque esto último es muy raro. Otro modo es *secondary*, que permite lecturas de nodos secundarios. *nearest* es bueno usarlo para cuando hay lecturas de diferentes lugares geográficos y puede existir latencia con el primary. *primaryPreferred* se usa cuando bajo circunstancias normales quiero lecturas desde el primario, pero en caso de failover quiero que se lean de los secundarios.

En un find:
```js
cursor.readPref(mode, tagSet)
```

**Cómo levantar un Replica Set:**
```js
// 1) Levanto los servers mongod
mongod --replSet rs --port 27058 --dbpath dbpath/ --fork --logpath logpath/mongodb.log
mongod --replSet rs --port 27059 --dbpath dbpath/ --fork --logpath logpath/mongodb.log
mongod --replSet rs --port 27060 --dbpath dbpath/ --fork --logpath logpath/mongodb.log

// 2) Me conecto al server que quiero que sea primario y configuro 
var cfg = { _id: "rs", members: [{_id: 0, host: "localhost:27058"}] };
rs.initiate(cfg);

// 3) Luego para agregar a los secundarios o árbitros
rs.add(_id: 1, host: "localhost:27059");
rs.addArb(_id: 2, host: "localhost:27060");

// 4) Verifico que estén con estado correcto
rs.status();

// 5) Si quiero cambiar algo de la config
cfg = rs.config();
// hago algunos cambios al objeto config...
rs.reconfig(cfg)

// 6) A los secundarios tengo que permitirles las lecturas
// me conecto al secundario y le pongo
rs.slaveOk();
```

## Sharding
* Se debe definir el criterio de particionamiento.
* Es necesaria una clave de partición.
* Mongo se encarga de particionar y distribuir de forma equitativa los datos.
* Las partes se denominan chunks y son almacenadas en un nodo o conjunto llamado shards.
* Un cluster de partición cuenta con 3 participantes básicos:
    * Particiones (mongod --shardsvr --replSet ...)
    * Ruteadores de Consultas (mongos --configdb <rs>/<cfgsvr1> ...)
    * Servidores de Configuración. (mongod --configsvr ...)

**Orden levantar shards:**
1. Levantar shards (los puedo levantar antes, durante o dsps)
2. Levantar sv config
3. Levantar ruteador consulta
4. Agregar shards al cluster.
5. Crear índice shard key. (puede ser pos 6)
6. Habilitar distribución bd. (puede ser pos 5)
7. Aplicar sharding a la colección.

**Config Server:**
* Guardan la metadata del server particionado.
* Usando config servers se deben considerar ciertas restricciones, no se pueden tener:
   * Nodos retardados.
   * Árbitros.
   * Nodos con buildIndexes en 0 (no construyen índices).

**Cómo levantar instancias sharding**
```js
// 1) Levanto servers mongod con –shardsvr
mongod --shardsvr --replSet rs --port 27058 --dbpath dbpath/ --fork --logpath logpath/mongodb.log
mongod --shardsvr --replSet rs --port 27059 --dbpath dbpath/ --fork --logpath logpath/mongodb.log
mongod --shardsvr --replSet rs --port 27060 --dbpath dbpath/ --fork --logpath logpath/mongodb.log

// 2) Levanto server de configuración
mongod --configsvr --port 27500 --dbpath dbpath/ --fork --logpath logpath/mongodb.log --logappend

// 3) Me conecto para setearle la config
mongo --port 27500
rs.initiate({_id: "rs_conf", members: {_id:0, host: "localhost:27500"}})

// 4) Creamos y levantamos un servidor de ruteo
mongos --configdb rs_conf/localhost:27500 --port 27000

// 5) Nos conectamos al ruteador para agregar el shard
Mongo –port 27000
sh.addShard("rs/127.0.0.1:27058")

// 6) Creamos un índice y lo habilitamos para sharding
db.facturas.createIndex({ "cliente.region": 1, "cliente.nombre": 1 })
sh.enableSharding("finanzas")
sh.shardCollection("finanzas.facturas", {"cliente.region": 1, "cliente.nombre": 1}, false)

// 7) Si queremos otro RS haga sharding levantamos otro RS igual que antes y en el ruteador lo agregamos
Mongo –port 27000
sh.addShard(“r2/localhost:27158”)

// (Bounus) Ver los chunks que se crearon
use config
db.chunks.find({}, { min: 1, max: 1, shard: 1, _id: 0, ns: 1 }).pretty()
// También puedo queriar un find y hacer explain.
```

## Journal
* Propia para cada una de las instancias al igual que OPLOG, pero este no juega en la replicación, juega si hay una caída del servidor
* Guarda información “delta” en disco cada poco tiempo, así si se cae el motor, nos dice qué operaciones pasaron y los cambios chicos que se tienen que hacer. Si tiene datos corruptos, puede recuperarlos mediante el journal.

## OPLOG
* Es una colección de tamaño fijo que va sobreescribiendo su data a medida que se agrega.
* Las operaciones son idempotentes, o sea que producen el mismo resultado sin importar cuántas veces las apliques.
* Así la replicación puede sincronizar data solapádamente.
* Loguea operaciones de escritura, así los nodos secundarios leen de este archivo y replican la operación en sus nodos.

## Monitoreo

### Explain
Se le puede agregar a un cursor y el mismo ejecutará la operación planificada y dirá los pasos que realizó, según los detalles que queramos:
* `.explain("queryPlanner")` (default)
* `.explain("executionStats")` Devuelve detalles de ejecución del plan ganador
* `.explain("allPlansExecution")` Devuelve detalles de todos los planes que tomó en cuenta

### Hints
A una query se le pueden pasar *hints* para que tome como índice un atributi en una búsqueda. Si el motor ve que el índice pasado como parámetro no tiene sentido, no lo toma en cuenta. Ej.
```js
// Va a buscar por el índice condPago
db.facturas.find({ condPago: {$in: [“CONTADO”, ”30 Ds FF”] }).hint({ condPago: 1 })

// También podemos forzar al motor a hacer un COLLSCAN
db.facturas.find({ condPago: {$in: [“CONTADO”, ”30 Ds FF”] }).hint({ $natural: 1 })
```
