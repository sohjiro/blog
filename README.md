# blog

Agregar nuevo post
======

1. Agregar file.md en content/post
2. Ejecutar el script de prueba.sh

---

###Others

Go Hugo:

1.- Instalar Hugo.
2.- Crear un sitio: hugo new site misitio
3.- Agregar un tema, descargarlo en "themes"
4.- Editar el archivo de configuracion "config.toml" y añadir  theme="mitemaausar"
5.- Construir el sitio con el comando "hugo" en la carpeta principal, esta generará la carpeta "public"
6.- Correr el servidor de hugo con "hugo serve"
7.- Para correr el servidor y que reconozca cambios inmediatos teclear: "hugo serve --buildDrafts"

Subir a Github:

En carpeta "Blog" inicializar GIT, y agregar el repo de "blog".
Agregar un archivo ".gitignore" y agregar la linea "public" para ignorar dicha carpeta.

Agregar un submodulo a la carpeta "public" y enlazarla al repo de "makingdevs.github.io"
git submodule add -b master git@github.com:makingdevs/makingdevs.github.io.git public

Los archivos que requeriere Hugo (themes,contents/post/markdowns...etc) estarán en el repo de "blog"

Los archivos generados por hugo para el sitio estático estarán en el repo "makingdevs.github" (index,js,css,etc).

-------

Subir contenido:

1.- Escribir un archivo markdown.md con la configuracion siguiente:

+++
title= "Bienvenido a MakingDevs"
date="2014-07-29 00:21:37 -0500"
author="José Juan Reyes Zuñiga"
comments="true"
+++

Contenido del post....

2.- Guardar en la carpeta /content/post
3.- Re-Construir el sitio estático tecleando "hugo"
4.- Add/commit/push al archivo markdown en la carpeta principal del sitio (el que esta enlazado al repositorio de "blog")
5.- Add/commit/push a todo el contenido de la carpeta public (enlazada al repositorio de makingdevs.github.io)


