a.
```js
function imprimirArray (arr) {
  arr.forEach(function (elem) {
    print(elem.producto);
  });
}
```
b.
```js
var documento = db.facturas.find({ nroFactura: 5000 }).next()

imprimirArray(documento.item)
```
c.
```js
var documento = db.facturas.find({ nroFactura: 1330 }).next()

documento.item[0].precio = 15

db.items.insert(documento.item[0])
```
d.
```js
var documento = db.facturas.find({ nroFactura: 1144 }).next()

for (var i = 0; i < documento.item.length; i++) {
    documento.item[i].cantidad += 10;
}

db.facturas.update({ nroFactura: 1144 }, documento)
```
e.
```js
var documento = db.facturas.find({ "cliente.apellido": "Manoni" })
    .sort({ nroFactura: -1 })
    .limit(1)
    .next()

for (clave in documento) {
    var objeto = {};
    if (clave == "item") objeto[clave] = documento[clave].map(function (item) {return item.producto});
    else objeto[clave] = documento[clave];
    print(objeto);
}
```
f.
```js
var documento = db.facturas.find({ nroFactura: 2345 }).next()

db.facturas.remove(documento)

delete documento.condPago;
delete documento.fechaVencimiento;

db.facturasErroneas.insert(documento);
```
g.
```js
var documento = db.facturas.find({ nroFactura: 1020 }).next()

if (documento.condPago == "CONTADO") {
    documento.porcDescuento = 10
    db.facturas.update({ nroFactura: 1020 }, documento)
}
```
h.
```js
var items = db.facturas.aggregate(
    { $unwind: "$item" },
    { $group: {_id: {producto: "$item.producto", precio: "$item.precio" }} }
)
.toArray()
.map(function (item) {
    return {
        producto: item._id.producto,
        precio: item._id.precio
    }
})

db.items.insert(items)
```
i.
```js
var clientes = db.facturas.aggregate(
    {
        $group: {
            _id: { cliente: "$cliente" },
            cantidad: { $sum: 1 }
        }
    }
)
.toArray()
.map(function (doc) {
    return Object.merge(doc._id.cliente, {cantidadFacturas: doc.cantidad, fecha: ISODate()})
})

db.clientes.insert(clientes)
```
j.
```js
var cliente = db.facturas.aggregate(
    {
        $group: {
            _id: { cliente: "$cliente" },
            cantidad: { $sum: 1 }
        }
    },
    { $sort: {cantidad: 1} },
    { $limit: 1 }
).next()

db.clientes.remove({ cuit: cliente._id.cliente.cuit })
db.facturas.remove({ "cliente.cuit": cliente._id.cliente.cuit })
```
k.
```js
var cursor = db.facturas.find({ "cliente.region": "CABA" })

while (cursor.hasNext()) {
    var actual = cursor.next();
    if (actual.item.length >= 2) {
        for (var i = 0; i < actual.item.length; i++) {
            delete actual.item[i].precio
        }
        db.facturas.update({ nroFactura: actual.nroFactura }, actual)
    }
}
```
l.
```js
db.system.save({ _id:"miSuma", value: imprimirArray })

db.loadServerScripts()
```
m.
```js
function comparar (coleccion1, coleccion2) {
    var facturasDeClientes = db.facturas.aggregate(
        {
            $group: {
                _id: "$cliente",
                facturas: {$addToSet: "$nroFactura"}
            }
        }
    );

    while (facturasDeClientes.hasNext()) {
        var facturaActual = facturasDeClientes.next();
        var encuentro = db.clientes.find({ cuit: facturaActual._id.cuit });
        if (!encuentro.hasNext()) {
            printjson(facturaActual.facturas);
            facturaActual._id.fecha = ISODate();
            facturaActual._id.cantidadFacturas = 0;
            db.clientes.insert(facturaActual._id);
        }
    }
}
```