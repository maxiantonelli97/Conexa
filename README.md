# Conexa

# Sobre el proyecto

Este es un proyecto creado por mí, Maximiliano Antonelli, como prueba técnica para Conexa.

Tenemos un patrón de arquitectura MVVM.

Se usan en el proyecto: SwiftUI, la librería de GoogleMaps, Combine, entre otras.

Tenemos también los UnitTest de las funciones del ViewModel.

La consigna básicamente fue la siguiente:

---
La aplicación debe constar de 4 pantallas:

- Lista y buscador de noticias por título o contenido (Pantalla de Inicio)
- Detalles de la noticia seleccionada (Pantalla de Detalle)
- Lista de usuarios (Pantalla de Usuarios)
- Ubicación en el mapa del usuario (Pantalla de Mapa)

La app deberá ser una lista de noticias y una lista de usuarios. En la lista de usuarios debe mostrarse un botón que abra la pantalla de mapa, en donde con Google Maps debe mostrar la ubicación del usuario seleccionado. No hay restricciones en cuanto a los datos que se muestran tanto de las noticias como de los usuarios.

---

Entonces, decidí tener 2 secciones principales: Noticias y Usuarios. Cada una en un tab diferente.

Liste los items en cada sección, y al tocar en cada uno, te lleva a una nueva vista: Para las noticias, muestra la información extendida. Y para los usuarios, muestra su ubicación en el mapa.

# 🧭 Configuración Inicial del Proyecto Xcode

Este documento explica cómo configurar los archivos necesarios para que tu proyecto funcione correctamente con claves secretas y servicios como Google Maps.

---

## 1️⃣ Agrega el archivo `GoogleService-Info.plist`

Coloca el archivo `GoogleService-Info.plist` en la **carpeta raíz** de tu proyecto.

![Google plist](assets/GooglePlist1.jpeg)

---

## 2️⃣ Crea el archivo `Secrets.plist`

En la **carpeta principal del proyecto**, crea un archivo de tipo **Property List** llamado `Secrets.plist`.

![Secrets plist](assets/Secrets2.jpeg)

---

## 3️⃣ Asegúrate de incluir el Target correcto

Verifica que el archivo `Secrets.plist` esté marcado para el target correspondiente dentro del proyecto.

![Target](assets/Target3.jpeg)

---

## 4️⃣ Agrega tu clave `MAP_API_KEY`

Dentro de `Secrets.plist`, agrega la clave `MAP_API_KEY` con el valor correspondiente a tu API Key.

![Key](assets/Key4.jpeg)

---

✅ ¡Listo! Ya podes darle a "Build" y ejecutar la aplicación
