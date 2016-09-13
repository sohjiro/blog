---
title: "Uso de camara en android"
date: 2016-07-20 22:53:27 -0500
comments: true
author: Juan Francisco Reyes Silva
published: true
comments: true
tags: [groovy, android, mobile, closure]
categories:
- groovy
- mobile
- android
---

Android se enfoca al desarrollo móvil, como es de esperarse cuenta con las herramientas necesarias para hacer uso del hardware, en esta ocasión se mostrará cómo usar la cámara en un Activity. Adicionalmente, el ejemplo está hecho en Groovy, puedes leer más al respecto en el post anterior.

<!-- more -->

##  Intent en android
Para poder hacer uso de la cámara se realiza mediante intent, que son el mecanismo por el cual se comunica la aplicación en tiempo de ejecución con otros componentes, así como lanzar eventos, se cuenta con dos tipos los cuales son:
**Intento implícito**
Se puede iniciar una actividad en otra aplicación en el dispositivo
**Intento explicito**
Se especifica la clase de la actividad a empezar para que el sistema operativo la inicie


## Acceso a la cámara
Android cuenta con la clase **MediaStore**, esta se encarga de proveer los medios de comunicación, el que nos interesa es **ACTION_IMAGE_CAPTURE**, este en el intent con el cual podemos hacer uso de la cámara.
El siguiente metodo muestra como usar la camara nativa de Android, la clase que se encarga de usarlo es **ExampleCamera**.

{{<highlight groovy>}}
	void launchCamera() {
		Intent camera = new Intent(MediaStore.ACTION_IMAGE_CAPTURE)
		if (camera.resolveActivity(getPackageManager())) {
			try {
				filePhoto = createPhoto("IMG_")
				} catch (IOException ex) {
					Log.d(TAG, "Error ${ex.message}")
				}
				if (filePhoto) {
					camera.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(filePhoto))
					startActivityForResult(camera, CAPTURE_IMAGE)
			}
		}
	}
{{</highlight>}}

## Almacenamiento externo
Al capturar una foto, esta debe ser almacenada para poder ser usada posteriormente, Android provee una unidad principal para ello, la cual puede ser su almacenamiento interno o una memoria SD.

Para acceder a ese directorio, Android cuenta con una clase llamada **Environment**, el método que regresa el directorio de almacenamiento común/externo es **getExternalStoragePublicDirectory(…)**, el tipo de archivo son imágenes por lo cual el parámetro para este caso será **Environment.DIRECTORY_PICTURES**.

El método **createPhoto(...)** se encarga de crear un directorio denominado **ExampleCamera** dentro de **PICTURES**, además de generar el archivo para cada foto, un dato interesante es que no se realizó el import de la clase **File**, la razón es que al usar **groovy**, ciertos paquetes vienen incluidos por default.

{{<highlight groovy>}}
	File createPhoto(String name) {
		File storagePhotos = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES), "ExampleCamera")
		if (!storagePhotos.exists()) {
			if (!storagePhotos.mkdirs()) {
				Log.d(TAG, "Error al crear directorio")
			}
		}
		new File(storagePhotos.getPath() + File.separator + "${name + new Date().format("ddMMyyyy_HHmmss")}.jpg")
	}
{{</highlight>}}

## Manipular el resultado de la cámara
Cuando se captura la foto, una vez que termina se maneja el resultado con el método onActivityResult(…), donde se verifica el estatus de la captura de la foto, ya sea que se culminó o cancelado, ante lo cual se muestra un mensaje emergente haciendo uso de los **Toast**.

{{<highlight groovy>}}
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data)
		if (requestCode == CAPTURE_IMAGE) {
			if (resultCode == RESULT_OK) {
				Toast.makeText(getApplicationContext(), "Exito al crear la foto", Toast.LENGTH_SHORT).show()
			} else if (resultCode == RESULT_CANCELED) {
				Toast.makeText(this, "Se cancelo la foto", Toast.LENGTH_LONG).show()
			} else {
				Toast.makeText(this, "Error al capturar la foto", Toast.LENGTH_LONG).show()
			}
		}
	}
{{</highlight>}}

## Permisos de Android
A la hora de manejar el hardware se debe de pedir ciertos permisos como son el escribir y leer en la memoria externa, así como usar la cámara, para esto se usa la etiqueta ``<uses-permission>`` donde se coloca que permiso es solicitado.
``<uses-feature android:name="android.hardware.camera" android:required="true" />``
``<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>``

## Imports default groovy
Groovy realiza el import de los paquetes más usados, para reducir el código.
``import java.lang.*``
``import java.util.*``
``import java.io.*``
``import java.net.*``
``import groovy.lang.*``
``import groovy.util.*``
``import java.math.BigInteger``
``import java.math.BigDecimal``

Pueden encontrar el código completo [*aquí*][1].

[1]: https://github.com/reyes271292/camera_android

[2]: https://developer.android.com/reference/android/provider/MediaStore.html

[3]: https://developer.android.com/reference/android/content/Intent.html

[4]: https://developer.android.com/reference/android/os/Environment.html

[5]: https://developer.android.com/training/basics/intents/result.html

[6]: https://developer.android.com/guide/topics/ui/notifiers/toasts.html
