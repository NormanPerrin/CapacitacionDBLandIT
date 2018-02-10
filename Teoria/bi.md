# Business Intelligence

## Glosario
* Datamart: El Data mart es un sistema orientado a la consulta, en el que se producen procesos batch de carga de datos (altas) con una frecuencia baja y conocida. Es consultado mediante herramientas OLAP (On line Analytical Processing - Procesamiento Analítico en Línea) que ofrecen una visión multidimensional de la información. Sobre estas bases de datos se pueden construir EIS (Executive Information Systems, Sistemas de Información para Directivos) y DSS (Decision Support Systems, Sistemas de Ayuda a la toma de Decisiones). Subconjunto de un datawarehouse, suelen tener alcances parecidos a los de un proyecto.
* Dimensión: punto de vista por el que quiero analizar la información. Se estructuran de forma jerárquica según el análisis que querramos hacer.
* Claves subrogadas: identificadores creados en DW para saltear limitación de claves existentes y poder guardar datos replicados con mismos ids originales. Es mejor si estas claves son numéricas enteras así es más performante.
* Hechos: un evento relevante al negocio, indicadores de negocio que dan sentido al análisis de dimensiones.
* Indicador clave: valores correspondientes que hay que alcanzar y suponen un grado de asunción de objetivos. Proporcionan información útil sobre el rendimiento de una empresa.
  * KPI (Key Performance Indicator)
  * KGI (Key Goal Indicator)

## Sistema de información
Conjunto de elementos orientados al tratamiento y administración de datos e información, organizados y listos para su uso posterior, generados para cubrir una necesidad u objetivo.

## Procesamiento de datos

### OLTP (On-Line Transactional Processing)
* Bases de datos orientadas al procesamiento de transacciones.
* Una transacción genera un proceso atómico, puede involucrar operaciones de inserción, modificación y borrado de datos.
* El proceso transaccional es típico de las bases de datos operacionales.
* El acceso a los datos está optimizado para tareas frecuentes de lectura y escritura.
* Los datos se estructuran según el nivel aplicación (programa de gestión a medida, ERP o CRM implantado).
* Los formatos de los datos no son necesariamente uniformes en los diferentes departamentos.
* Favorecido por la normalización.
* Acceso para escritura, lectura, modificación.

### OLAP (On-Line Analytical Processing)
* Bases de datos orientadas al procesamiento analítico. Este análisis suele implicar, generalmente, la lectura de grandes cantidades de datos para llegar a extraer algún tipo de información útil: tendencias de ventas, patrones de comportamiento de los consumidores, elaboración de informes complejos... etc. Este sistema es típico de los datamarts.
* Acceso a los datos de sólo lectura. La acción más común es la consulta.
* Los datos se estructuran según las áreas de negocio, y los formatos de los datos
están integrados de manera uniforme en toda la organización.
* El historial de datos es a largo plazo, normalmente de dos a cinco años.
* Las bases de datos OLAP se suelen alimentar de información procedente de los sistemas operacionales existentes, mediante un proceso de extracción, transformación y carga (ETL).
* Favorecido por la desnormalización.
* Acceso para escritura solamente.

## Toma de decisiones
La toma de decisiones se puede hacer por intuición o realidad:
1. Identificar problema.
2. Encontrar alternativas.
3. Evaluar resultados de cada una.

## BI (Business Inteligence)
> Proceso de transformación de datos en información, y la información en conocimiento, de forma que se pueda optimizar el proceso de toma de decisiones en los negocios.

No solo interfiere el nivel estratégico más alto, sino que es cross a toda la organización, ya que todos afectan el desempeño de una empresa y por lo tanto, las decisiones que tomen.

### Conocimiento
* Datos: mínima unidad semántica, elementos primarios de información. Por sí solos no aportan a la toma de decisiones.
* Información: conjunto de Datos + Contexto. Tienen un significado, por lo tanto son útiles para la toma de decisiones.
* Conocimiento: Información + Análisis

### KPIs
Métricas (cuantificables) que ayudan a una organización a definir un camino y progreso.

**Qué se hacen con los KPIs?**
* Mantiene registro histórico: el tiempo es la dimensión más importante para análisis.
* Compartirlos: debe poder ser exportable.
* Presentarlos: deben tener un formato consumible por los distintos niveles que necesiten hacerle análisis.

### Usos
* Tecnológicos
  * Ordenar, depurar y afianzar datos.
  * Optimizar rendimiento sistemas.
