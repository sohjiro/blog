# blog

======

#Instalar GoHugo
       "brew install hugo"

```
Para resaltado de sintáxis se usa http://pygments.org/, se debe instalar
```

---

# Estructura del Proyecto

El repositorio principal es *"blog"*, cuyo contenido es la estructura de un proyecto de Hugo
Dentro:
La carpeta *"themes/themes"* es un submodulo al fork del tema Hugo-Geo-. (master)
La carpeta *"public"* es un submodulo al repositorio "makingdevs.github.io" que contiene el contenido estático generado por Hugo. (master)
En *"content/post"* se hallan los archivos markdown de los post del blog.
En *"static"* se encuentran las imágenes usadas en los post.
El fichero *"config.toml"* es la configuración de Hugo.
 

# Pasos para publicar en el  blog de Making Devs por vez primera:

1. Clonar el repositorio de "blog"
2. Ejecutar el script "inicio.sh" para bajar los archivos de los submódulos del tema y la carpeta public.
3. Para agregar un nuevo post ejecutar "agregar_post.sh" y modificar el fichero creado.
4. Ejecutar el script "deploy.sh" que actualizará el repositorio *blog*, ejecutará Hugo para generar el contenido en *public* y actualizará el repositorio *makingdevs.github.io* 
5. Revisar los cambios en GitHub

# Para actualizar el repositorio "blog"

1. Ejecutar el script "update.sh"
2. El script ejectura el servidor local, asegurarse que este actualizado

---

#Borrar un post publicado
    Al borrar un post.md, y volver a correr Hugo, no reemplaza el contenido de la carpeta public.
    Para borrar un post publicado en el blog, realizar lo siguiente:
      1. Borrar contenido de la carpeta public (menos CNAME)
      2. Asegurar haber borrado el post.md a borrar en content/post
      3. Ejecutar hugo (esto volverá a rellenar la carpeta public)

---

#Insertar un post

Ejecutar en la carpeta raíz y esto generará automáticamente las cabeceras:

```
	hugo new post/mipost.md
```

---

1. Colocar Gist
  + `{{<  gist user_github id_gist "title_gist"  >}}`

1. Resaltado de código
  + `{{< highlight grails >}} A bunch of code here {{< /highlight >i}}`


---

#Mini Tutorial de Hugo

1. Para crear sitio:**hugo new site misitio**
2. Para crear nuevo post: **hugo new post/mipost.md**
3. Para ejecutar hugo y crear el contenido del sitio estático:**hugo --buildDrafts**
4. Para abrir un servidor local y checar cambios:**hugo serve --buildDrafts**

---
