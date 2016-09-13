---
title: "MicroServicios con Groovy"
date: 2016-03-08 21:38:08 -0600
comments: true
author: José Juan Reyes Zuñiga
published: true
comments: true
tags: [groovy, servlet]
categories:
- groovy
- architecture
---

Si bien, existen muchas tecnologías muy completas que permiten la creación de servicios robustos, a veces me he visto en la necesidad de hacer algo pequeño. muy concreto pero mantenible, y que pueda soportar un volumen determinado. Es por esto que me he apoyado del poder que ofrece Groovy con ayuda de los [Groovlets][1].

La parte que me gusta de este acercamiento es que el poder del Scripting se pasa al navegador, o en este caso, a un cliente que consume algún servicio web. Cuando usamos _Groovlets_ tenemos disponible lo sisguiente:

* _request_ - `HttpServletRequest`
* _response_ - `HttpServletResponse`
* _application_ - `ServletContext`
* _session_ - `HttpSession`
* _out_ - `PrintWriter`
* _headers_ - `Header[]`
* _params_ - Un objeto tipo `Map` que contiene los parámetros

<!-- more -->

Ahora bien, que la configuración XML si es el caso es muy sencilla y sólo tenemos que agregar el Servlet de Groovy y hacer el mapeo.

{{<highlight xml>}}
<servlet>
  <servlet-name>Groovy</servlet-name>
  <servlet-class>groovy.servlet.GroovyServlet</servlet-class>
</servlet>

<servlet-mapping>
  <servlet-name>Groovy</servlet-name>
  <url-pattern>*.groovy</url-pattern>
  <url-pattern>*.gdo</url-pattern>
</servlet-mapping>
{{</highlight>}}

_Nota: Que el mapeo no necesariamente es estricto con la extensión, podemos usar la que querramos._

Y aunque la implementación que muestro no sería la más _adecuada_, sirve de ejemplo para mostrar en pocas líneas la mayoría de los elementos antes mencionado:

Me apoyo de un par de clases que _modelan_ un almacén de datos.

{{<highlight groovy>}}todos.groovy
class Todo {
  String description
}

@Singleton // Only one instance
class TodoManager {
  List<Todo> todos = []
}
{{</highlight>}}

Podemos jugar con el reponse directamente para decirle que cualquier respuesta sería JSON:

{{<highlight groovy>}}
todos.groovy
response.contentType = 'application/json'
{{</highlight>}}
Buscar algún encabezado en particular para validar nuestra solicitud:

{{<highlight groovy>}}
todos.groovy
def contentType = headers.find { k,v -> k.toLowerCase() == 'content-type' }?.value

if(contentType != "application/json"){
  response.status = HttpServletResponse.SC_BAD_REQUEST // We return a status code 400
  // Using the json method included
  json(status:"Please use 'application/json' header, just received ${headers} instead")
  return // And nothing more...
}
{{</highlight>}}

A partir de aquí podemos jugar con el método de envío y hacer algunas acciones, aquí una muestra muy simple:

{{<highlight groovy>}}
todos.groovy
switch(request.method.toLowerCase()){ // Validating the method
  case 'get':
    json(todos:TodoManager.instance.todos) // Using the instance
  break
  case 'post':
    Todo todo = new Todo(description:params?.todo ?: "No description")
    TodoManager.instance.todos << todo
    response.status = HttpServletResponse.SC_CREATED
    json(todo:todo)
  break
  default:
    response.status = HttpServletResponse.SC_BAD_REQUEST
    json(status:"Method '${request.method.toLowerCase()}' not supported")
}
{{</highlight>}}

Puedes incluir estos tres últimos fragmentos en un archivo y todo funcionará sin problemas. Aunque, nuevamente no es la forma más adecuada, muestra muy bien el potencial del simple uso del Groovlet.

Al final podrías usar `@Grab` para obtener las dependencias de *Jetty* y levantar el contenedor en el mismo archivo.

**Conclusión**: En un par de líneas puedes conseguir un servicio pequeño, entendible y listo para pasarse a un proyecto de Gradle que permita estructurarlo mejor para irle creciendo.

[1]: http://docs.groovy-lang.org/latest/html/api/groovy/servlet/GroovyServlet.html
