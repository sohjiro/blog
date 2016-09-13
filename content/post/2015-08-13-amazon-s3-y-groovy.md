---
title: "Amazon S3 y Groovy"
date: 2015-08-13 22:47:08 -0500
author: José Juan Reyes Zuñiga
comments: true
categories: [groovyi,s3,cloud]
---
En una de las tareas que realice recientemente, tuve la necesidad de transferir un par de archivos que obtuve de un endpoint(de la cual hablaré en otro post) hacia un Bucket de Amazon S3.

La solución inmediata fue usar una biblioteca que encontré para Java de nombre [jets3t][1], la cual, provee de un conjunto de herramientas muy simple para operar con Amazon S3, Cloud Front y Google Storage.

El caso muy puntual que tuve que resolver fue subir un archivo y despúes borrarlo de un bucket muy particular. En este ejemplo muestro primero como listar todos los buckets disponibles en una cuenta de S3.

<!-- more -->
{{<highlight groovy>}}
@Grapes(
    @Grab(group='net.java.dev.jets3t', module='jets3t', version='0.9.3')
)

import org.jets3t.service.security.*
import org.jets3t.service.*
import org.jets3t.service.impl.rest.httpclient.*
import org.jets3t.service.model.*
import org.jets3t.service.acl.*

String awsAccessKey = "YOURAWSACCESSKEY"
String awsSecretKey = "YOURAWSSECRETKEY"

AWSCredentials awsCredentials = new AWSCredentials(awsAccessKey, awsSecretKey)
S3Service s3Service = new RestS3Service(awsCredentials)

S3Bucket[] myBuckets = s3Service.listAllBuckets()
{{</highlight>}}

Despúes, una vez con todos los buckets, podemos listar los archivos contenidos dentro de bucket muy particular.

{{<highlight groovy>}}
String bucletName = "makingdevs-bucket"

bucket = myBuckets.find { it.name==bucketName }

s3Objects = s3Service.listObjects(bucket)
{{</highlight>}}

Finalmente, podemos subir un archivo específico hacia el bucket que deseamos.

{{<highlight groovy>}}

file = new File("/some/file/in/your/filesystem.ext")

S3Object s3Object = new S3Object()
s3Object.with {
  setAcl AccessControlList.REST_CANNED_PUBLIC_READ
  setContentLength file.length()
  setContentType file.toURL().openConnection().contentType
  setDataInputFile file
  setKey file.name
  setBucketName bucket.getName() // we use our previous bucket
}

s3Service.putObject bucket, s3Object
{{</highlight>}}

Una vez que llamamos al servicio `s3Service` el archivo queda colocado en el bucket. Y finalmente si deseamos borrarlo podemos usar `s3Service.deleteObject s3Bucket, s3Object.key`, en donde sólo mandamos el objeto del bucket y el _key_ del objeto que deseamos borrar.

Finalmente, me gustaría detallar dos líneas que en mi opinión son relevantes:

- La parte de `acl AccessControlList.REST_CANNED_PUBLIC_READ`, la cual indica que el archivo que se sube es de acceso público para quién quiera que tenga la URL y sólo el propietario puede modificar, existen otras constantes que dan combinaciones de permisos distintos en [la documentación de JetS3t][2].
- La línea con `contentType file.toURL().openConnection().contentType` que es una forma de obtener el _content type_ sin la necesidad de una biblioteca adicional, sólo con el uso convencional de las clases Java con las que ya contamos. Les recomiendo tomar cualquier archivo y probar sólo esa línea.

Si bien hay más cosas que se pueden hacer, les sugiero se den una vuelta por la documentación de esta biblioteca.

 [1]: http://www.jets3t.org/
 [2]: http://www.jets3t.org/api/org/jets3t/service/acl/AccessControlList.html
