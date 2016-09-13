+++
title= "Lectura de correo con Apache Camel + Groovy"
date="2014-08-26 18:29:26 -0500"
author= "Jorge Acosta Lemus"
comments= "true"
categories=["development"]
+++

Hola a todos es un gusto contribuir al blog de makingdevs.com y mostrarles un poco de lo que es Apache Camel, para ellos hablaremos primero de su definición.

[Apache Camel][1] es un framework de integración de código abierto, basado en [Enterprise Integration Patterns (Patrones de Integración Empresarial)][3]. Camel nos permite definir las reglas de enrutamiento o mediación con ayuda de un lenguaje especifico (DSL), incluyendo un API basada en Java o mediante una configuración XML. El uso de un lenguaje específico del dominio significa que Apache Camel es capaz de soportar un comportamiento automático de las reglas de ruteo en un entorno de desarrollo integrado usando código Java sin gran cantidad de archivos de configuración XML.
<!-- more -->

Con ayuda de camel y Mail Component (componente de e-mail de Camel) realize un script para la lectura de un correo Gmail, filtrando el procesamiento de los mismo por su subject y escupiendo el contenido a un endPoint de log.

Pero si son curiosos ustedes se preguntaran __¿Que es un endPoint?__. Un endpoint es la interface a través de la cual los sistemas externos pueden enviar y recibir mensajes, permitiendo así la integración de sistemas en Camel. La función de un endpoint es crear productores y consumidores, lo que nos permite usar este endpoint como to y from dentro de una ruta Camel. Asi se denota un endpoint URIs siguiendo el siguiente formato: __[componente]:[contexto]?[opciones]__.

### Producers y Consumers

Un productor es el encargado de proveer los mensajes, siendo el puente de comunicación con el sistema externo, no procesa la información solo provee el mensaje, en este ejemplo el correo es el productor. Un consumidor es el encargado de recibir el mensaje que el productor obtiene y así procesar el mensaje o inclusive partir dicho mensaje para que sea procesado por otro consumidor. Bueno después de una pequeña introducción a Camel les muestro mi script en la cual hago lectura del correo filtro los mensajes por su subject y los arrojo a un log y no solo puede ser un log gracias a camel este puede ser un bean, FTP, intancia de amazon, un archivo, [casi cualquier cosa][2]. Nota necesitamos las dependencias de camel core y camel mail para el siguiente ejemplo:

{{<highlight groovy>}}
@Grab(group='org.apache.camel', module='camel-core', version='1.6.0')
@Grab(group='org.apache.camel', module='camel-mail', version='1.6.0')

import org.apache.camel.impl.DefaultCamelContext
import org.apache.camel.builder.RouteBuilder

def camelContext = new DefaultCamelContext()
camelContext.addRoutes(new RouteBuilder() {
  def void configure() {
    from("imaps://imap.gmail.com?username=user"
    + "&password=password"
    + "&deleteProcessedMessages=false"
    + "&processOnlyUnseenMessages=true"
    + "&consumer.delay=6000")
    .filter {it.in.headers.subject.contains('camel')}
    .to("log:groovymail?showAll=true&multiline=true")
  }
})
camelContext.start()

addShutdownHook{ camelContext.stop() }
synchronized(this){ this.wait() }
{{</highlight>}}

Notaran que al final del script hay una declaración `camelContext.start()`. El _CamelContext_ representa una sola base de reglas de enrutamiento Camel. Se utiliza el CamelContext de una manera similar al ApplicationContext. Y asi tenemos un pequeño ejemplo de lectura de correo con ayuda de Camel.

Como vemos Camel nos permite integrar sistemas muy facilmente. Espero les agradece este pequeño articulo y les sea de gran ayuda, dudas y comentarios son bienvenidas. Salu2

 [1]: http://camel.apache.org/
 [2]: http://camel.apache.org/components.html
 [3]: http://www.enterpriseintegrationpatterns.com/toc.html
