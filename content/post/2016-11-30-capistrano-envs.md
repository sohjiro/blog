---
title: "Capistrano para despliegues de apps Rails"
date: "2016-11-30T16:46:05-06:00"
author: José Juan Reyes Zuñiga
published: true
comments: true
tags: [ruby, capistrano, environment, deploy]
categories:
- ruby
---

Hace tiempo que estabamos haciendo una aplicación *Rails*, me di a la tarear de investigar el tema obviado que es la forma en como se hace un despliegue lo más ordenado posible. Inclusive le pregunte al gran maestro @chillicoder al respecto, y efectivamente, mis sospechas eran correctas tenía que usar Capistrano(aunque chilli parece usar otra cosa), incluída la recomendación del maestro.

Obviaré las partes de las instalaciones de las gemas y me enfocaré en el problema que tuve que resolver: un par de ambientes a instalar para una API hecha en Rails.

Para ser honesto me sorprendió lo estructurado en que se puede hacer un despliegue con Capistrano, incluso me gusto mucho que la recomendación siempre era la misma, dando pie a una buena forma de hacer dicho deploy.

## El archivo _config/deploy.rb_

Cuando instalas Capistrano, viene consigo un archivo _deploy.rb_ en donde puse lo siguiente:

{{< highlight ruby >}}
# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'barista'
set :repo_url, 'git@github.com:makingdevs/MyBarista.git'
set :rbenv_ruby, '2.2.3'

set :repo_tree, 'ruby_app'

set :puma_user, fetch(:user)
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
{{< /highlight >}}

Aquí hay varias cosas que me gustaria comentar:

1. `:repo_tree` te ayuda a desplegar una carpeta interna del directorio base del repo, que es nuestro caso
2. `:linked_dirs` ayuda a crear enlances simbólicos de ciertos directorios que necesitarías
3. `:linked_file` excelente forma de hacer enlaces simbólicos de archivos que contienen la configuración externa, si no quieres usar variables de ambiente o sistema.

Adicional a esto, en el mismo archivo tuve que eliminar algunas tareas y crear algunas para el manejo de puma:

{{< highlight ruby >}}
Rake::Task["deploy:assets:precompile"].clear_actions
Rake::Task["deploy:assets:backup_manifest"].clear_actions

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
{{< /highlight >}}

## Los archivos de ambientes

Dentro del directorio _config/deploy/_ existen un par de archivos que nos ayudan a definir elementos particulares de la instalación por cada ambiente, lo único que yo hice fue habilitar la máquina a través de autenticación de llave pública con el servidor de despliegue para que se pudieran comunicar por ssh. Y mis archivos quedaron así:

{{< highlight ruby >}}
set :stage, :production
set :puma_bind, %w(tcp://0.0.0.0:3000)
set :branch, 'production'
set :deploy_to, "/var/www/#{fetch(:application)}/production"

server 'powerful.makingdevs.com', user: 'centos-user', roles: %w{app web}
{{< /highlight >}}

{{< highlight ruby >}}
set :stage, :stage
set :puma_bind, %w(tcp://0.0.0.0:3001)
set :branch, 'stage'
set :deploy_to, "/var/www/#{fetch(:application)}/stage"

server 'powerful.makingdevs.com', user: 'centos-user', roles: %w{app web}
{{< /highlight >}}

En donde puedo definir incluso el branch del repo que quiero desplegar, el puerto de puma donde quiero levantar y que no colisionen entre sí, y un directorio basado en el ambiente.

Me gusta mucho el control que tiene Capistrano para revertir una versión, pues lo ordena de tal forma que guarda algunos respaldos de versiones desplegadas anteriormente listas para resintalarlse en caso de que algo salga mal.

Capistrano hace todo, la transferencia de archivos, el ordenamiento, la instalación de puma y de las gemas de la app, incluso del propio runtime de Ruby, la creación de enlaces simbólicos, la descarga de cambios del repo, etc.

Capistrano es la herramienta.
