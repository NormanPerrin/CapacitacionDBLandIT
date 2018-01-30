1.
```
mongod --replSet rs --port 27058 --dbpath /Users/norman/tempData/db_pri --fork --logpath /Users/norman/tempData/log_pri/mongodb.log

mongod --replSet rs --port 27059 --dbpath /Users/norman/tempData/db_aux --fork --logpath /Users/norman/tempData/log_aux/mongodb.log

mongod --replSet rs --port 27060 --dbpath /Users/norman/tempData/db_arb --fork --logpath /Users/norman/tempData/log_arb/mongodb.log
```
2 y 3.
```
mongo --port 27058

use finanzas
```
4.
```
cfg = { _id: "rs", members: [{_id:0, host:"localhost:27058"}] }

rs.initiate(cfg) // ahora 27058 es SECUNDARY

rs.add("localhost:27059") // ahora 27058 es PRIMARY y agrego a 27059 como SECUNDARY

rs.addArb("localhost:27060") // agrego árbitro

rs.status() // verifico que los members tengan rol correcto

load("/Users/norman/Work/CapacitacionMongoBigData/Practica/clase4/facts.js") // 4 veces
```
5.
```
db.facturas.find({nroFactura: 1020}) // 4 resultados
```
6.
```
// replica server
mongo --port 27059

rs.slaveOk()

use finanzas

show collections // --> facturas

db.facturas.find({nroFactura: 1020}) // 4 resultados
```
7.
```
ps aux | grep mongo

kill -2 PID

// 1
/*
 * Al matar el servidor primario, por quorum se eligió al secundario (27059) como nuevo primario.
 */

// 2
/*
 * El viejo primario (27058) quedó con estado not reachable, pero no se eliminó de los members.
 * El secundario (27059) ahora es el primario y el arbitro sigue igual.
 */

// 3
db.facturas.insert({
    "cliente" : {
        "apellido" : "Perrin",
        "cuit" : 2740488484.0,
        "nombre" : "Norman",
        "region" : "Por ahí"
    },
    "condPago": "CHEQUE",
    "fechaEmision": ISODate("2014-02-20T00:00:00.000Z"),
    "fechaVencimiento": ISODate("2014-02-20T00:00:00.000Z"),
    "item" : [
        {
            "cantidad": 1.0,
            "precio": 25.0,
            "producto": "CAFÉ LOCO"
        }
    ],
    "nroFactura" : 10000.0
})

// 4
mongod --replSet rs --port 27058 --dbpath /Users/norman/tempData/db_pri --fork --logpath /Users/norman/tempData/log_pri/mongodb.log

mongo --port 27058

rs.slaveOk()
// 5
use finanzas

db.facturas.find({nroFactura: 10000}) // --> 5 resultados

// 27058 quedó como secundario, 59 como primario y estos 2 tienen la información de replica.
```
8.
```
mongod --replSet rs --port 27061 --dbpath /Users/norman/tempData/db_delay --fork --logpath /Users/norman/tempData/log_delay/mongodb.log

// desde PRIMARY
config = rs.config()
config.members[3].priority = 0
config.members[3].slaveDelay = 120
rs.reconfig(config)
```
9.
```
// desde PRIMARY
load("/Users/norman/Work/CapacitacionMongoBigData/Practica/clase4/facts.js")

// luego de 120 segundos, se actualiza el nodo 27061 (con delay)
```