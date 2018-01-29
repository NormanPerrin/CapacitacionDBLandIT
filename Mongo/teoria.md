# Mongo

## Temas
- CRUD.
- Aggregation Framework.
- Índices.
- Replica Sets.
- Sharding.
- Journal.
- Motores.
- Monitoreo.

## Replica Set.
* Grupo de instancias mongod.
* Proveen failover automático y alta dispinibilidad.
* Usan esquema maestro-esclavo.
* Si el nodo primario no está disponible, se elige a un secundario por quorum, teniendo en cuenta el que esté más actualizado y con prioridad mayor.
* Los nodos secundarios ven el oplog del primario y replican sus operaciones.
* Se le puede poner prioridad para hacerlo más o menos elegible para ser master. Si se le da prioridad 0 a un nodo, significa que no puede ser master nunca, algunos casos útiles:
    * Si prefiero que las escrituras las reciba otro nodo.
    * Nodo de backup o reportes.
* Pueden estar ocultos los nodos, con una propiedad "hidden" con valor 1. Estos nodos no son visibles para el cliente.
    * Deben tener prioridad 0.
    * Los miembros delay son miembros ocultos.
    * Se suelen usar en reporting o backups.
    * Votan en elecciones.
* Una operación de escritura en un replica set puede tener un *Write Concern*. Se determina cuando una operación de escritura es considerada exitosa. Puede especificarse para todo el RS, conexión u operación:
    * w: <número|mayority|tag> si es un número, espeficica la cantidad de nodos que deben confirmar operación. Con *mayority* es quorum. *tag* mayor control sobre escritura.
    * j: confirma la escritura cuando el servidor guardó un log (write ahead log) en disco.
    * wtimeout: tiempo en ms que da error si no se confirmó la operación.
* Se puede modificar el *Read Preference* también, indicando de qué nodo se quiere leer:
    * primary: (default).
    * Primary Preferred: lee preferentemente del primario, pero si no hay ninguno momentáneamente, leerá del secundario.
    * Secondary: únicamente secundario.
    * Secondary Preferred: preferentemente del secundario, si no hay secu levantado, lee prima.
    * Nearest: con menor latencia.

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
