+++
css = []
date = "2017-07-10T23:32:17-05:00"

author = "Felipe Juarez"
description = ""
highlight = true
scripts = []
title = "Building a release with Distillery"

comments = "true"
tags = ["elixir","distillery", "deploy", "developer tools"]
categories = ["elixir","distillery", "deploy", "developer tools"]

+++

In this post we are going to talk distillery and how integrate with a project. And for this we are going to use the [phoenix framework](http://www.phoenixframework.org)

Please make sure that you have installed elixir and phoenix [installed](http://www.phoenixframework.org/docs/installation)

Ok, let the show begin.

The first thing that we are going to do is create a `phoenix` project without `brunch` and `ecto`. For that we need to run `mix phoenix.new todo --no-ecto --no-brunch`

{{< highlight shell >}}
❯ mix phoenix.new todo --no-ecto --no-brunch
* creating todo/config/config.exs
* creating todo/config/dev.exs
* creating todo/config/prod.exs
* creating todo/config/prod.secret.exs
* creating todo/config/test.exs
* creating todo/lib/todo.ex
* creating todo/lib/todo/endpoint.ex
* creating todo/test/views/error_view_test.exs
* creating todo/test/support/conn_case.ex
* creating todo/test/support/channel_case.ex
* creating todo/test/test_helper.exs
* creating todo/web/channels/user_socket.ex
* creating todo/web/router.ex
* creating todo/web/views/error_view.ex
* creating todo/web/web.ex
* creating todo/mix.exs
* creating todo/README.md
* creating todo/web/gettext.ex
* creating todo/priv/gettext/errors.pot
* creating todo/priv/gettext/en/LC_MESSAGES/errors.po
* creating todo/web/views/error_helpers.ex
* creating todo/.gitignore
* creating todo/priv/static/css/app.css
* creating todo/priv/static/js/app.js
* creating todo/priv/static/robots.txt
* creating todo/priv/static/js/phoenix.js
* creating todo/priv/static/images/phoenix.png
* creating todo/priv/static/favicon.ico
* creating todo/test/controllers/page_controller_test.exs
* creating todo/test/views/layout_view_test.exs
* creating todo/test/views/page_view_test.exs
* creating todo/web/controllers/page_controller.ex
* creating todo/web/templates/layout/app.html.eex
* creating todo/web/templates/page/index.html.eex
* creating todo/web/views/layout_view.ex
* creating todo/web/views/page_view.ex

Fetch and install dependencies? [Yn] Y
* running mix deps.get

We are all set! Run your Phoenix application:

    $ cd todo
    $ mix phoenix.server

You can also run your app inside IEx (Interactive Elixir) as:

    $ iex -S mix phoenix.server
{{< /highlight >}}

Once is finished we verify that everything is ok by running the server. And we need to see the default phoenix page.

Now is time to add `distillery` to our project and for that we need to modify our `mix.exs` file and add it as a dependency.

{{< highlight elixir >}}
  defp deps do
    [{:phoenix, "~> 1.2.4"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},

     {:distillery, "~> 1.4", runtime: false}
   ]
  end
{{< /highlight >}}

After that, we update our dependencies and compile the whole project `mix do deps.get, compile`. And we proceed to change our `config/prod.exs`

{{< highlight elixir >}}
use Mix.Config

config :todo, Todo.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: {:system, "HOST"}, port: {:system, "PORT"}],
  cache_static_manifest: "priv/static/manifest.json"

config :logger, level: :info

config :phoenix, :serve_endpoints, true

import_config "prod.secret.exs"
{{< /highlight >}}


Before we create a release package, we need to run an initialization command

{{< highlight shell >}}
❯ mix release.init
Compiling 11 files (.ex)
Generated todo app

An example config file has been placed in rel/config.exs, review it,
make edits as needed/desired, and then run `mix release` to build the release
{{< /highlight >}}

This command `rel/config.exs` file. In this file we can find the default configuration for building a release. We are going to keep the default configuration but, if you want to know more about this file click [this](https://hexdocs.pm/distillery/configuration.html). There you will find how to handle configuration.

And that's all, once we are done with this changes we can run `MIX_ENV=prod mix release --env=prod` for creating a release.


{{< highlight shell >}}
❯ MIX_ENV=prod mix release --env=prod
==> Assembling release..
==> Building release todo:0.0.1 using environment prod
==> Including ERTS 8.3 from /usr/local/Cellar/erlang/19.3/lib/erlang/erts-8.3
==> Packaging release..
==> Release successfully built!
    You can run it in one of the following ways:
      Interactive: _build/prod/rel/todo/bin/todo console
      Foreground: _build/prod/rel/todo/bin/todo foreground
      Daemon: _build/prod/rel/todo/bin/todo start
{{< /highlight >}}

For testing our release we are going to use the `Interactive` approach. So, we run as the command line example but prefixing with `PORT=4000`:

{{< highlight shell >}}
❯ PORT=4000 _build/prod/rel/todo/bin/todo console
Erlang/OTP 19 [erts-8.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

12:56:03.825 [info] Running Todo.Endpoint with Cowboy using http://localhost:4000
12:56:03.826 [error] Could not find static manifest at "/Users/makingdevs/Documents/todo/_build/prod/rel/todo/lib/todo-0.0.1/priv/static/manifest.json". Run "mix phoenix.digest" after building your static files or remove the configuration from "config/prod.exs".
Interactive Elixir (1.4.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(todo@127.0.0.1)1>
{{< /highlight >}}

Now we put our `ip address` into our browser followed by `port` and we are going to see the default page as the begining.

As bonus, if you enter in interactive mode. When you hit the URL you will see how the console output change everytime you hit that `URL`.

{{< highlight shell >}}
❯ PORT=4000 _build/prod/rel/todo/bin/todo console
Erlang/OTP 19 [erts-8.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

12:58:48.667 [info] Running Todo.Endpoint with Cowboy using http://localhost:4000
12:58:48.667 [error] Could not find static manifest at "/Users/makingdevs/Documents/todo/_build/prod/rel/todo/lib/todo-0.0.1/priv/static/manifest.json". Run "mix phoenix.digest" after building your static files or remove the configuration from "config/prod.exs".
Interactive Elixir (1.4.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(todo@127.0.0.1)1> 12:58:54.917 request_id=27n3ui1iisialbh41grg9g1btt9d67n8 [info] GET /phoenix/live_reload/socket/websocket
12:58:54.917 request_id=27n3ui1iisialbh41grg9g1btt9d67n8 [info] Sent 404 in 173µs
12:59:34.541 request_id=nmcl910kb02brqb5qsicm5ljl1a9iccj [info] GET /
12:59:34.542 request_id=nmcl910kb02brqb5qsicm5ljl1a9iccj [info] Sent 200 in 238µs
12:59:56.322 request_id=se02ut1a3fl5i9114ueta0f6ab9f44ke [info] GET /phoenix/live_reload/socket/websocket
12:59:56.322 request_id=se02ut1a3fl5i9114ueta0f6ab9f44ke [info] Sent 404 in 165µs
13:00:04.711 request_id=6omlkpefoom2abafgnco8t4tcuqec0c1 [info] GET /
13:00:04.711 request_id=6omlkpefoom2abafgnco8t4tcuqec0c1 [info] Sent 200 in 226µs
{{< /highlight >}}
