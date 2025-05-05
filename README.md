# Intentary Pro

![Flutter](https://img.shields.io/badge/Flutter-Framework-blue?logo=flutter)

Aplicación Flutter desarrollada como respuesta a la **Prueba Técnica Desarrollador Móvil**.

## 📱 Descripción del Proyecto

Aplicación para la **gestión básica de inventarios**, permitiendo:
- Consultar productos disponibles
- Registrar entradas y salidas de mercancías
- Autenticación local de usuarios

## 🛠️ Stack Tecnológico

- **Framework**: Flutter
- **Gestión de Estado**: Riverpod
- **Base de Datos**: SQLite (local)
- **Autenticación**: Local
- **Arquitectura**: Clean Architecture

## 🧱 Estructura del Proyecto

La aplicación está organizada en dos carpetas principales, siguiendo los principios de Clean Architecture:

### `/core`
Contiene elementos compartidos en toda la app:
- Servicios generales (e.g. notificaciones)
- Routing
- Temas
- Widgets comunes
- Casos de uso generales
- Manejo de errores
- Configuración de la base de datos
- DI (Dependency Injection Globales) con `Riverpod`

### `/features`
Contiene los módulos funcionales independientes:
- **auth/**: Módulo de autenticación (data, domain, presentation, di)
- **home/**: Módulo principal del menú
- **inventory/**: Gestión del inventario
- **movements/**: Registro de entradas y salidas
- **error/**: Página para manejar errores de routing

## 🧩 ¿Cómo se aplica Clean Architecture?

Se siguen tres capas principales:

### 1. **Data**
- Implementa fuentes de datos locales (como SQLite).
- Define los modelos (DTO) y repositorios concretos.
- Se conecta con la base de datos y transforma datos crudos.

### 2. **Domain**
- Contiene las entidades y los casos de uso (use cases).
- Esta capa es completamente independiente del framework Flutter.
- Define la lógica de negocio y las interfaces (abstract classes) que deben implementar los repositorios.

### 3. **Presentation**
- Es la interfaz de usuario.
- Usa `Riverpod` como sistema de gestión de estado.
- Aquí se conecta con los casos de uso definidos en `domain`.

### 4. **DI (Dependency Injection)**
- La DI se realizó con flutter_riverpod, enlazando los distintos niveles del proyecto (data, domain y presentation) con proveedores bien definidos

El flujo de dependencias siempre va desde **Presentation → Domain → Data**, nunca al revés. Esto permite mayor mantenibilidad, testeo e independencia de tecnologías.

## 🔔 Sistema de Notificaciones

Se desarrolló un sistema de notificaciones **desde cero** dentro del proyecto. Este permite mostrar alertas y mensajes contextuales de manera consistente en toda la aplicación, sin usar paquetes externos.

## 📦 Dependencias Usadas

```yaml
# Navegación
go_router: ^15.1.1

# UI & Tipografía
google_fonts: ^6.2.1

# Gestión de estado y programación funcional
dartz: ^0.10.1
flutter_riverpod: ^2.6.1

# Persistencia local
path: ^1.9.1
sqflite: ^2.4.2

# Internacionalización y formatos
intl: ^0.19.0
```

## 📲 Instalación y Ejecución

1. Clona el repositorio:
   ```bash
   git clone https://github.com/JulianDr14/inventar-pro-flutter.git
   ```
2. Accede a la carpeta:
   ```bash
   cd inventar-pro-flutter
   ```
3. Instala dependencias:
   ```bash
   flutter pub get
   ```
4. Corre la app en un emulador o dispositivo físico:
   ```bash
   flutter run
   ```

## ✅ Funcionalidades Implementadas

- Inicio de sesión local
- Menú con navegación entre módulos
- Visualización del inventario
- Registro de entradas/salidas
- Manejo de errores con pantalla dedicada