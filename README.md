# blog

Agregar nuevo post con deploy.sh
======

#Instalar GoHugo
       "brew install hugo"

```
Para resaltado de sintáxis se usa http://pygments.org/, se debe instalar
```

---

# Pasos para actualizar el  blog de Making Devs

1. Clonar el repositorio de "blog"
2. Ejecutar el script "inicio.sh"
3. Para agregar un nuevo post ejecutar "agregar_post.sh" y modificar el fichero creado
4. Ejecutar el script "deploy.sh" para actualizar los dos repositorios.
5. Checar cambios en GitHub

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

Para crear sitio:**hugo new site misitio**
Para crear nuevo post: **hugo new post/mipost.md**
Para ejecutar hugo y crear el contenido del sitio estático:**hugo --buildDrafts**
Para abrir un servidor local y checar cambios:**hugo serve --buildDrafts**

---
