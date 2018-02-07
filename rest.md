# REST
REpresentetional State Transfer. Estilo o principios de Arquitectura software para sistemas de hipermedia distribuidos. También se puede ver como una serie de restricciones.

Hay una serie de características clave con la que debe contar:
* Stateless
* Operaciones definidas
* Identificadores de recursos
* Hipermedios

### Cliente-Servidor
Implementa una arquitectura cliente-servidor, que cuenta con estas características:
* Cliente dispara procesos, el Servidor reacciona y responde.
* Usualmente se mueve funcionalidad UI al cliente.
* El cliente se puede abtraer de cómo está implementado todo el servidor, cuántos hay, etc.

### Stateless
**Características:**
* Comunicación sin estado por naturaleza, o sea que cada comunicación debe contener toda la información para ser procesada.
* Abstraída del procesamiento de otros servidores: los servidores se abtraen de la implementación de otros.
* Bueno para escalabilidad, ya que no hay que compartir sesiones entre nodos, aumentar tamaño de memoria para guardar más sesiones, etc.
* Abstracción del contexto: es más fácil de seguir un proceso si todo el input necesario para analizarlo viene en el request y no está de antes.
* Comparado a Statefull es menos performante por info que se pasa por cada request.

### Interfaz uniforme
General a todos los componenetes que la implementen. Mejora la iteracción con el componente, ya que (en especial si es una inferfaz conocida) se puede saber sin ver la implementación cómo se debe interactuar con la misma.

REST está definido a partir de 4 restricciones de interfaz:
* Identificación de recursos. Los recursos están conceptualmente separados de la representación que se le retorna al cliente.
* Manipulación de recursos a través de la representación. La representación de un recurso le da suficiente información al cliente para operar con él.
* Mensajes auto-descriptivos. Cada mensaje debe dar suficiente información para describir como procesar el mensaje.
* HATEOAS (Hypermedia as the engine of application state). Habiendo accedido a un recurso, el cliente debería saber cómo seguir descubriendo todas las acciones disponibles y recursos que necesite. Autodescubrimiento de la API por los clientes.

### Restricciones sobre la URL
* No debe implicar acciones.
* Debera ser independiente del formato. Se puede pasar el formato como un header del request.
* Mantener jerarquía lógica.
* No filtrar, ordenar o buscar información mediante la URI.

### Safe methods
* No cambian el estado del sistema: GET, HEAD, OPTIONS, TRACE. Estos son idempotentes también, siempre van a dar el mismo resultado.
* Cambian: POST, PUT, DELETE PATCH.

### HTTP Status Codes
* 1xx: Respuestas informativas.
* 2xx: Peticiones correctas.
  * 200 - request realizado correctamente.
  * 201 - created.
  * 202 - accepted.
* 3xx: Redirecciones.
  * 301 - movido permanéntemente.
* 4xx: Errores del cliente.
  * 400 - mal request.
  * 401 - sin autorización.
  * 403 - prohibido.
  * 404 - recurso no encontrado.
  * 405 - método no permitido, por ej un GET ejecutado con POST.
* 5xx: Errores del servidor.
  * 500 - internal error.
  * 501 - sin implementar.
  * 503 - servicio no disponible.
  
### Headers
* Accept: Formato en el que el cliente quiere recibir el recurso, pudiendo indicar varios en orden de preferencia. Status code HTTP 406 en caso de qué la API no acepte ninguno de los formatos.
* Content-type: Indica el formato en el que la API está devolviendo el recurso.

### Auths
* HTTP Basic Auth: pass texto plano, con HTTPS se safa un poco más del lado del cliente.
* JWT: encriptar un valor, creando un token único que los usuarios usarán como identificador.
* 0Auth 2.0

### Versionado
Se puede agregar a la URI o como header del request (práctica preferida).

### Tener en cuenta
* Un request del cliente puede etiquetar su request como cacheable, esto solo tiene incidencia del lado del front.
