---
title: "Routing en Elm"
date: 2016-09-10 11:22:01 -0500
author: Ariana Gothwski
comments: true
tags: [elm, routing, functional programming]
draft = false
categories: [ elm, development]
---


La URL es un bit interesante de nuestra applicación, nos permite regresar a un estado, o compartir ese estado con alguien más; y en Elm, el Routing, es la segunda cosa más importante que deberías conocer después del propio lenguaje. Así que empecemos.


### ANATOMÍA DE UNA URL

Una URL es una dirección dada para un recurso único en la web y está compuesta de diferentes partes: un protocolo, un host, un nombre de dominio, opcionalmente un path y el nombre del archivo:

`http_URL = "http:" "//" host [":" port][ abs_path ["?" query ]] `

Para el caso del routing en Elm sólo nos incumben aquellas que pueden ser opcionales.

`[ abs_path ["?" query ]`

Teniendo esto en mente, continuemos.


### INSTALANDO DEPENDENCIAS

- Vamos a necesitar esta biblioteca para controlar la navegación.

  `elm package install elm-lang/navigation `

- Y esta otra para transformar nuestras URLs en estructuras de datos agradables.

  `elm package navigation evancz/url-parser `

- Por último necesitaremos la función `Navigation.program` que vive dentro del módulo `Navigation`, su tarea será tomar el `parser` y un `record` para poder regresarnos un programa Elm.


### EMPIEZA CONFIGURANDO LA APLICACIÓN

`Navigation.program` nos proveé de una función `urlUpdate` para actualizar el modelo cada que el `parser`produzca nuevos datos.


{{<gist gothwski 7bfeec986a90d34eb283830d8903081f "1-routing-with.elm" >}}


### DEFINE LAS RUTAS.

Es importante mencionar que el orden de los matchers importa, para más detalle sobre ello revisa la [documentación](http://package.elm-lang.org/packages/evancz/url-parser/latest/)

{{<gist gothwski 7bfeec986a90d34eb283830d8903081f "2-routes.elm" >}}


### ASÍ ES COMO FUNCIONA... Y SE IMPLEMENTA.

Cuando queremos acceder a un documento en particular de un servidor web, escribimos una `URL` en la location bar, y un par de cosas suceden: primeramente la URL es partida en sus diferentes partes. Es entonces cuando la biblioteca `Navigation` nos genera un record `Navigation.Location` con dos partes de ella: el Path y los Parámetros, e inmediatamente manda llamar al `parser` quien será el responsable de transformar esa `URL` de tipo `String` en datos útiles.

{{<gist gothwski 7bfeec986a90d34eb283830d8903081f "3-parser.elm" >}}

Es entonces cuando este record es tomado por una función llamada `hashParser` que enviará el `string` resultante a la función `Navigation.makeParser`que vive dentro de `parser`, y así mismo se incluirán como párametro las rutas que ya hemos definido anteriormente:

{{<gist gothwski 7bfeec986a90d34eb283830d8903081f "4-navigation-location.elm" >}}

Finalmente el `parser` regresa un resultado, si es `OK` nos devolerá la ruta que hace match y definiremos la acción correspondiente, de lo contrario caeremos en el `error`.

{{<gist gothwski 7bfeec986a90d34eb283830d8903081f "5-url-update.elm" >}}
