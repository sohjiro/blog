# blog

Agregar nuevo post con deploy.sh
======

#Instalar GoHugo
       "brew install hugo"
1. Agregar file.md en content/post
2. Ejecutar el script de deploy.sh

---

#Cabeceras del fichero Markdown

+++
title= "Bienvenido a MakingDevs"
date="2014-07-29 00:21:37 -0500"
author="José Juan Reyes Zuñiga"
comments="true"
+++

**contenido**
!["descripcion de una imagen"]("../source/imagen.img")

{{<  gist user_github id_gist "title_gist"  >}}

{{< highlight grails >}} A bunch of code here {{< /highlight >i}}

---

## El Script realiza lo siguiente:
    1. Ejecuta "hugo"
    2. Git status (en repositorio blog--código fuente de hugo)
    3. Git add .
    4. Git commit
    5. cd public (contenido estático generado por hugo)
    6. Git status (en repositorio makingdevs.github.io<----host del blog)
---

