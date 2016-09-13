---
title: "phoenix bootstrap"
date: 2016-03-24 20:08:09 -0600
comments: true
published: true
author: Felipe Juárez Murillo
tags: [phoenix, elixir, bootstrap]
categories:
- elixir
- phoenix
---


It has been a while since I make a post and this is my first post in English so be gentle with me :P

Since a couple of months I been working in a language called [elixir](http://elixir-lang.org/) and with his web framework [phoenix](http://www.phoenixframework.org/), I have had a lot of fun with these elements. But sometimes I been struggling with configurations that should be easy maybe I don't read that carefully or maybe I'm a knucklehead, but whatever the reasone is, I hope this configuration works for you and give you a little help of how configure your Javascripts third parties for your Phoenix application.

<!-- more -->

When you create a new application with phoenix you will notice (when you start the server) that actually `phoenix` have [bootstrap](http://getbootstrap.com/) but that is not true at all, if you want to add a `dropdown` or something more sophisticated like a `dialog` or a `carousel` you will find that there is no `javascript` and the only thing that you have is the `stylesheet` so in order to add the complete `bootstrap` you need a couple steps before.

Well let's get started with this thing:

In order to manage all the libraries that you need to work with it is recommended to install [bower](http://bower.io/). Actually `phoenix` in his [Static Assets](http://www.phoenixframework.org/docs/static-assets) page encourage you to do it.

So we are going to follow this path and add bootstrap with `bower` but first we are going to create the `bower.json` file for storing our dependencies:

```sh
bower init
```

Then we are going to create a file named `.bowerrc` with this file we are going to tell to `bower` where are going to need to put all the `javascripts` that we need it from now on. In this file we are going to put the next instruction:

{{<highlight js>}}
{
  "directory": "web/static/vendor"
}
{{</highlight>}}

Now is the time to install `bootstrap` and for that we need to run the following instruction in your shell:

``` sh
bower install -S bootstrap
```

Now that we have `bootstrap` if you check your `vendor` directory you will see that there is not only `bootstrap`, it is also `jquery` (because is a dependency for `bootstrap`), if have not heard of `bower` before I recommend you to look for other proyects it will save you a lot of time and space in your repository.

Well at this moment, if you run your `phoenix.server` you will find a couple of errors, so lets fix that:

1. Let's remove the `bootstrap css` that `phoenix` ships with. For this open your `web/static/css/app.css` and remove the first 6 lines of code of the file.
2. Then open your `brunch-config.js` and in the `conventions` section add the following:

  {{<highlight js>}}
   conventions: {
     assets: /^(web\/static\/assets)/,
     ignored: [
       /^(web\/static\/vendor\/bootstrap\/)(?!.*min.(js|css)$)/,
       /^(web\/static\/vendor\/jquery\/)(?!.*min.js)/
     ]
   }
   {{</highlight>}}
3. After that you will need to load `jquery` and `bootstrap` in order, i.e. First `jquery` and then `bootstrap`. This is because `brunch` will merge all js in alphabetical order and we require that `jquery` loads first. For this we move to the `joinTo` in the `files` section and add the next lines:

{{<highlight js>}}
   files: {
     javascripts: {
       joinTo: "js/app.js",
       order: {
         before: [
           "web/static/vendor/jquery/dist/jquery.min.js",
           "web/static/vendor/bootstrap/dist/js/bootstrap.js"
         ]
       }
     },
   ... more code ...
   {{</highlight>}}

After this you can open the main layout of your application and put the next code:

{{<highlight html>}}
<div class="dropdown">
  <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
    Dropdown
    <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
    <li><a href="#">Action</a></li>
    <li><a href="#">Another action</a></li>
    <li><a href="#">Something else here</a></li>
    <li role="separator" class="divider"></li>
    <li><a href="#">Separated link</a></li>
  </ul>
</div>
{{</highlight>}}

And this is going to work as expected. Now you can make use of everything that `boostrap` have.

Oh! I forgot for copying the fonts and icons that `bootstrap` have you need to use a tool called `assetsmanager-brunch` this is for manage assets that are not minify or uglify like images or fonts. For this we need to do:

4. Install `assetsmanager-brunch` with `npm` help. Run the following `npm install --save assetsmanager-brunch`
5. Then in the `plugins` section add the following code:

  {{<highlight js>}}
   assetsmanager: {
       copyTo: {
         '/' : ['web/static/vendor/bootstrap/dist/fonts']
       }
   }
{{</highlight>}}

That's all folks! At least for this post I hope you enjoy and Good Luck, Have Fun!
