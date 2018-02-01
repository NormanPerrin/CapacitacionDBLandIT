a.
```js
    db.facturas.find().count()
```
b.
```js
    db.facturas.findOne({}, {_id: 0})
```
c.
```js
    db.facturas.find({
      fechaEmision: {$gt: new Date("23/02/2014")},
      nroFactura: {$lt: 1500}
    })
```
d.
```js
    db.facturas.find({
      item: {$elemMatch: {producto: "CORREA 10mm"}}
    }, {
      cliente: 1,
      _id: 0
    })
      .sort({ "cliente.apellido": 1 })
```
e.
```js
    db.facturas.find({
      nroFactura: {$gt: 2500, $lt: 3000}
    }, {
      "cliente.nombre": 1,
      "cliente.apellido": 1,
      _id: 0
    })
```
f.
```js
    db.facturas.find({
      nroFactura: {$in: [5000, 6000, 7000, 8000]}
    }, {
      fechaVencimiento: 1
    })
```
g.
```js
    db.facturas.find({
      "cliente.apellido": /^z/i
    })
      .sort({ nroFactura: 1 })
      .limit(5)
```
h.
```js
    db.facturas.find({
      $or: [{"cliente.region": "CENTRO"}, {condPago: "CONTADO"}]
    })
      .sort({ nroFactura: -1 })
      .skip(4)
      .limit(5)
```
i.
```js
    db.facturas.find({
      "cliente.apellido": {
        $not: {$in: ["Zavasi", "Malinez"]}
      }
    })
```
j.
```js
    db.facturas.find({
      item: {$elemMatch: {cantidad: 15}}
    }, {
      "item.$": 1,
      _id: 0
    })
      .map(function (prod) {return prod.item[0].producto})
```
k.
```js
    db.facturas.find({
      "cliente.cuit": 2038373771,
      condPago: "30 Ds FF",
      fechaVencimiento: {$gte: new Date("2014/03/20"), $lte: new Date("2014/03/24")}
    })
```