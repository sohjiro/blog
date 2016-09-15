# blog

Agregar nuevo post con deploy.sh
======

#Instalar GoHugo
       "brew install hugo"

## Para resaltado de sintáxis se usa http://pygments.org/, se debe instalar

1. Clonar el repositorio de "blog"
2. Correr el script inicio.sh
3. Para visualizar en local "hugo serve --buildDrafts"
4. Agregar file.md en content/post
5. Ejecutar el script de deploy.sh

---

#Cabeceras del fichero Markdown

```md
+++
title= "Bienvenido a MakingDevs"
date="2014-07-29 00:21:37 -0500"
author="José Juan Reyes Zuñiga"
comments="true"
+++
```

---

1. Colocar Gist
  + `{{<  gist user_github id_gist "title_gist"  >}}`

1. Resaltado de código
  + `{{< highlight grails >}} A bunch of code here {{< /highlight >i}}`


---

## El Script realiza lo siguiente:
    1. Ejecuta "hugo"
    2. Git status (en repositorio blog--código fuente de hugo)
    3. Git add .
    4. Git commit
    5. cd public (contenido estático generado por hugo)
    6. Git status (en repositorio makingdevs.github.io<----host del blog)
---
#Borrar un post publicado
    Al borrar un post.md, y volver a correr Hugo, no reemplaza el contenido de la carpeta public.
    Para borrar un post publicado en el blog, realizar lo siguiente:
      1. Borrar contenido de la carpeta public (menos CNAME)
      2. Asegurar haber borrado el post.md a borrar en content/post
      3. Ejecutar hugo (esto volverá a rellenar la carpeta public)
