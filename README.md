# blog

Agregar nuevo post con deploy.sh
======

#Instalar GoHugo
       "brew install hugo"

## Para resaltado de sintáxis se usa http://pygments.org/, se debe instalar

1. Agregar file.md en content/post
2. Ejecutar el script de deploy.sh

---

#Cabeceras del fichero Markdown

1. +++
2. title= "Bienvenido a MakingDevs"
3. date="2014-07-29 00:21:37 -0500"
4. author="José Juan Reyes Zuñiga"
5. comments="true"
6. +++

---

1. Colocar Gist
  + {{<  gist user_github id_gist "title_gist"  >}}

1. Resaltado de código
  + {{< highlight grails >}} A bunch of code here {{< /highlight >i}}


---

## El Script realiza lo siguiente:
    1. Ejecuta "hugo"
    2. Git status (en repositorio blog--código fuente de hugo)
    3. Git add .
    4. Git commit
    5. cd public (contenido estático generado por hugo)
    6. Git status (en repositorio makingdevs.github.io<----host del blog)
---

