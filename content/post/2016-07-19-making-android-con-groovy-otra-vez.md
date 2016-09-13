---
title: "Making Android con Groovy(otra vez)"
date: 2016-07-19 19:12:30 -0500
author: José Juan Reyes Zuñiga
published: true
comments: true
tags: [groovy, android, mobile, closure]
categories:
- groovy
- mobile
- android
---

En las vísperas de la fecha en la que escribo este post, habíamos decidido entrar más de lleno con Android dentro del equipo de desarrollo, sin embargo, la convicción fue como siempre hacerlo de forma diferente, o por lo menos algo diferente con respecto a una industria que parecía siempre hacer lo mismo con lo mismo.

Es por ello que me gustaría escribirles al respecto de la experiencia que tuvimos usando Groovy en un proyecto Android, sé de antemano que la atención y los reflectores se encuentran en otros lenguajes, sin embargo, a nosotros nos ayudo muchísimo la  la experiencia que teníamos con el lenguaje pero usándolo en otro contexto muy distinto, y aunque no escribiremos todo lo que hicimos en este post, si les comentaremos en algunos más que fue lo que hicimos y como nos beneficiamos.

Explicarles como agregamos el plugin de Groovy dentro de un proyecto Android está de más, pueden consultarlo directamente en su [repositorio de GitHub][1]. Lo que me gustaría mencionar es que ya está en una versión estable y confiable como para usarse.

<!-- more -->

## La estructura de un proyecto

Al igual que un proyecto Android(Java), hay mucha similaridad integrando Groovy:

```plain
▾ app/
  ▾ src/
    ▾ main/
      ▾ groovy/com/makingdevs/mybarista/
        ▾ common/
            CamaraUtil.groovy
            ImageUtil.groovy
            LocationUtil.groovy
            SingleFragmentActivity.groovy
            WithFragment.groovy
        ▾ database/
        ▾ model/
          ▸ command/
          ▸ repository/
            Comment.groovy
            GPSLocation.groovy
            S3Asset.groovy
            User.groovy
        ▾ network/
          ▾ impl/
              RetrofitTemplate.groovy
            FoursquareRestOperations.groovy
            S3AssetRestOperations.groovy
            UserRestOperations.groovy
        ▾ service/
            CommentManager.groovy
            CommentManagerImpl.groovy
            FoursquareManager.groovy
            FoursquareManagerImpl.groovy
            S3assetManager.groovy
            S3assetManagerImpl.groovy
        ▾ ui/
          ▾ activity/
              PrincipalActivity.groovy
          ▾ adapter/
              CommentAdapter.groovy
              UserAdapter.groovy
          ▾ fragment/
              CameraFragment.groovy
              CommentsFragment.groovy
        ▾ view/
            CustomFontTextView.groovy
      ▸ res/
    app.iml
    proguard-rules.pro
▾ fastlane/
    Appfile
    Fastfile
  android_app.iml
  Gemfile
  Gemfile.lock
  gradle.properties
  gradlew*
  gradlew.bat
  local.properties
  README.md
  settings.gradle
```

## Los modelos

La ventaja de los POGOS de Groovy se siente al declarar o instanciar algún objeto de dominio:

{{<highlight groovy>}}
import groovy.transform.CompileStatic

@CompileStatic
class User {
    String id
    String username
    String token
}
{{</highlight>}}

Ahora instanciamos nuestra clase en cualquier parte:

{{<highlight groovy>}}
User getUserSession(Context context) {
    SharedPreferences session = context.getSharedPreferences("UserSession",Context.MODE_PRIVATE)
    String username = session.getString("username",null);
    String token = session.getString("token",null)
    String id = session.getString("id",null)
    new User(username:username,token:token,id:id)
}
{{</highlight>}}

La nota **importante** aquí es la forma de la instanciación y que no hay palabra reservada `return`, al igual que la declaración del método como `public` no es necesaria. Además de que puedes llamar de forma abreviada a sus atributos.

## `@StaticCompile`

**Groovy es un lenguaje de tipado dinámico opcional**, lo cuál significa que podemos beneficiarnos de ciertos elementos del lenguaje y estar seguros de que compilará correctamente; esta anotación hace al compilador mas estricto, con la ventaja de optimizar el código de byte dando como resultado una mejor ejecución. Los desarrolladores recomiendan el uso intenso de esta anotación en todas las clases dentro del proyecto Android:

{{<highlight groovy>}}
import android.content.Context
import android.content.Intent
import android.support.v4.app.Fragment
import com.makingdevs.app.common.SingleFragmentActivity
import com.makingdevs.app.ui.fragment.RegistrationFragment
import groovy.transform.CompileStatic

@CompileStatic
class RegistrationActivity extends SingleFragmentActivity{

    static Intent newIntentWithContext(Context context){
        Intent intent = new Intent(context, RegistrationActivity)
        intent
    }

    @Override
    Fragment createFragment() {
        new RegistrationFragment()
    }
}
{{</highlight>}}

Realmente este es un tema que se puede extender un poco más, pero iniciando con esto es suficiente.

## Los closures

Para quién ya ha programado en Groovy conocerá que los closures son un elemento fundamental, para quiénes no, podrán compararlos con las lambdas de Java 8 o simplemente como lo que son: closures.

La forma general del closure en Groovy es:

{{<highlight groovy>}}
{ p1,p2,p3... -> body }
{{</highlight>}}

Y creo que es de las partes de las que más podemos comentar, incluso creo que cada beneficio particular que nos da Groovy con los closures lo podremos comentar en un post por separado.

### Implementando interfaces con Closures

El evento más solicitado dentro de una app Android es el _click_ de un componente, con un closure podemos tratarlo:

{{<highlight groovy>}}
@CompileStatic
public class SomeFragment extends Fragment {

    FloatingActionButton mButtonGoChekin

    // ...more code...

    @Override
    View onCreateView(LayoutInflater inflater,
                      @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        mButtonGoChekin= (FloatingActionButton) root.findViewById(R.id.button_go_chekin)
        mButtonGoChekin.onClickListener = {
            Intent intent = AnotherActivity.newIntentWithContext(getContext())
            startActivity(intent)
        }
    }
}
{{</highlight>}}

Ahora aquí una de las que más me gusta en conjunto con otra anotación de Groovy `@Singleton`, de la cual hablaremos en otro post.

{{<highlight groovy>}}
@Singleton
@CompileStatic
class RetrofitTemplate {

    Retrofit retrofit = new Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create())
            .baseUrl(BuildConfig.API_SERVER_URL)
            .build()

    def withRetrofit(Class operations, Closure onSuccess, Closure onError, Closure action){
        CustomRestOperations restOperations = retrofit.create(operations) as CustomRestOperations
        Call<Checkin> model = action(restOperations) as Call<Checkin>
        def callback = [
                onResponse :onSuccess,
                onFailure : onError
        ]
        model.enqueue(callback as Callback<Checkin>)
    }
}
{{</highlight>}}

**Podemos hacer que un mapa se comporte como la implementación de una interfaz**, es sólo cuestión de usar los closures correctamente. Y también podemos ejecutar closures para mandarles parámetros listos para usarse en otros contextos.

## Conclusión

Si bien, Groovy agrega peso a las aplicaciones Android, creo que cada byte y cada línea vale todo lo que no tuvimos que codificar, la fluidez en el teclado y la productividad ganada.


[1]: https://github.com/groovy/groovy-android-gradle-plugin
