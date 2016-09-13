+++
title= "Borrado batch en Grails"
date="2015-05-01 20:58:30 -0500"
author="José Juan Reyes Zuñiga"
comments= "true"
tags= ["groovy", "grails", "gorm"]
categories=["groovy","grails","development"]
+++

En esta ocasión les quiero compartir la solución a un problema que tuve al borrar una colección de objetos en grails y con el GORM, si bien podría hacerlo con HQL o con SQL usando las bondades de Hibernate me gusto más el acercamiento que les quiero presentar.

<!-- more -->
La necesidad era borrar un grupo de objetos en donde el contenido de su relación estuviera vacío, ejemplifico con la estructura de unas clases:

{{<gist neodevelop 54953d90cc778b71548a "domains.groovy" >}}

El primer acercamiento que tuve fue obtener la lista de elementos y hacer una condicional buscando los elementos vacíos, después borrar...

{{<gist neodevelop 54953d90cc778b71548a "delete1.groovy" >}}

Una vez hecho, mejoramos intentamos mejorar el código con una búsqueda mucho más refinada y ejecutando el borrado, para ello nos apoyamos de los **where queries**:

{{<gist neodevelop 54953d90cc778b71548a "delete2.groovy" >}}


Basado en la documentación de Grails:

> Since each where method call returns a DetachedCriteria instance, you can use where queries to execute batch operations such as batch updates and deletes.

Sin embargo, este acercamiento tiene un problema, manda un error cuando se busca por las relaciones del objeto y no permite el borrado. El error: `org.springframework.dao.InvalidDataAccessResourceUsageException: Queries of type SizeEquals are not supported by this implementation`

### La solución que me gustó

Usamos **Detached Criteria** para resolver este problema, por que:

- No están asociados con una sesión o conexión, lo cual permite formularlos y reusarlos.
- También cuenta con métodos batch: `deleteAll`, `updateAll`
- Permiten proyecciones y subqueries, que es lo que estamos buscando para resolver nuestro problema

Finalmente nuestra solución es:

{{<gist neodevelop 54953d90cc778b71548a "delete3.groovy" >}}

Con esto, tenemos una búsqueda refinada y el borrado de los elementos directo, inclusive el método `deleteAll` regresa un entero con la cantidad de registros afectados.

Esto me fue de mucha utilidad y ojalá también lo sea para ustedes en algún momento.
