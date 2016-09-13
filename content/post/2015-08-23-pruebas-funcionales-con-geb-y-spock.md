---
title: "Pruebas funcionales con Geb y Spock"
date: 2016-03-07 23:47:26 -0500
author: Gamaliel Jiménez García
published: true
comments: true
tags: [groovy,testing,spock,geb]
categories:
- groovy
- testing
- spock
- geb
---

Las pruebas funcionales se utilizan para verificar que los flujos de una aplicación que se definen en los casos de uso o historias de usuario funcionen correctamente; son pruebas difíciles de implementar ya que deben realizarse desde la perspectiva del usuario y muchas veces las interfaces de usuario cambian constantemente.

Geb es una herramienta para escribir pruebas funcionales con Groovy que hace uso del [*WebDriver de Selenium*][1] para la automatizacion del navegador y toma varias ideas de la biblioteca jQuery para la interacción con los elementos. Utiliza el patrón de diseño [*Page Object*][2] para mapear los elementos de las páginas en clases que representan cada una de las vistas.

<!-- more -->
## CONFIGURACIÓN DE GRADLE

A continuación se muestra la implementación de una prueba funcional integrando Geb con el framework de pruebas Spock.

El primer paso es obtener las dependencias de Geb,Spock y el Selenium Driver para los diferentes navegadores. Para este ejemplo voy a utilizar Gradle para la ejecución de las pruebas y la administración de las dependencias.


{{<highlight groovy>}}
build.gradle
apply plugin:"groovy"

repositories{
  jcenter()
}

ext{
  drivers = ["firefox","chrome"]
  groovyVersion = "2.4.4"
  spockGroovyVersion = "2.4"
  gebVersion = "0.12.1"
  seleniumVersion = "2.44.0"
}

dependencies{
  testCompile "org.codehaus.groovy:groovy-all:${groovyVersion}"
  testCompile "org.gebish:geb-spock:${gebVersion}
  testCompile "org.spockframework:spock-core:1.0-groovy-${spockGroovyVersion}"

  drivers.each{ driver ->
    testCompile "org.seleniumhq.selenium:selenium-${driver}-driver:${seleniumVersion}"
  }
}
{{</highlight>}}

Una vez que se definen las dependencias necesarias se crean las tareas para la ejecución de las pruebas en cada navegador que compone la lista.
Geb permite realizar capturas de pantalla en cualquier punto del flujo de la aplicación que se está probando; para especificar el directorio donde se encontrarán estas imagenes se agrega la propiedad "geb.build.reportsDir" a las propiedades del sistema.

{{<highlight groovy>}}
drivers.each{ driver ->
  task "${driver}Test"(type:Test){
    reports{
      html.destination = reporting.file("$name/tests")
    }

    outputs.upToDateWhen{ false }

    systemProperty "geb.build.reportsDir",reporting.file("$name/geb")
    systemProperty "geb.env", driver
  }
}
{{</highlight>}}

Para que la automatización del navegador sea posible con Chrome es necesario descargar la versión más reciente del [*WebDriver para Chrome*][3] y definir en la propiedad del sistema el valor del directorio donde se encuentra.
Finalmente se sobreescribe la tarea de test para que dependa de las creadas anteriormente y todas las pruebas se ejecuten al ejecutar el comando ```gradle test```.

{{<highlight groovy>}}
chromeTest{
  systemProperty "webdriver.chrome.driver","${System.properties["user.home"]}/.grails/chromedriver"
}

test{
  dependsOn drivers.collect{ driver -> tasks["${driver}Test"] }
  enabled = false
}
{{</highlight>}}
## CONFIGURACIÓN DE GEB

Antes de comenzar a escribir las pruebas es necesario crear el archivo de configuración de Geb.
Aquí se crean las instancias del driver para Chrome y Firefox.

El método **waiting** es útil en aplicaciones que utilizan AJAX ya que espera por un elemento el tiempo definido en la configuración, en este caso el tiempo será de 2 segundos.

La propiedad **baseUrl** indíca la dirección de la aplicación que será probada, para este ejemplo se probará un flujo del sitio de MakingDevs.

{{<highlight groovy>}}

GebConfig.groovy
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.firefox.FirefoxDriver

waiting{
  timeout = 2
}

environments{

  chrome{
    driver = {
      def driverInstance = new ChromeDriver()
      driverInstance.manage().window().maximize()
      driverInstance
    }
  }

  firefox{
    driver = {
      def driverInstance = new FirefoxDriver()
      driverInstance.manage().window().maximize()
      driverInstance
    }
  }

}

baseUrl = "http://makingdevs.com"

{{</highlight>}}

## PAGE OBJECTS

