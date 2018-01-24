a.
```
    db.facturas.find({
      "cliente.apellido": {
        $not: {$eq: "Manoni"},
        $regex: /.*i.*/i
      }
    }, {
      nroFactura: 1,
      _id: 0
    })
```
b.
```
    db.facturas.find({
      "cliente.apellido": /i$/,
      "cliente.region": "CABA",
      item: {$elemMatch: {producto: /^TUERCA.*/}}
    })
```
c.
```
    db.facturas.find({
      item: {$elemMatch: {producto: /^CORREA.*/}}
    })
```
d.
```
    db.facturas.find({
      item: {$elemMatch: {cantidad: {$gt: 12}}}
    }, {
      cliente: 1,
      _id: 0
    })
```
e.
```
    db.facturas.find({
    item: {
        $not: {$elemMatch: {producto: /^SET HERRAMIENTAS$/}}
    }
})
```
f.
```
    function (cursor) {
      while (cursor.hasNext()) {
        var factura = cursor.next()
        print('Factura ' + factura.nroFactura + ': ' + factura.cliente.apellido + 'compró ' + factura.item.length + ' items')
      }
    }
```
g.
```
    db.facturas.insert({
        "cliente" : {
            "apellido" : "Perrin",
            "cuit" : 1212892212.0,
            "nombre" : "Norman",
            "region" : "CENTRO"
        },
        "condPago" : "CONTADO",
        "fechaEmision" : ISODate("2014-02-20T00:00:00.000Z"),
        "fechaVencimiento" : ISODate("2014-02-20T00:00:00.000Z"),
        "item" : [
            {
                "cantidad" : 1.0,
                "precio" : 50.0,
                "producto" : "DESTORNILLADOR"
            }
        ],
        "nroFactura" : 999.0
    })
```
h.
```
    db.otraColeccion.insert([{_id:1},{_id:1},{_id:2}], {ordered: false})
```
i.
```
    var bulk = db.facturas.initializeOrderedBulkOp();

    bulk
      .find({ "cliente.apellido": "Lavagno" })
      .update({ $set: {"cliente.tipo": "VIP"} });

    bulk
      .find({ nroFactura: {$gte: 2000, $lte: 2222} })
      .remove();

    bulk.execute();
```
j.
```
    db.facturas.remove({ "cliente.region": "CENTRO" })
```
k.
```
    var factura_id = db.facturas
      .find({
        "cliente.apellido": "Lavagno",
        item: {$elemMatch: { producto: /^SET HERRAMIENTAS$/ }}
      }, {
        _id: 1
      })
      .sort({ nroFactura: -1 })
      .limit(1)

    db.facturas.remove(factura_id)
```
l.
```
    db.facturas
      .update({
        nroFactura: 1501
      }, {
        $inc: { nroFactura: 1 }
      })
```
m.
```
    db.facturas
      .update({
        nroFactura: 1500
      }, {
        condPago: "30 Ds FF"
      })
```
n.
```
    db.facturas
      .update({
        nroFactura: 1510
      }, {
        $inc: { nroFactura: -9 }
      })
```
o.
```
    db.facturas
      .update({
        nroFactura: 1515
      }, {
        $inc: { vistas: 1, contador: -1 }
      })
```
p.
```
    db.facturas
      .update({
        nroFactura: 1000
      }, {
        $push: {
          item: {
            "cantidad" : 2,
            "precio" : 20,
            "producto" : "DESTORNILLADOR"
          }
        }
      })
```
q.
```
    db.facturas
      .update({
        nroFactura: 1000
      }, {
        $pop: { item: -1 }
      })
```
r.
```
    db.facturas.update(
      { nroFactura: 1000 },
      { $pull: { item: { producto: /^CORREA 10mm$/} } },
      { multi: false }
    )
```
s.
```
    var factura = db.facturas.find({ nroFactura: 1001 })

    delete factura.item

    db.facturas.update(
        { nroFactura: 1001 },
        { factura }
    )
```
t.
```
    db.facturas.update(
        { nroFactura: 1001 },
        { $unset: {item: ""} }
    )
```
u.
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
v.
```
    db.facturas.update(
      { "cliente.apellido": "Lavagno" },
      { $set: { "cliente.tipo": "VIP" } },
      { multi: true }
    )
```
w.
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
x.
```
    db.facturas.update(
      { nroFactura: 9000 },
      { cliente: { apellido: "Gonzalez", nombre: "Julio" }, nroFactura: 9000 },
      { upsert: true }
    )
```
y.
```
    db.facturas.update(
      { "cliente.apellido": "Gonzalez", "cliente.nombre": "Julio" },
      { $addToSet: { intereses: ["Plomeria", "Electronica"] } },
      { multi: true }
    )
```
z.
```
    var factura = db.facturas.find({ nroFactura: 9000 }).next()
    db.facturas.update(
      { nroFactura: 9000 },
      { x: Math.random() }
    )

    // Sí, una forma es consultando por el documento que tenga el campo x:
    db.facturas.find({ x: { $exists: true } })
```