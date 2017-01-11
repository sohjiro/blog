+++
title = "Resolviendo la criba de Eratóstenes con Elixir"
date = "2017-01-11T13:11:46-06:00"
author = "José Juan Reyes Zuñiga"
published = "true"
comments = "true"
tags = ["elixir", "math", "pattern matching"]
categories=["elixir","functional programming"]
+++

Ya una vez más familiarizado con Elixir me dí a la tarea de resolver un problema que se encuentra documentado en la Wikipedia, la forma de obtener un conjunto de números primos y una solución es a través de la llamada (Criba de Eratótstenes)[1] descrita así:

- Primer paso: listar los números naturales comprendidos entre 2 y n.
- Segundo paso: Se toma el primer número no rayado ni marcado, como número primo.
- Tercer paso: Se tachan todos los múltiplos del número que se acaba de indicar como primo.
- Cuarto paso: Si el cuadrado del primer número que no ha sido rayado ni marcado es inferior a n, entonces se repite el segundo paso. Si no, el algoritmo termina, y todos los enteros no tachados son declarados primos.

![sieve](https://upload.wikimedia.org/wikipedia/commons/b/b9/Sieve_of_Eratosthenes_animation.gif)

Una vez definido el problema pude interpretar los pasos descritos en funciones de elixir, resultándome en algo como lo siguiente:

{{<gist neodevelop aaf941b6bc809fb0074f9b17dc0eef22 >}}

Al final, la forma en como quedó definido fue apegado al conjunto de pasos que permitían filtrar los casos en donde el número en cuestión era primo, y es aquí en donde las expresión de las funciones me ayudó.

En resumen, considero que Elixir me ayuda mucho a poder aterrizar elementos o descripciones matemáticas en funciones específicas.

[1]: https://es.wikipedia.org/wiki/Criba_de_Eratóstenes
