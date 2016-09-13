+++
title= "Clusterizacion con Camel"
date="2015-04-07 19:56:54 -0500"
author="Jorge Acosta Lemus"
comments="true"
categories=["development","eip"]
+++

Camel ofrece distintas soluciones para ser escalado o para distribuir la carga en diferentes instancias, la soluciones que ofrece dependerá de como se encuentra nuestra infraestructura ( y configuración).

* Misma JVM y CamelContext
* Misma JVM pero diferente CamelContext
* Diferente JVM y CamelContext
<!-- more -->

El problema que me vi envuelto fue de estas tres, la ultima, el clusterizar camel que se encontraban en diferentes JVM y CamelContext. Y en particular tuve un problema de mensajes duplicados. Para esto camel ofrece ciertas soluciones, un componente llamado **Idempotent Consumer**. El Idempotent Consumer pertenece a los patrones de EIP se usa para filtrar los mensajes duplicados. Este modelo se implementa utilizando la clase IdempotentConsumer. Este utiliza una expresión para calcular una cadena de mensaje ID único para un intercambio de mensajes, este ID puede ser consultado en la IdempotentRepository para ver si se ha visto antes, si se tiene no es tomado para ser procesado, en cambio si no se tiene, entonces el mensaje se procesa y la ID se añade al repositorio.

Hay varios tipos de IdempotentRepository:

* MemoryIdempotentRepository
* FileIdempotentRepository
* HazelcastIdempotentRepository (Available as of Camel 2.8)
* JdbcMessageIdRepository (Available as of Camel 2.7)
* JpaMessageIdRepository

{{<highlight groovy>}}

@Grab(group='org.slf4j', module='slf4j-api', version='1.7.10')
@Grab(group='org.apache.camel', module='camel-core', version='2.12.0')
@Grab(group='org.apache.camel', module='camel-mail', version='2.12.0')

import org.apache.camel.impl.DefaultCamelContext
import org.apache.camel.builder.RouteBuilder
import org.apache.camel.processor.idempotent.FileIdempotentRepository

def camelContext = new DefaultCamelContext()
camelContext.addRoutes(new RouteBuilder() {
  def void configure() {
    from("imaps://imap.gmail.com?username=jorge@makingdevs.com"
      + "&password=m4k1ngd3vs"
      + "&consumer.delay=6000")
    .idempotentConsumer( header("Message-ID"),
      FileIdempotentRepository.fileIdempotentRepository(
        new File("idempotentRepository.txt")))
    .to("log:groovymail?showAll=true&multiline=true") } })

camelContext.start()
addShutdownHook{ camelContext.stop() }
synchronized(this){ this.wait() }
{{</highlight>}}

Este es un script ejemplo el cual utiliza `FileIdempotentRepository` utilizando un archivo ejemplo para llevar el control, si exploramos el archivo ahí se encuentra los id de los mensajes procesados.

![Camel output](/images/camel_output.png)

Asi si hay un mensaje el cual ya se encuentra dentro de este archivo se ignora y no es procesado. En mi caso utilize JpaMessageIdRepository dentro de grails y fue muy simple utilizar este componente solo agregue la dependencia de camel sql en el buildConfig.groovy

{{<highlight groovy>}}
runtime 'org.apache.camel:camel-sql:2.13.0’
{{</highlight>}}


y agregue el bean en resources.groovy

{{<highlight groovy>}}
import org.apache.camel.processor.idempotent.jdbc.JdbcMessageIdRepository

beans = {
  messageIdRepository(JdbcMessageIdRepository,ref('dataSource'),'jdbcProcessorName')
}
{{</highlight>}}

y por ultimo agregue el _idempotentComponent_.
