+++
title= "Introduccion a Ratpack"
date="2014-08-19 00:34:28 -0500"
author="Felipe Juárez Murillo"
comments=" true"
+++

Es bueno estar de vuelta escribiendo, ya ha pasado bastante tiempo desde que hice un post así que vamos a ver algo que me ayudó en un curso. El día de hoy hablaremos de Ratpack y para ello primero vamos a dar una pequeña introducción de lo que es. Ratpack, como su página lo dice, es un conjunto de librerías de JAVA que facilita la rapidez, eficiencia, evolución y pruebas de aplicaciones HTTP, está construida sobre Netty y por ello posee muchos de los beneficios del motor del mismo. Ratpack se enfoca en permitir applicaciones HTTP para ser eficientes, modulares y adaptativas a los nuevos requerimientos, tecnologías y buenas pruebas sobre el tiempo. Bueno vamos a dejar de momento las definiciones y vamos a lo bonito, el código.
<!-- more -->
Para este post vamos a hacer uso de gvm y de lazybones, para ello procederemos a instalar [gvm][1] Una vez listo procedemos a ejecutar el siguiente comando :
{{<highlight bash>}}
gvm install lazybones
{{</highlight>}}

Y con ello tendremos lazybones instalado en nuestra máquina... bueno y ¿para que necesitamos lazybones si es un post sobre Ratpack? Lazybones es una herramienta de línea de comandos que nos permite generar una estructura de un proyecto para cualquier framework basado en plantillas predefinidas. Y Ratpack tiene varias plantillas para lazybones que pueden ser encontradas en

[Bintray][2] en el apartado de [ratpack/lazybones repository][3]. Si desean saber un poco más de Lazybones pueden encontrarlo en la [documentación][4] Para crear la estructura del proyecto ejecutaremos la siguiente sentencia :/Users/makingdevs/Documents/proyectos/blog/prueba_hugo/respaldo/2015-04-29-introduccion-a-ratpack.markdown

``` bash
lazybones create ratpack contact-book
```

Al ejecutar la instrucción nos aparecerá en pantalla una serie de instrucciones y también lo que ganamos al ejecutarla. A parte nos da la estructura de directorios que se genera y nos dice como levantar nuestra aplicación.

``` bash
  <proj>
    |
    +- src
        |
        +- ratpack
        |     |
        |     +- ratpack.groovy
        |     +- ratpack.properties
        |     +- public          // Static assets in here
        |          |
        |          +- images
        |          +- lib
        |          +- scripts
        |          +- styles
        |
        +- main
        |   |
        |   +- groovy
                 |
                 +- // App classes in here!
        |
        +- test
            |
            +- groovy
                 |
                 +- // Spock tests in here!
```

Para levantar el ejemplo nos movemos a la carpeta con cd, ejecutamos lo siguiente y nos preparamos un café porque va a descargar dependencias XD:
`./gradlew run`

Una vez que terminó de ejecutarse podemos ver lo que se creó en la url http://localhost:5050 como podrán observar la página que se creó no es gran cosa pero ya tenemos lo necesario para trabajar en una aplicación un poco más compleja como iremos viendo a lo largo de este post. Como podremos ver en el **README.md** existen prácticamente tres archivos principales:

- **build.gradle**
- **Ratpack.groovy**
- **index.html**

