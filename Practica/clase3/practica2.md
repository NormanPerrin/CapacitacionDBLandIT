1.
```
db.facturas.aggregate([
    {
        $unwind: "$item"
    },
    {
        $group: {
            _id: "$cliente.region",
            Total: { $sum: "$item.cantidad" }
        }
    },
    {
        $project: {
            _id: 0,
            Region: "$_id",
            Total: 1
        }
    }
])
```
2.
```
db.facturas.aggregate([
    {
        $unwind: "$item"
    },
    {
        $group: {
            _id: "$cliente.region",
            Total: { $sum: "$item.cantidad" }
        }
    },
    // Me gustaria que no se haga un sort, sino que vaya reemplazando al máximo.
    { $sort: {Total: -1} },
    { $limit: 1 },
    {
        $project: {
            _id: 0,
            Region: "$_id",
            Total: 1
        }
    }
])

// Me hubiese gustado aplicar este paso, pero no sabía cómo devolver Región acá.
// {
//     $group: {
//         _id: null,
//         Total: {$max: "$total"}
//     }
// }
```
3.
```
db.facturas.aggregate([
    {
        $unwind: "$item"
    },
    {
        $group: {
            _id: "$cliente.region",
            Total: { $sum: "$item.cantidad" }
        }
    },
    {
        $match: {
            Total: {$gte: 10000}
        }
    },
    {
        $project: {
            _id: 0,
            Region: "$_id",
            Total: 1
        }
    }
])
```
4.
```
db.facturas.aggregate([
    {
        $group: {
            _id: "$cliente",
            cantidad: {$sum: {$size: "$item"}}
        }
    },
    { $sort: {"_id.apellido": 1} },
    {
        $project: {
            _id: 0,
            cantidad: 1,
            apellido: "$_id.apellido",
            nombre: "$_id.nombre",
            region: "$_id.region",
            cuit: "$_id.cuit"
        }
    }
])
```
5.
```
db.facturas.aggregate([
    {
        $group: {
            _id: "$cliente",
            cantidad: {$sum: {$size: "$item"}}
        }
    },
    { $match: { "_id.cuit": {$gt: 2700000000} } },
    { $sort: {"_id.apellido": 1} },
    {
        $project: {
            _id: 0,
            cantidad: 1,
            apellido: "$_id.apellido",
            nombre: "$_id.nombre",
            region: "$_id.region",
            cuit: "$_id.cuit"
        }
    }
])
```
6.
```
db.facturas.aggregate([
    { $group: {_id: "$cliente.cuit"} },
    { $match: {"_id": {$gt: 2700000000}} },
    { $group: {_id: null, Total: {$sum: 1}} },
    { $project: {_id: 0, Total: 1} }
])
```
7.
```
db.facturas.aggregate([
    { $group: {_id: "$cliente.cuit"} },
    { $match: {"_id": {$gt: 2700000000}} },
    { $group: {_id: null, Total: {$sum: 1}} },
    { $project: {_id: 0, Total: 1} }
])
```
8.
```
db.facturas.aggregate([
    { $unwind: "$item" },
    {
        $group: {
            _id: "$item.producto",
            Comprado: { $sum: "$item.cantidad" },
            Monto: { $sum: "$item.precio" }
        },
    },
    {
        $project: {
            _id: 0,
            Producto: "$_id",
            Comprado: 1,
            Monto: 1
        }
    }
])
```
9.
```
db.facturas.aggregate([
    { $unwind: "$item" },
    {
        $group: {
            _id: "$item.producto",
            Comprado: { $sum: "$item.cantidad" },
            Monto: { $sum: "$item.precio" }
        },
    },
    { $sort: {Monto: 1} },
    { $skip: 1 },
    { $limit: 2 },
    {
        $project: {
            _id: 0,
            Producto: "$_id",
            Comprado: 1,
            Monto: 1
        }
    }
])
```
10.
```
db.facturas.aggregate([
    { $unwind: "$item" },
    {
        $group: {
            _id: "$item.producto",
            personas: { $addToSet: {$concat: ["$cliente.apellido", " ", "$cliente.nombre"]} }
        }
    },
    {
        $project: {
            _id: 0,
            producto: "$_id",
            personas: 1
        }
    }
])
```
11.
```
db.facturas.aggregate([
    { $unwind: "$item" },
    {
        $group: {
            _id: "$item.producto",
            personas: { $addToSet: {$concat: ["$cliente.apellido", " ", "$cliente.nombre"]} }
        }
    },
    {
        $project: {
            _id: 0,
            producto: "$_id",
            personas: {$size: "$personas"}
        }
    },
    { $sort: {personas: -1} }
])
```
12.
```
db.facturas.aggregate([
    { $unwind: "$item" },
    {
        $group: {
            _id: "$cliente",
            total: { $sum: "$item.precio" }
        }
    },
    {
        $match: {
            total: {$gt: 3100000}
        }
    },
    {
        $project: {
            _id: 0,
            total: 1,
            cliente: { $concat: ["$_id.apellido", " ", "$_id.nombre"] }
        }
    }
])
```
13.
```
db.facturas.aggregate([
    { $unwind: "$item" },
    {
        $group: {
            _id: "$cliente.region",
            promedio: {$avg: "$item.precio"}
        }
    },
    {
        $project: {
            _id: 0,
            region: "$_id",
            promedio: 1
        }
    }
])
```
14.
```
db.facturas.aggregate([
    { $unwind: "$item" },
    {
        $group: {
            _id: "$nroFactura",
            total: {$sum: "$item.precio"}
        }
    },
    {
        $sort: {
            total: -1,
            _id: 1,
        }
    },
    {
        $project: {
            _id: 0,
            total: 1,
            nroFactura: "$_id"
        }
    }
])
```
15.
```
db.facturas.aggregate([
    { $unwind: "$item" },
    {
        $group: {
            _id: "$cliente",
            maximo: {$max: "$item.precio"}
        }
    },
    {
        $project: {
            _id: 0,
            maximo: 1,
            cliente: {$concat: ["$_id.apellido", " ", "$_id.nombre"]}
        }
    }
])
```
16.
```
function sumAllItems (nroFactura, cantidad) {
    return {
        nroFactura: nroFactura,
        itemsComprados: cantidad
    };
}

function mapValues () {
    var cantidadItem = 0;
    for (var i = 0; i < this.item.length; i++) {
        cantidadItem += this.item[i].cantidad;
    }
    emit(this.nroFactura, cantidadItem);
}

db.facturas.mapReduce(
    mapValues,
    sumAllItems,
    {
        out: {inline: 1}
    }
)
```
17.
```
db.facturas.aggregate([
    { $unwind: "$item" },
    {
        $group: {
            _id: { cliente: "$cliente", factura: "$nroFactura" },
            gastado: { $sum: "$item.precio" }
        }
    },
    { $match: {gastado: {$gt: 100000}} },
    {
        $project: {
            _id: 0,
            factura: "$_id.factura",
            gastado: 1,
            cliente: { $concat: ["$_id.cliente.apellido", " ", "$_id.cliente.nombre"]}
        }
    }
])
```
18.
```
```