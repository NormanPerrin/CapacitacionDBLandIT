2.
```
db.facturas.createIndex({ nroFactura: 1 })

// 2.1
db.facturas.find(
    { nroFactura: {$gte: 1000, $lte: 1015} },
    { _id: 0, nroFactura: 1, fechaEmision: 1, condPago: 1, cliente: 1 }
)

// 2.2 se hace con .explain()
/*
 * El output de la consulta 2.1 con .explain() da como winning plan
 * una búsqueda que dice en su etapa FETCH que utilizó el índice nroFactura_1.
 * ...
 * Al ejecutarlo con .hint({$natural: 1}) se puede ver que cambia la búsqueda,
 * ahora hace un COLLSCAN
 */

// 2.3
db.facturas.find(
    { "cliente.apellido": "Malinez" }
).hint({ nroFactura: 1 })
```
3.
```
db.facturas.createIndex({"$**": "text"}, {default_language: "spanish"})

// 3.1
db.facturas.find({ $text: { $search: "TALADRO" } }).count()

// 3.2
db.facturas.find({ $text: { $search: "TALADRO TUERCA" } })

// 3.3
db.facturas.find({ $text: { $search: "/Ds FF/" } }).count()

// 3.4
db.facturas.find({ $text: { $search: "/30 Ds FF/" } }).count()

// 3.5
db.facturas.find({ $text: { $search: "/60 Ds FF/" } }).count()

/*
 * Da el mismo resultado para todas las consultas,
 * aunque no sea exactamente lo que se busca.
 */
```
4.
```
db.solicitudes.insert(
    [
        {
            nroSolicitud: 1,
            tipoSolicitud: "BUENA",
            fechaSolicitud: new Date()
        },
        {
            nroSolicitud: 2,
            tipoSolicitud: "SUPERADORA",
            fechaSolicitud: new Date()
        },
        {
            nroSolicitud: 3,
            tipoSolicitud: "ALFAJOR HABANNA",
            fechaSolicitud: new Date()
        }
    ]
)

// 4.1
db.solicitured.createIndex({ fechaSolicitud: 1 }, { expireAfterSeconds: 60 })

// 4.2 y 4.3
// Después de 1 minuto se borraron los documentos.
```
5.
```
db.facturas.find({ "cliente.region": "NEA" }).explain("executionStats")

// 5.1
db.facturas.createIndex({ "cliente.region": 1 })

// 5.2
/*
 * Ahora bajó unos milisegundos la consulta (casi no se nota si hay diferencia).
 * Examinó la mitad de documentos.
 */
```
6.
```
db.facturas.createIndex({ "cliente.region": 1, nroFactura: -1 })

// 6.1
db.facturas.find({ "cliente.region": "NEA" }).sort({ nroFactura: -1 }).explain("executionStats")
// (Antes) Utilizó el índice anteriormente creado por nroFactura y rechazó el índice de region. Tardando 24ms.

// 6.2
// (Creado) Usó el índice compuesto y tardó 10ms.

// 6.3
// Sin índices el query tardó 41ms.
```
7.
```
// 7.1
db.comercios.find()

// 7.2
db.comercios.createIndex({ ubicacion: "2d" })

// 7.3
db.comercios.find({ ubicacion: {$near: [-58.420000, -34.580000], $maxDistance: 0.5 } })

// 7.4 Disminuyen los resultados

// 7.5 Aumentan la cantidad de resultados
```
8.
```
db.libros.update({ titulo: /mongodb/i }, { $set: { idioma: "english" } })

db.libros.createIndex({ titulo: "text" }, { default_language: "spanish", language_override: "idioma" })
```