+++
title= "Personalizar notificaciones de correo en Jenkins"
date="2014-11-06 19:08:56 -0500"
author="Fernando Maza Bizarro"
comments="true"
categories=["development","continuous integration"]
+++

Las **notificaciones** son básicas para la correcta comunicación de los involucrados de nuestros proyectos como: *Stakeholders/ Key Users / Developers / Clientes / Testers*.

Por esta razón te recomiendo personalizar las notificaciones por defecto de **Jenkins**.

Objetivo: Informar los despliegues desde Jenkins por correo, usando el [plugin: Email-ext][1]

<!-- more -->
Procedimiento:

1.  Instalar el plugin desde la consola de administración de Jenkins. ![Screenshot 1](/images/IC-Jenkins-PlugIn-Email-Ext_01.jpg)

2.  Configurar la cuenta de correo saliente SMTP, te recomiendo que uses el autenticado.![Screenshot 2](/images/IC-Jenkins-PlugIn-Email-Ext_02.jpg)

3.  Configurar el plugin: Email-ext con información base de los usuarios a notificar ( *Stake Holders/ Key Users / Developers / Clientes / Testers* ) en las listas por DEFAULT de la configuración general a nivel. Esto te permitirá contar con la misma configuración para tus N tareas de despliegue. ![Screenshot 3](/images/IC-Jenkins-PlugIn-Email-Ext_03.jpg)

4.  Para personalizar el correo que se enviará, copiaremos un**Template** dentro del Home de Jenkins, *static-analysis.jelly* y asignando nombre relacionado al proyecto. Si requieres más información, consulta la [documentación del plugin en GitHub][5]. Este template es un **HTML el cual puedes editar su contenido**, incluyendo titulo del proyecto, una imagen, etc. ![Screenshot 4](/images/IC-Jenkins-PlugIn-Email-Ext_04.jpg)

5.  Añade en una tarea de Jenkins, un paso al finalizar, usando Email notification. ![Screenshot 5](/images/IC-Jenkins-PlugIn-Email-Ext_05.jpg)

6.  Ejecuta tu tarea y verifica el correo recibido. ![Screenshot 6](/images/IC-Jenkins-PlugIn-Email-Ext_06.jpg)

 [1]: https://wiki.jenkins-ci.org/display/JENKINS/Email-ext+plugin
 [5]: https://github.com/jenkinsci/email-ext-plugin/tree/master/src/main/resources/hudson/plugins/emailext/templates
