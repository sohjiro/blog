echo "--------------------Actualizando--------------------------"
git checkout master
git pull origin master
echo "-----------------------------------------------Repositorio Blog ok"
cd public
git checkout master
git pull origin master
echo "...............................................Repositorio MakingDevs.Gitub.Io en Public ok"
echo "Sitios actualizados, asegurarse que el servidor local contenga lo mismo que en el blog"
cd ..
hugo serve --buildDrafts







