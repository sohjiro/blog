+++
title="Hot deployment en Gradle"
date="2015-07-26 23:19:13 -0500"
author="José Juan Reyes Zuñiga"
comments="true"
tags=["groovy","gradle", "plugins"]
categories=["gradle","groovy","web"]
+++

Durante un tiempo estuve buscando de la forma de tener una aplicación web con Gradle y tener características como el hot deploy, Grails lo tiene y viendólo de forma interna usa un elemento de nombre [SpringLoaded][1].

Después me di cuenta que frameworks como [Dropwizard][2] lo usan, y que incluso SpringBoot a través del uso del CLI también, investigando un poco más al respecto y por la necesidad de tenerlo listo para algunos proyectos encontré [un artículo][3] en donde explica como ponerlo en acción usando propiamente [Dropwizard][2]. Fue un buen acercamiento, el problema es el siguiente bloque de código en configuración de gradle:
<!-- more -->

{{<highlight groovy>}}
run {
  args = ['server', 'app.yaml']
  jvmArgs = ["-javaagent:${new File("$buildDir/agent/springloaded-${springloadedVersion}.jar").absolutePath}", '-noverify']
}
{{</highlight>}}

En donde, el atributo `jvmArgs` es sólo aplicable a tareas del tipo `JavaExec`, más específico, que implementan `JavaExecSpec` o `JavaForkOptions`. Es aquí en donde [el plugin de tomcat][4] que se puede encontrar para Gradle tiene el problema, pues su tarea no lo hace.

La combinación se haría en conjunto con un plugin de gradle, [el watch][5], el actúa con cada cambio en la aplicación realizando las tareas que se le digan. Sin embargo, lo que encontré funcionaba para la cmbinación de SpringBooy e IntelliJ Idea, lo cual no veía mal, pero no era mi caso. De cualquier forma pongo disponible la configuración que independiente me sirvió para hacer un hot deploy usando ambos elementos:

{{<highlight groovy>}}
apply plugin: 'groovy'
apply plugin: 'spring-boot'
apply plugin: 'com.bluepapa32.watch'

sourceCompatibility = 1.8
targetCompatibility = 1.8

ext {
  springLoadedVersion = '1.2.1.RELEASE'
}

mainClassName='com.makingdevs.Application'

repositories {
  mavenCentral()
  maven {
    url "https://code.lds.org/nexus/content/groups/main-repo"
  }
}

dependencies {
  compile("org.springframework.boot:spring-boot-starter-web")
  compile 'org.codehaus.groovy:groovy-all:2.4.3'
}

buildscript {
  repositories {
    mavenCentral()
    jcenter()
  }
  dependencies {
    classpath "org.springframework.boot:spring-boot-gradle-plugin:1.2.4.RELEASE"
    classpath 'org.springframework:springloaded:1.2.0.RELEASE'
    classpath 'com.bluepapa32:gradle-watch-plugin:0.1.5'
  }
}

jar {
  baseName = 'meerkat-mymapmanager'
  version =  '0.1.0'
}

compileGroovy {
  //enable compilation in a separate daemon process
  options.fork = true
}

watch {
  groovy {
    files files('src/main/groovy')
    tasks 'compileGroovy'
  }
}
{{</highlight>}}

Al final del día, lo que encontre fue [el plugin de Gretty][6], con el que fácilmente podemos usar un contenedor de Tomcat o Jetty y tener disponible el Hot deploy, creo que tiene algunos detalles de rendimiento pero es útil. Finalmente la configuración se reduce mucho y hay varias tareas disponibles, entre ellas `appRun`, que es la que levanta el elemento configuraco y lo dijo listo para los cambios:

{{<highlight groovy>}}
// Using the new mechanism to include plugins
plugins {
  id 'groovy'
  id 'war'
  id "org.akhikhl.gretty" version "1.2.4"
}

repositories {
  mavenCentral()
  jcenter()
}

dependencies {
  compile 'org.codehaus.groovy:groovy-all:2.3.4'
}

gretty {
  // 'jetty7', 'jetty8', 'jetty9', 'tomcat7', 'tomcat8'
  servletContainer = 'tomcat7'
  httpPort = 9091
}
{{</highlight>}}

Creo que nos servirá bien un rato para las cosas que tenemos que hcaer, por que incluso soporta SpringBoot.

 [1]: https://github.com/spring-projects/spring-loaded "springloaded"
 [2]: https://github.com/spring-projects/spring-loaded "dropwizard"
 [3]: http://www.cholick.com/entry/show/280 "tomcat"
 [4]: https://github.com/bmuschko/gradle-tomcat-plugin "tomcat"
 [5]: https://github.com/bluepapa32/gradle-watch-plugin "gradle watch"
 [6]: http://akhikhl.github.io/gretty-doc/index.html "gretty"