* Competitiva
  * Seguimiento plan estratégico.
  * Aprender de errores pasados.
  
### Desnormalización
La normalización ayuda a mantener la integridad y estructura de los datos. Eliminando redundancia de datos y desacomplando relaciones, haciendo el mantenimiento más fácil.

Este modelo puede jugar en contra si quiero proveer información de la manera más rápida posible y sin molestar a los servidores principales. Para eso debería tener redundancia de datos por lo menos para tener un histórico. En este caso el mantenimiento no es tan importante, la actualización se hace en procesos batch.

## Datawarehouse (DW)
> Base de datos corporativa que se caracteriza por integrar y depurar información de una o más fuentes distintas, para luego procesarla permitiendo su análisis desde infinidad de peRspectivas y con grandes velocidades de respuesta.

**Características**
* Integrado: estructura de datos consistente y con diferentes niveles granularidad.
* Temático: se suelen armar tablas o data marts por tema para que sea más fácil de consumir ya que toda la información relevante a un tema se encontrará en un solo lugar.
* Histórico: el tiempo es parte implícita de la información contenida en un Datawarehouse.
* No volátil: esta información existe para ser leída pero no modificada. Por lo tanto es permanente.
* Debe tener un índice para consultar.
* Pueden tener columnas con valores mapeados a otros más eficientes. Ej: Hombre --> 1, Mujer --> 0.
* También en los campos suelen separarse para hacer búsquedas más fáciles. Ej: nombre: "Norman Perrin" --> nombre y apellido...
* Los valores nulos no se cargan, sino que se reemplazan por valores por defecto. Esto se debe tener en cuenta cuando se hagan cálculos con estos valores.
* Se deja la mayor cantidad de información calculada posible con mayor nivel de granularidad.

## ETL (Extracción Transformación Carga)
El datawarehouse se alimenta de ETLs, desde diferentes fuentes. No se eliminan datos, sino que se limpian y a lo sumo se separan y almacenan en otro lado.

**Procedimiento:**
* Staging: Área que aloja las transformaciones en curso que va realizando el ETL, para tener una mejor performance.
* ODS (Operational Data Store) [Opcional]: transformaciones y operaciones correspondientes, almacenando historia de operaciones en ODS. Estos datos suelen estar normalizados para tener un mejor control de escritura.
* DW (Datawarehouse): Se alimenta a los modelos / cubos / datamarts. Puede contener toda la historia o un rango si cuenta con la historia en el ODS.

## Enfoques

### Ralph Kimball
Datawarehouse con datamarts independientes entre sí, modelado dimensionalmente y tienen foco por proceso.

### Bill Inmon
Datawarehouse modelado con (3FN), con datamarts que pueden ser generados a partir de este datawarehouse, haciéndolo más flexible y adaptable.

## Gestión de cambios en dimensiones
Para gestionar este problema y poder seguir haciendo análisis históricos se hace uso de un concepto llamado Dimensión Lentamente Cambiante (SCD), estableciendo algunos métodos que deberán ser tenidos en cuenta en el ETL.

### SCD1 Sobreescritura
Cuando hay un cambio, sobreescribimos el valor antiguo, perdiendo la historia.

### SCD2 Nueva fila
Se agrega un campo con fechas *"fecha_desde"*, *"fecha_hasta"* y también puede agregarse *"activo"*.

La idea es que ante un nuevo registro se cambie el registro válido por el nuevo y se actualicen las fechas, pudiendo hacer un análisis histórico luego.

### SCD3 Nueva columna
Cuando hay un nuevo valor, agregamos otra columna con el valor viejo para guardar en la fila con el valor más nuevo, cuál es el anterior, y así con los siguientes.

Para esto tendremos que considerar el uso de claves subrogadas.

## Modelado DW
El proceso de modelado consiste en los siguientes pasos:
1. **Elegir proceso de negocio:** área a modelar, depende de los requerimientos.
2. **Establecer el nivel de granularidad:** depende de los requerimientos del negocio y qué detalles agrupaciones quieran implementar.
3. **Elegir dimensiones:** definir conjunto de atributos relevantes al análisis.
3. **Identificar medidas y tablas de hechos:** surgen de los procesos de negocio, se deben definir los atributos que se desean analizar, su agrupamiento de datos, teniendo en cuenta las dimensiones.

### Estrella
?

### Copo de nieve
?
