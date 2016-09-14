#! /bin/bash
echo "Estás en:"
pwd
echo "Asegurate de ejecutar este script en la carpeta principal del blog"
echo "Añade un commit para actualizar el blog:::::::::::::::::::::::::::"
read comm
echo "Descripcion::::::::::::::::::::::::::::"$comm
echo "Construyendo hugo con tu nuevo post"
hugo
echo "Sitio construido, :)-------------------------------------------->"
echo "Actualizando en el repositorio de blog, git status del código fuente de hugo::::::::::::::::"
git status
echo "Continuamos?"
read resp

echo "OK Aplicando git add -A, git commit, y git push________________________"
git add -A
git commit -m "$comm"
git push
echo "Cambios arriba OK"

echo "Actualizando contenido estático del blog"
cd public
pwd
git status
echo "Continuamos?"
read resp2
git add -A
git commit -m "$comm"
git push
echo "Actualizado repositorio de makingdevs.github.io, revisa cambios."