El primero es un archivo de gradle (para los que no lo han manejado o conocen de él pueden revisar el siguiente [link][5] pero a grandes rasgos gradle vendría siendo lo mismo que Maven pero con drogas XD. El segundo archivo es donde usualmente sucede la magia ya que es donde se resuelven las urls y se hace todo el show necesario. Y el tercer archivo no es más que una plantilla html que se visualiza a través del segundo archivo. Con los arvhivos que vamos a estar trabajando de momento son **index.html** y **Ratpack.groovy**. En el tag body del html dejamos lo siguiente:

{{<highlight html>}}
<body>
  <section>
    <h1>${model.title}</h1>
    <p>This is the main page of your contacts</p>
  </section>

  <footer class="site-footer"></footer>
</body>
{{</highlight>}}

Y en el **Ratpack.groovy** dejamos lo siguiente:

{{<highlight groovy>}}
import static ratpack.groovy.Groovy.groovyTemplate
import static ratpack.groovy.Groovy.ratpack

ratpack {
  handlers {
    get {
      render groovyTemplate("index.html", title: "Contact book")
    }

    assets "public"
  }
}
{{</highlight>}}

Recargamos la página y vemos el cambio. Ahora vamos a añadir un form para poder agregar a un elemento a la lista de contactos. Para ello agregamos un link a nuestro _index.html_

{{<highlight html>}}
  <body>
    <section>
      <h1>${model.title}</h1>
      <p>This is the main page of your contacts</p>
    </section>

    <a href="create">Create contact</a>

    <footer class="site-footer"></footer>

    <!-- build:js scripts/jquery.js -->
    <script src="lib/jquery/jquery.min.js"></script>
    <!-- endbuild -->
  </body>
{{</highlight>}}

Ahora para visualizar la nueva página le agregamos al archivo **Ratpack.groovy** lo siguiente :

{{<highlight groovy>}}
get('contacts/new') {
  render groovyTemplate("contacts/new.html", title: "New contact")
}
{{</highlight>}}

Y dentro de la carpeta de templates creamos una carpeta llamada contacts y dentro de ella agregamos un archivo llamado **new.html**

{{<highlight html>}}
<!doctype html>
  <!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
  <!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
  <!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
  <!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>Ratpack: ${model.title}</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">
  </head>

  <body>
    <section>
      <h1>${model.title}</h1>
    </section>

    <a href="/">Home</a>

    <footer class="site-footer"></footer>
  </body>
</html>
{{</highlight>}}

Así para cuando regresemos a la página y la recarguemos podemos ver el link y hasta el momento navegar la página sin problemas. Ahora vamos a agregar un pequeño formulario para poder capturar los datos del contacto, como son:

- **Nombre**
- **Apellidos**
- **Correo**
- **Alias**
- **Teléfono**

Para ello vamos a hacer un formulario común y silvestre en el html:

{{<highlight html>}}
  <body>
    <section>
      <h1>${model.title}</h1>
    </section>

    <form action="/contacts" method="post">
      <div>
        <label for="name"/>Name</label>
        <input type="text" name="name" />
      </div>

      <div>
        <label for="lastName"/>Last name</label>
        <input type="text" name="lastName" />
      </div>

      <div>
        <label for="email"/>Email</label>
        <input type="text" name="email" />
      </div>

      <div>
        <label for="nickname"/>Nickname</label>
        <input type="text" name="nickname" />
      </div>

      <div>
        <label for="phone"/>Phone</label>
        <input type="text" name="phone" />
      </div>

      <button type="submit"> Create </button>
    </form>

    <a href="/">Home</a>

    <footer class="site-footer"></footer>
  </body>
{{</highlight>}}

Una vez que tenemos eso lo demás es cuestión de recibirlo y procesarlo para ello hacemos uso del handler post con el path al que va a responder y vamos a agregarlo a una variable global (esto es para efectos de ejemplo no intenten esto en casa o sus trabajos XD)

{{<highlight groovy>}}
ratpack {
  def contacts = []

  handlers {
    get {
      render groovyTemplate("index.html", title: "Contact book")
    }

    post('contacts') {
      Form form = context.parse(Form)
      def contact = [:]
      contact.id = contacts ? contacts.id.max() + 1 : 1
      contact.name = form.name
      contact.lastName = form.lastName
      contact.email = form.email
      contact.nickname = form.nickname
      contact.phone = form.phone
      contacts << contact
      redirect "/contacts/${contact.id}"
    }

    get('contacts/new') {
      render groovyTemplate("contacts/new.html", title: "New contact")
    }

    assets "public"
  }
}
{{</highlight>}}

Como podrán observar mediante el `context.parse(Form)` obtenemos los datos enviados en la petición y de esa manera podemos acceder a los datos enviados como si fuera un mapa de groovy. Al final de la petición hacemos un redirect para ver los datos que se han creado con esa petición, pero de momento esto no funciona así que vamos a agregar un nuevo handler con algo que se le llama *pathTokens* y para ello agregamos lo siguiente:

{{<highlight groovy>}}
  get('contacts/:id') {
    def id = pathTokens.asLong('id')
    def contact = contacts.find {
      it.id == id
    }
    render groovyTemplate("contacts/show.html", contact:contact)
  }
{{</highlight>}}

Así mismo agregamos la página que va a visualizar los datos del contacto dentro de la carpeta *contacts*:

{{<highlight html>}}
<html>
  <head>
    <title>Ratpack: Show contact</title>
  </head>

  <body>
    <section>
      <h1>Show contact</h1>
    </section>

    <div>
      <div>
        <label for="name"/>Name : </label>
        <span><strong> ${model.contact.name} </strong></span>
      </div>

      <div>
        <label for="lastName"/>Last name : </label>
        <span><strong> ${model.contact.lastName} </strong></span>
      </div>

      <div>
        <label for="email"/>Email : </label>
        <span><strong> ${model.contact.email} </strong></span>
      </div>

      <div>
        <label for="nickname"/>Nickname : </label>
        <span><strong> ${model.contact.nickname} </strong></span>
      </div>

      <div>
        <label for="phone"/>Phone : </label>
        <span><strong> ${model.contact.phone} </strong></span>
      </div>
    </div>

    <ul>
      <li> <a href="/">Home</a> </li>
      <li> <a href="contacts/new">New contact</a> </li>
    </ul>

  </body>
</html>
{{</highlight>}}

Ahora vamos a visualizar nuestra lista de contactos y para ello agregaremos un nuevo *handler* y un nuevo elemento llamado *byMethod*:

{{<highlight groovy>}}
  handler("contacts") {
    byMethod {
      get {
        render groovyTemplate("contacts/list.html", contacts: contacts)
      }

      post {
        Form form = context.parse(Form)
        def contact = [:]
        contact.id = contacts ? contacts.id.max() + 1 : 1
        contact.name = form.name
        contact.lastName = form.lastName
        contact.email = form.email
        contact.nickname = form.nickname
        contact.phone = form.phone
        contacts << contact
        redirect "/contacts/${contact.id}"
      }
    }
  }
{{</highlight>}}

Lo que hará el *handler* es manejar la url "contacts" y delegarla por al método por el cual se haya realizado la petición en el caso de GET visualizará la lista de contactos pero si es por POST agregará los datos del contacto y después de agregarse se visualizará la información de dicho contacto. También agregaremos un link a la lista de contactos para poder visualizar cada uno de los datos de manera individual esto es por si se tiene información extra que no se muestre en el detalle general de la lista de contactos.

{{<highlight html>}}
<html>
  <head>
    <title>Ratpack: Contact list</title>
  </head>

  <body>
    <section>
      <h1>Contact list</h1>
    </section>

    <div>
      <table border="1">
        <thead>
          <tr>
            <th>Name</th>
            <th>Last name</th>
            <th>Phone</th>
            <th>Email</th>
            <th>Nickname</th>
            <th>Show</th>
          </tr>
        </thead>
        <tbody>
          <% model.contacts.each { %>
            <tr>
              <td>${it.name}</td>
              <td>${it.lastName}</td>
              <td>${it.phone}</td>
              <td>${it.email}</td>
              <td>${it.nickname}</td>
              <td> <a href="/contacts/${it.id}">Show</a> </td>
            </tr>
          <% } %>
        </tbody>
      </table>
    </div>

    <ul>
      <li> <a href="/">Home</a> </li>
      <li> <a href="contacts/new">New contact</a> </li>
    </ul>

  </body>
</html>
{{</highlight>}}

Ya nos falta poco para poder tener un *CRUD* completo, solo nos falta eliminar y actualizar (casi nada XD). Así que para ello vamos a agregar un *handler* más y anidar un *byMethod* como lo hicimos con el POST de *contacts*. Para ello hacemos lo siguiente:

{{<highlight groovy>}}
  handler("contacts/:id") {
    byMethod {
      get {
        def id = pathTokens.asLong('id')
        def contact = contacts.find {
          it.id == id
        }
        render groovyTemplate("contacts/show.html", contact:contact)
      }

        delete {
          def id = pathTokens.asLong('id')
          contacts = contacts.findAll {
            it.id != id
          }
          render "ok"
        }
    }
  }
{{</highlight>}}

Ahora una pregunta, ¿Cómo hacemos para llamar a ese método desde la página? bueno para hacer eso vamos a requerir a jQuery y para ello ocuparemos [Bower][6] y para instalar jquery usamos el siguiente comando: `bower install jquery`.

Esto nos creará una carpeta llamada *bower_components* que de momento moveremos a la carpeta de **src/ratpack/public/lib** para tenerla disponible en la aplicación:  `mv bower_components src/ratpack/public/lib/`.

Una vez hecho procedemos a incluir el script en la app en la lista de contactos y agregamos un archivo más que es el que se encargará de eliminar el elemento.

{{<highlight html>}}
  <script src="lib/bower_components/jquery/dist/jquery.js"></script>
  <script src="scripts/delete.js"></script>
{{</highlight>}}

El código de eliminar es relativamente sencillo ya que lo que vamos a hacer es que cada elemento con la clase delete vamos a añadir el evento click y vamos a realizar la llamada al server con los datos del href.

{{<highlight javascript>}}
  $(function() {
    $(".delete").click(function(event) {
      event.preventDefault();
      var url = $(event.target).attr('href');
      $.ajax({
        type: "DELETE",
        url: url,
      }).success(function(data) {
        location.reload();
      });
    });
  });
{{</highlight>}}

Una vez realizado esto podremos ver como nuestros datos cambian al eliminar un elemento de la lista de contactos. Veamos ahora como editar un elemento. Para la edición vamos a hacerlo de la manera más fácil que podamos esto es agregaremos en el *byMethod* anterior el método POST, agregamos otro GET más para visualizar la pantalla de edición y actualizaremos los datos de ese elemento, para ello requerimos crear una pantalla nueva y agregarla a la navegación:

{{<highlight groovy>}}
  get("contacts/:id/edit") {
    def id = pathTokens.asLong('id')
    def contact = contacts.find {
      it.id == id
    }
    render groovyTemplate("contacts/edit.html", title:"Editing contact", contact:contact)
  }

  handler("contacts/:id") {
    byMethod {
      post {
        def id = pathTokens.asLong('id')
        def contact = contacts.find {
          it.id == id
        }

        Form form = context.parse(Form)
        contact.name = form.name
        contact.lastName = form.lastName
        contact.email = form.email
        contact.nickname = form.nickname
        contact.phone = form.phone

        render groovyTemplate("contacts/show.html", contact:contact)
      }
    }
  }
{{</highlight>}}

{{<highlight html>}}
  <!doctype html>
  <html>
    <head>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    </head>

    <body>
      <section>
        <h1>${model.title}</h1>
      </section>

      <form action="/contacts/${model.contact.id}" method="post">
        <div>
          <label for="name"/>Name</label>
          <input type="text" name="name" value="${model.contact.name}" />
        </div>

        <div>
          <label for="lastName"/>Last name</label>
          <input type="text" name="lastName" value="${model.contact.lastName}"/>
        </div>

        <div>
          <label for="email"/>Email</label>
          <input type="text" name="email" value="${model.contact.email}"/>
        </div>

        <div>
          <label for="nickname"/>Nickname</label>
          <input type="text" name="nickname" value="${model.contact.nickname}"/>
        </div>

        <div>
          <label for="phone"/>Phone</label>
          <input type="text" name="phone" value="${model.contact.phone}"/>
        </div>

        <button type="submit"> Update </button>
      </form>

      <ul>
        <li> <a href="/">Home</a> </li>
        <li> <a href="/contacts">Contact list</a> </li>
        <li> <a href="/contacts/new">New contact</a> </li>
      </ul>

      <footer class="site-footer"></footer>
    </body>
  </html>
{{</highlight>}}

Y de esta manera tenemos un pequeño CRUD con llamadas normales y un poco de jquery. En POST posteriores vamos a tomar este código y vamos a hacerle algunas mejoras. Para empezar haremos uso de los groovyTemplates como tal y ajustaremos esto a que se maneja más por REST. Espero les haya gustado y cualquier duda o comentario ya saben donde encontrarnos.

**Saludos. GLHF.**

 [1]: http://gvmtool.net/ "gvm"
 [2]: https://bintray.com/
 [3]: https://bintray.com/ratpack/lazybones
 [4]: https://github.com/pledbrook/lazybones#running-it
 [5]: http://www.gradle.org/documentation
 [6]: http://bower.io/]
