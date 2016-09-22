#! /bin/bash
echo "Vamos a agregar un nuevo post, dame el nombre del fichero markdown:"
read file
echo "####################################################################"
hugo new post/$file.md
echo "Fichero creado, búscalo en /content/post/"
echo "Para correr el servidor local con cambios, ejecuta:"
echo "                                                   hugo serve --buildDrafts"

