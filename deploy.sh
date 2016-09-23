#! /bin/bash

echo "1.- Asegurate de ejecutar este script en la carpeta principal del blog"
echo "2.- Añade un commit para actualizar el blog:::::::::::::::::::::::::::"
read comm

echo "3.- Construyendo hugo con tu nuevo post"
echo "4.- Actualizando en el repositorio de blog, git status del código fuente de hugo::::::::::::::::"
echo "5.- OK Aplicando git add -A, git commit, y git push-------------------------------------------------------"
git add -A
git commit -m "$comm"
git push origin master
echo "6.- Repositorio Blog actualizado, chechar en GitHub.io los cambios"

echo "7.- Actualizando contenido estático del blog"
rm -rf public/*
hugo --buildDrafts
cd public
git checkout master
echo "blog.makingdevs.com">>CNAME
git add -A
git commit -m "$comm"
git push origin master --force
echo "8.- Actualizado repositorio de makingdevs.github.io, revisa cambios en el blog ----------------------------"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
