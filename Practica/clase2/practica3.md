a.
```
var item_destornillador = {
    "cantidad" : 2.0,
    "precio" : 20.0,
    "producto" : "DESTORNILLADOR"
}

db.facturas.update(
    { nroFactura: 1000 },
    { $push: { item: item_destornillador } }
)
```
b.
```
db.facturas.update(
    { nroFactura: 1000 },
    { $pop: { item: -1 } }
)
```
c.
```
db.facturas.update(
    { nroFactura: 1000 },
    { $pull: { item: { producto: /^CORREA 10mm$/ } } }
)
```
d.
```
var factura = db.facturas.find({ nroFactura: 1000 }).next()

delete factura.item

db.facturas.update(
    { nroFactura: 1000 },
    { factura }
)
```
e.
```
db.facturas.update(
    { nroFactura: 1000 },
    { $unset: {item: ""} }
)
```
f.
```
var facturas = db.facturas.find(
  { nroFactura: 1002 },
  { item: 1, _id: 0 }
).map(function (factura) {return factura.item})[0]

db.facturas.update(
  { $or: [{nroFactura: 1000}, {nroFactura: 1001}] },
  { $pushAll: {item: facturas} },
  { multi: true }
)
```
g.
```
db.facturas.update(
  { "cliente.apellido": "Lavagno" },
  { $set: { "cliente.tipo": "VIP" } },
  { multi: true }
)
```
h.
```
var regalo = {
  "cantidad" : 1.0,
  "precio" : 0.0,
  "producto" : "ALFAJOR"
}

db.facturas.update(
  { "cliente.tipo": { $exists: true } },
  { $push: { item: regalo } },
  { multi: true }
)
```
i.
```
db.facturas.update(
  { "cliente.apellido": "Gonzalez", "cliente.nombre": "Julio" },
  { $addToSet: { intereses: ["Plomeria", "Electronica"] } },
  { multi: true }
)
```
j.
```
db.facturas.find({ item: { $elemMatch: { producto: /^TALADRO 12mm$/ } } })
```
k.
```
db.facturas.find(
  { item: { $elemMatch: { producto: /^TALADRO 12mm$/ } } },
  { _id: 0, nroFactura: 1, "item.$": 1 }
)
```
l.
```
db.facturas.update(
  { item: { $elemMatch: { producto: /^CORREA 12mm/, cantidad: 11 } } },
  { $inc: { "item.$.precio": -1 } },
  { multi: true }
)
```
m.
```
db.facturas.find(
  { item: { $elemMatch: { producto: /^CORREA 12mm/, cantidad: 11 } } },
  { "item.$.precio": 1, _id: 0 }
)
```
n.
```
db.coleccionInexistente.update(
  {},
  {
    $set: {
      x: [1,3,5,7,8,4,9,2].sort(function (a, b) {return a - b}).slice(0,3),
      y: 1,
    },
    $setOnInsert: { created: new Date() }
  },
  { upsert: true }
)
```
o.
```
db.coleccionInexistente.insert(
  [
    { x: new Date() },
    { x: "mongo" },
    { x: "db" }
  ]
)

db.coleccionInexistente.find({ x: {$type: 2} })
```
p.
```
var facturas = db.facturas.find(
  { nroFactura: 9998 },
  { item: 1, _id: 0 }
).map(function (factura) {return factura.item})[0]

db.facturas.update(
  { nroFactura: 9999 },
  {
    $push: {
      item: {
        $each: facturas,
        $sort: { precio: 1 }
      }
    }
  },
  { multi: true }
)
```
q.
```
var facturas = db.facturas.find(
  { nroFactura: 9996 },
  { item: 1, _id: 0 }
).map(function (factura) {return factura.item})[0]

db.facturas.update(
  { nroFactura: 9999 },
  {
    $push: {
      item: {
        $each: facturas,
        $sort: { precio: -1 },
        $slice: 3
      }
    }
  },
  { multi: true }
)
```
r.
```
db.facturas.update(
    {},
    {
        $push: {
            "cliente.intereses": {
                $each: ["Mecanica"],
                $slice: 2
            }
        }
    },
    { multi: true }
)
```
s.
```
var factura = db.facturas.find({ nroFactura: 3355 }).next()
factura.fechaVencimiento = ISODate()
factura.condPago = "CONTADO"
db.facturas.save(factura)
```
t.
```
factura = db.facturas.find({ nroFactura: 3355 }).next()
delete factura._id
factura.nroFactura = "Invalido"
db.facturas.remove({nroFactura: 3355})
db.facturas.save(factura)
```
u.
```
db.facturas.findAndModify({
  query: { "cliente.region": "CABA" },
  sort: { nroFactura: 1 },
  update: { $inc: { cuota: 1 } },
  new: true
});
```
v.
```
var itemEliminado = db.facturas.findAndModify({
  query: { nroFactura: 1007 },
  update: { $pop: { item: -1 } },
  fields: { item: 1, _id: 0 },
  new: false
}).item[0];
```