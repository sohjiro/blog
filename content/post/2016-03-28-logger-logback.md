---
title: "Uso de logback"
date: 2016-03-28 09:13:56 -0600
comments: true
author: Juan Francisco Reyes Silva
published: true
comments: true
tags: [groovy, log]
categories:
- groovy
---

En el proceso de desarrollo de software se implementan bitácoras o mejor conocidas como *loggers* que permiten tener información de salida útil al desarrollador en cuanto al correcto flujo de la aplicación.

Este registro se divide en secciones: Logger, Formatter y Handler.

<!-- more -->
* _Logger_: Es el responsable de captar el mensaje y pasarlo al marco de registro.

* _Formatter_: Su función es dar formato a la salida. toma el objeto binario y realiza la conversión a una representación de cadena

* _Appender_ o _Handler_: Se le entrega el mensaje con formato al Appender, el cual puede ser visualizado en diferentes formas como son: consola, archivo, base de datos, servicios de mensajería, escribir en un socket.

Existen ciertos niveles de logger para diferenciar el tipo de salida que queremos generar:

|**Nivel** |	**Descripción**|
|  --- | ---|
|FATAL |	Errores graves que causan la terminación prematura|
|ERROR |	Otros errores de ejecución o condiciones inesperadas|
|WARNING |	Se utiliza para situaciones que podrían ser potencialmente dañinas|
|INFO |	Eventos interesantes de tiempo de ejecución (inicio / apagado)|
|DEBUG |	Información detallada sobre el flujo a través del sistema|
|TRACE |	Información más detallada|

#Logback
Este logger pretende ser el sucesor de log4j, fue diseñado por Ceki Gülcü, fundador de log4j's.
Para poder usar este logger, se requiere del módulo logback.
Una configuración del archivo gradle queda de la siguiente manera:

{{<highlight groovy>}}
apply plugin:'groovy'

repositories{
  jcenter()
}

dependencies{
  compile 'org.codehaus.groovy:groovy-all:2.4.4'
  compile 'ch.qos.logback:logback-classic:1.1.6'
}
{{</highlight>}}

El archivo groovy que se estará manejando para obtener la bitácora será _logback.groovy_ el cual contiene el patrón de salida del logger además de especificar donde se mostrara dicha información.

{{<highlight groovy>}}
import static ch.qos.logback.classic.Level.INFO
import static ch.qos.logback.classic.Level.DEBUG

import ch.qos.logback.classic.encoder.PatternLayoutEncoder
import ch.qos.logback.core.ConsoleAppender

appender("CONSOLE", ConsoleAppender) {
  encoder(PatternLayoutEncoder) {
    pattern = "%d{HH:mm:ss.SSS} [%thread] %highlight(%-5level) %cyan(%logger{15}) - %msg %n"
  }
}

appender("FILE", FileAppender) {
  file = "example_logger.log"
  append = true
  encoder(PatternLayoutEncoder) {
    pattern = "%d{HH:mm:ss.SSS} %-5level %logger{30} %msg %n"
  }
}
root(DEBUG, ["CONSOLE","FILE"])
{{</highlight>}}


Ahora el archivo se crea una instancia de la clase Logger. Además de contar con el nivel del logger, respetando la configuración que se hizo en el archivo logback.groovy.

{{<highlight groovy>}}
import org.slf4j.Logger
import org.slf4j.LoggerFactory

Logger log = LoggerFactory.getLogger(getClass())

log.debug "*"*40
log.debug request.properties.toString()
log.error "Error"
log.warn "Warning"
log.info "Info"
log.trace "Trace"
{{</highlight>}}

Un ejemplo de como se vería:

![logback]( /images/logback.png)

## Acerca del patrón de salida

* `%d{HH:mm:ss.SSS}` Es la hora que se realizo el proceso
* `[%thread]` Indica el thread que inicio la tarea
* `%highlight(%-5level)` Brinda el color acorde al nivel de logger que se esta usando
* `%cyan(%logger{15})` Muestra el nombre de la clase que esta tomando el logger, en color azul
* `%msg` Muestra el msn que se manda acorde al nivel que se esta llamando
* `%n` Indica el final de la línea

Pueden encontrar el código de ejemplo [*aquí*][2].

[1]: http://logback.qos.ch/manual/introduction.html

[2]: https://github.com/reyes271292/logger_logback

