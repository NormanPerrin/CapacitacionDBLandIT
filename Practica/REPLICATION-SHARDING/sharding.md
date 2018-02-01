1.
```js
// Levanto shards
./create_rs.sh

// Configuro RS
mongo --port 27058
load("init_rs.js")
load("facts.js")

// Levanto sv config
./create_configsv.sh

// Configuro RS del sv config
mongo --port 27500
load("init_configsv.js")

// Agrego sv mongos
mongos --configdb configRS/localhost:27500 --port 27800 --logpath logs/mongodb.log --logappend --fork

// Agrego los shards a mongos
mongo --port 27800
sh.addShard("rs1/localhost:27058")

// Cambio carpetas, nombre RS y puertos scripts para levantar shards 27158, 27159 y 27160, luego hago los mismos pasos de antes para levantar otro RS

// Agrego los nuevos shards a mongos
mongo --port 27800
sh.addShard("rs2/localhost:27158")

// Creo un índice hash y habilito sharding
mongo --port 27800
db.facturas.createIndex({ "cliente.region": 1, "cliente.nombre": 1 })
sh.enableSharding("finanzas")

// Ejecuto Sharding sobre la Colección facturas de la Base de datos Finanzas
sh.shardCollection("finanzas.facturas", {"cliente.region": 1, "cliente.nombre": 1 }, false)
```
2.
a. El cluster tiene 8 nodos en total:
* 6 shards
* 1 mongod config
* 1 mongos
c. Puede ser mayority. Independientemente del write concern, las lecturas dependen del read preference, los cuales pueden setearse para que se lea desde los secundarios también y no solo el primario. Con un read preference de "secondary".
d. Podría agregarse un nodo con delay para tener contra errores que puedan ocurrir y se repliquen. También se podría tener un servidor para backup oculto de lecturas del cliente, que solo guarde datos replicados.
```js
cfg = rs.conf()

// configuración desde primary de nodo con delay
cfg.members[3].priority = 0
cfg.members[3].hidden = true
cfg.members[3].slaveDelay = 0


// configuración desde primary nodo backup
cfg.members[4].priority = 0
cfg.members[4].hidden = true

// una vez hecho eso, se reconfigura el primary
rs.reconfig(cfg)
```
