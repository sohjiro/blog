#! /bin/bash
echo "Bajando el tema"
git submodule init
git submodule update
echo "Tema incluido::::::::::"
echo "Listo para agregar"

hugo serve --buildDrafts
