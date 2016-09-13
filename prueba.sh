#! /bin/bash
pwd
echo "Asegurate de haber incluido tu archivo.md en content/post"
echo "Asegurate de ejecutar este script en la carpeta principal del blog"
echo "Añadiendo nuevo contenido al blog de making devs"
echo "Describe brevemente un comentario de tu publicacion:"
read comm
echo "Comentario: "$comm
echo "Construyendo hugo"
hugo
echo "Sitio construido"


echo "Actualizando en el repositorio de blog"
git status
echo "Seguro que quieres seguir?"
read resp
echo "git add y git commit"
git add .
git commit -m "$comm"
git push
echo "Actualizado"


echo "Actualizando blog"
cd public
pwd
git status
echo "seguro que quieres continuar?"
read resp2

git add .
git commit -m "$comm"
git push

echo "Actualizado repositorio de makingdevs.github.io"
