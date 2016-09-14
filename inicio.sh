echo "Bajando el tema"
git submodule init
git submodule update
echo "Tema incluido::::::::::"
hugo
echo "Hugo inicializado, generando sitio estático en Public"
echo "Listo para agregar"
