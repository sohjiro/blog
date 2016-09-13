+++
title= "Inyección de métodos por categorías y TimeCategory"
date= "2014-09-16 18:55:30 -0500"
author= "José Juan Reyes Zuñiga"
comments= "true"
categories=["development","groovy"]
+++

## Acerca de las categorías

En Groovy se pueden inyectar métodos de algunas formas, uno de ellos es a través del uso de categorías, la cual nos da inyección temporal y controlada de dichos elementos. Para hacerlo las clases que son categorías deben de cumplir con cierta estructura:

*   Los métodos de la clase deben ser definidos como estáticos
*   El primer argumento de dicho método define el tipo sobre el cual se inyectarían los nuevos métodos
*   Deben de ser usados dentro del alcance de un closure con ayuda de la palabra reservada `use`
<!-- more -->

Un ejemplo podría ser el siguiente:

{{<highlight groovy>}}
    class NameUtil{
        static prettify(String name){
            name.trim().split(' ').grep { it.size() }*.capitalize().join(' ')
        }
    }

    use NameUtil, {
        println "  josé   juan    reyes    zuñiga   ".prettify()
    }
{{</highlight>}}

Adicionalmente, podemos crear dicha inyección de métodos con ayuda de la anotación `@Category`, que prácticamente nos facilita a que cualquier clase pueda ser usada como categoría, pues no necesariamente los métodos tiene que ser estáticos y el contexto del argumento para la inyección es el objeto `this` en donde se esté intentando usar.

## Uso de GroovyTime

La clase `TimeCategory` es una clase que tiene una serie de métodos de conveniencia para el manejo del tiempo, formando así un DSL, con el que podemos operar. Y con ayuda de la clase `Duration` complementamos algunas operaciones que se pueden realizar en el contexto de los objetos que estemos usando.

{{<highlight groovy>}}
    import groovy.time.TimeCategory

    use ( TimeCategory ) {
        println 2.hours.ago
        println 30.minutes.from // TimeDuration
        println 30.minutes.from.now
        println 40.minutes + 30.minutes.from.now
        println 30.minutes.ago

        def today = new Date()
        println today - 3.years
        println today + 4.weeks
        println today + 90.minutes
    }
{{</highlight>}}

Para que consideres el conjunto de operaciones que tienes disponibles te recomendamos visitar la documentación de [TimeCategory][1] y [Duration][2]

 [1]: http://groovy.codehaus.org/api/groovy/time/TimeCategory.html
 [2]: http://groovy.codehaus.org/api/groovy/time/Duration.html
