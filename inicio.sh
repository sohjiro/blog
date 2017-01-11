#! /bin/bash
echo "Bajando el tema"
git submodule init
git submodule update
echo "Tema incluido::::::::::"
cd public
echo "En carpeta public abrir archivo index.html"
git checkout master
echo "Sitio descargado en LOCAL-----------------------"

