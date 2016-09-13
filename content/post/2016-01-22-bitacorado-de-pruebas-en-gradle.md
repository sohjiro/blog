---
title: "Bitacorado de pruebas en Gradle"
date: 2016-01-22 18:14:37 -0600
author: José Juan Reyes Zuñiga
comments: true
categories:
- groovy
tags: [groovy, gradle]
---

Hace tiempo al correr unas pruebas con un proyecto de gradle tuve la necesidad de saber el orden y la forma en que se estaban corriendo ciertas pruebas, gradle arroja este resultado al final de la ejecución, sin embargo yo quería un bitacorado al momento de la ejecución, para lo cual buscando en la documentación me encontre con el [TestLoggingContainer][1], del cual pude obtener este fragmento:

{{<highlight java>}}
apply plugin: 'java'

test {
  testLogging {
    // set options for log level LIFECYCLE
    events "failed"
      exceptionFormat "short"

      // set options for log level DEBUG
      debug {
        events "started", "skipped", "failed"
          exceptionFormat "full"
      }

    // remove standard output/error logging from --info builds
    // by assigning only 'failed' and 'skipped' events
    info.events = ["failed", "skipped"]
  }
}
{{</highlight>}}

En donde pongo todo los tipos de eventos del proyecto que son `events "started", "passed", "skipped", "failed"` y con ello obtengo una salida como la siguiente:

![Screenshot 1](/images/test_logging.png)

Muy útil cuando no queremos hacer bitácora manual de que pruebas se están corriendo, Gradle ya cuenta con ella.

 [1]: https://docs.gradle.org/current/dsl/org.gradle.api.tasks.testing.logging.TestLoggingContainer.html
