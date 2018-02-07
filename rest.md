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
* HATEOAS (Hypermedia as the engine of application state). Habiendo accedido a un recurso, el cliente debería saber cómo seguir descubriendo todas las acciones disponibles y recursos que necesite.

### Tener en cuenta
* Un request del cliente puede etiquetar su request como cacheable, esto solo tiene incidencia del lado del front.