Como se mencionó anteriormente, para la interacción con los elementos del sitio se deben crear clases que representen cada página de la aplicación. Estas clases se deben extender de la clase **Page** y en ellas deben mapearse los componentes con los que se va a interactuar dentro del closure estático **content**; los componentes pueden ser referenciados haciendo uso de los selectores que proporciona Geb y que son muy parecidos a los de la biblioteca jQuery.

Dentro de cada clase Page puede declararse la propiedad estática **url** para que el navegador apunte a esa página cuando el método **to()** sea utilizado.

El closure estático **at** ayuda a determinar si el navegador se encuentra actualmente en esa página al comprobar que un elemento de la página cumpla con una condición.

Vamos a probar un flujo sencillo, en el cual el usuario consulta la información de un curso, para ello se necesitarán tres clases, MakingDevsHomePage, MakingDevsCoursesPage y MakingDevsCourseInfoPage:

{{<highlight groovy>}}
package com.makingdevs

import geb.*

class MakingDevsHomePage extends Page{

  static at = { title == ". : MakingDevs - Welcome : ." }

  static content = {
    coursesButton(to: MakingDevsCoursesPage){ $("ul.nav a",1) }
  }

}
{{</highlight>}}

{{<highlight groovy>}}
package com.makingdevs

import geb.*

class MakingDevsCoursesPage extends Page{

  static url = "/training"

  static at = {
    waitFor{ $(".section-main-header") }
    $(".section-main-header").text() == "Nuestro entrenamiento"
  }

  static content = {
    groovyCoursesDiv{ $(".span7",2).children("ul") }
  }

}
{{</highlight>}}

{{<highlight groovy>}}
package com.makingdevs.pages

import geb.*

class CourseInfoPage extends Page{

  static at = { waitFor{ $("i.icon-terminal") } }

  static content = {
    postTitle{ $(".post-title") }
  }
}
{{</highlight>}}

## INTEGRACIÓN CON SPOCK

[*Spock*][4] es un framework de pruebas y especificación que se caracteriza por su formato *Given-When-Then* que hace las pruebas más descriptivas.

Al integrar Geb con Spock es posible definir que acciones que deben ocurrir al ejecutar la prueba funcional. Por ejemplo, en la primera prueba escrita en la siguiente clase se utiliza el método **to** dentro del bloque *when* para que el navegador se dirija a la página principal del sitio, una vez ahí se da click a un vínculo y finalmente se verifica que ese vínculo lleve a la página que muestra los cursos.

La segunda prueba muestra algo más interesante, ya que implementa un **Data Table** de Spock para agrupar un conjunto de valores de entrada y salida separados por el símbolo **|**; la prueba verifica que al ir a la url declarada en MakingDevsCoursesPage se busque con el método *find* dentro de una sección referenciada por el selector groovyCoursesDiv el vínculo con un atributo href que comience con el valor declarado en la columna *_selectorUrl* de la tabla para después hacer click en el elemento y finalmente comparar el texto del componente asociado al selector de postTitle con el del valor en la columna *_postTitle*.

{{<highlight groovy>}}
package com.makingdevs

import geb.spock.GebReportingSpec
import java.lang.Void as Should
import com.makingdevs.pages.*

class MakingDevsSiteFunctionalSpec extends GebReportingSpec{

  Should "show the available courses"(){
    when:
      to MakingDevsHomePage
    and:
      coursesButton.click()

    then:
      at MakingDevsCoursesPage
  }

  Should "show the course information"(){
    when:
      to MakingDevsCoursesPage
    and:
      groovyCoursesDiv.find("a[href^='${_selectorUrl}").click()

    then:
      at CourseInfoPage
      postTitle.text() == _postTitle
    where:
    _selectorUrl                    | _postTitle
    "/training/groovy-testing"      | "Pruebas en la JVM con Groovy"
    "/training/groovy-essentials"   | "El lenguaje dinámico Groovy"
    "/training/grails-intermediate" | "Productividad con Grails"
    "/training/groovy-intermediate" | "Productividad con Groovy"
  }

}
{{</highlight>}}

Finalmente para correr las pruebas ejecutamos el comando ```./gradlew firefoxTest``` para Firefox o ```./gradlew chromeTest``` para chrome; la tarea ```./gradlew test``` corre las pruebas en ambos navegadores.

Pueden encontrar el código completo [*aquí*][5].

[1]: http://www.seleniumhq.org/projects/webdriver/
[2]: http://martinfowler.com/bliki/PageObject.html
[3]: https://sites.google.com/a/chromium.org/chromedriver/downloads
[4]: https://spockframework.github.io/spock/docs/1.0/introduction.html
[5]: https://github.com/egjimenezg/FunctionalTesting
