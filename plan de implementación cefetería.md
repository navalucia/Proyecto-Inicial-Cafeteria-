# 📋 Plan de Implementación: Aplicación "Cafetería" (Flutter + Firebase)

## 🎯 Objetivo
Definir un procedimiento estructurado, libre de código, para desarrollar una aplicación multiplataforma (Android/iOS/Web) de gestión y visualización de una cafetería, utilizando **Flutter/Dart**, **Firebase (Authentication + Firestore)**, **Provider** para estado, y herramientas profesionales de UI/UX, IDE y control de versiones.

---

## 🛠️ Herramientas y Entorno Requerido
| Categoría | Herramienta Recomendada | Propósito |
|-----------|------------------------|-----------|
| **IDE / Editor** | VS Code o Android Studio *(nota: "antigravity" probablemente es un error tipográfico por Android Studio)* | Desarrollo, debugging, emuladores, extensiones Flutter |
| **UI/UX Diseño** | Figma, Penpot o Adobe XD | Wireframes, prototipos interactivos, sistema de diseño |
| **Control de Versiones** | Git + GitHub / GitLab | Historial, colaboración, CI/CD |
| **Emuladores / Dispositivos** | Android Emulator, iOS Simulator (macOS), dispositivo físico | Pruebas multiplataforma |
| **Gestión de Paquetes** | `dart pub` | Instalación y actualización de dependencias |
| **Backend / Cloud** | Firebase Console + Firebase CLI | Configuración de Auth, Firestore, Analytics, Crashlytics |

---

## 🎨 Fase de Diseño UI/UX
1. **Definición de Flujos de Usuario**
   - Registro → Login → Pantalla Principal → Catálogo de Productos → Carrito → Perfil → Cierre de sesión
2. **Wireframing de Baja Fidelidad**
   - Esquema de navegación, jerarquía visual, ubicación de elementos críticos (botones, listas, formularios)
3. **Sistema de Diseño (Design System)**
   - Paleta cromática (tonos café, crema, acentos cálidos)
   - Tipografía legible para títulos, descripciones y precios
   - Espaciado consistente, estados de botones, componentes reutilizables (tarjetas, inputs, modales)
4. **Prototipo Interactivo**
   - Validación de usabilidad con usuarios objetivo o equipo interno
   - Exportación de assets optimizados (SVG, PNG @2x/@3x, splash screen, íconos)
5. **Documentación de Requerimientos UI**
   - Lista de pantallas, componentes, estados de carga/error, validaciones de formulario

---

## 📦 Dependencias Requeridas (`pubspec.yaml`)
*(Se listarán sin versiones para evitar desfases; las versiones estables se fijarán durante la implementación)*

| Paquete | Propósito |
|---------|-----------|
| `firebase_core` | Inicialización del ecosistema Firebase |
| `firebase_auth` | Autenticación por correo y contraseña |
| `cloud_firestore` | Base de datos en tiempo real, consultas, sincronización |
| `provider` | Gestión de estado reactivo y inyección de dependencias |
| `cached_network_image` | Carga y caché de imágenes del menú/productos |
| `intl` | Formateo de fechas, monedas y localización |
| `flutter_svg` | Renderizado de íconos y gráficos vectoriales |
| `shared_preferences` | Almacenamiento local ligero (preferencias de usuario, tema) |
| `go_router` *(opcional)* | Enrutamiento declarativo y profundo |
| `flutter_lints` / `very_good_analysis` | Reglas de calidad y estilo de código |

---

## 🔥 Configuración de Firebase
1. Crear proyecto en Firebase Console y asignar nombre "cafeteria-app"
2. Registrar aplicaciones para Android, iOS y Web
3. Descargar archivos de configuración:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`
   - Configurar web con credenciales desde la consola
4. Habilitar **Authentication** → Método "Correo electrónico/Contraseña"
5. Crear base de datos **Firestore**:
   - Definir estructura de colecciones sugerida: `users`, `products`, `orders`, `categories`
   - Configurar reglas de seguridad iniciales (acceso autenticado, lectura pública limitada, escritura restringida)
6. (Opcional) Instalar Firebase CLI para emulación local de Auth/Firestore durante desarrollo

---

## 🏗️ Arquitectura y Gestión de Estado (Provider)
- **Patrón recomendado:** `Feature-First` o `Clean Architecture` simplificado
- **Capas:**
  - `ui/` → Pantallas, widgets, temas, enrutamiento
  - `providers/` → `ChangeNotifier` para estado global (auth, carrito, productos)
  - `services/` → Lógica de Firebase Auth y Firestore
  - `models/` → Clases de datos con métodos `toMap()` / `fromMap()`
  - `utils/` → Constantes, helpers, validaciones, formateadores
- **Flujo Provider:**
  - `AuthNotifier`: maneja estado de sesión, login, registro, logout
  - `CartNotifier`: gestiona items, cantidades, totales, sincronización opcional con Firestore
  - `ProductNotifier`: carga catálogo desde Firestore, aplica filtros/categorías
  - Uso de `MultiProvider` en `main.dart` para inyección global

---

## 📝 Procedimiento Paso a Paso (Fases de Desarrollo)

### 🔹 Fase 1: Inicialización del Proyecto
- Instalar Flutter SDK y verificar entorno (`flutter doctor`)
- Crear proyecto: `flutter create cafeteria_app`
- Configurar IDE (VS Code/Android Studio) con extensiones oficiales Flutter/Dart
- Inicializar repositorio Git y rama principal (`main`/`dev`)
- Configurar `pubspec.yaml` con nombre, descripción, assets, fonts y dependencias base

### 🔹 Fase 2: Estructura y Configuración UI
- Crear arquitectura de carpetas según modelo definido
- Implementar tema global (`ThemeData`), paleta, tipografía, constantes
- Configurar enrutamiento inicial (pantalla de carga → login → home)
- Integrar splash screen y configuración de íconos
- Validar renderizado en Android y iOS/emuladores

### 🔹 Fase 3: Autenticación (Firebase Auth)
- Inicializar Firebase en la app (`Firebase.initializeApp()`)
- Crear formularios de Login y Registro con validación de campos
- Implementar `AuthNotifier` con métodos: `signIn`, `signUp`, `signOut`, `authStateChanges`
- Manejar estados de carga, errores y redirección post-autenticación
- Verificar flujo completo en Firebase Console (usuarios creados, tokens, sesiones)

### 🔹 Fase 4: Base de Datos Firestore
- Definir modelos Dart para `User`, `Product`, `Order`, `Category`
- Crear `FirestoreService` con métodos de lectura/escrita/escucha en tiempo real
- Configurar reglas de seguridad en Firebase Console (probar con simulador)
- Implementar paginación o límites para listas largas
- Validar sincronización offline/online y manejo de errores de red

### 🔹 Fase 5: Integración Provider y Lógica de Negocio
- Envolver app con `MultiProvider`
- Vincular UI con notifiers mediante `Consumer` / `context.read()`
- Implementar carrito de compras: agregar, modificar cantidad, eliminar, calcular totales
- Sincronizar estado de carrito con Firestore (opcional, según requerimiento)
- Optimizar reconstrucciones de widgets (`Provider.of<T>(context, listen: false)`)

### 🔹 Fase 6: Pantallas Core y Experiencia de Usuario
- Desarrollar catálogo de productos con filtros por categoría
- Implementar vista detalle de producto
- Crear flujo de carrito → resumen → confirmación (simulado o real)
- Añadir perfil de usuario: ver datos, editar nombre, historial de pedidos
- Implementar estados de carga, vacíos, error y reintentos

### 🔹 Fase 7: Pruebas y Optimización
- Pruebas unitarias: servicios, modelos, lógica de providers
- Pruebas de widgets: formularios, listas, navegación
- Pruebas de integración: flujo completo auth → catálogo → carrito
- Validar rendimiento: lazy loading, caché de imágenes, reducción de `setState` innecesario
- Revisar accesibilidad (contraste, tamaños de texto, lectores de pantalla)

### 🔹 Fase 8: Despliegue y Monitoreo
- Configurar Firebase Analytics y Crashlytics
- Generar APK/AAB y IPA con firmas de producción
- Preparar fichas para Google Play y App Store (capturas, descripciones, políticas)
- Configurar pipeline CI/CD (GitHub Actions) para builds automáticos
- Plan de versionado semántico y estrategia de actualizaciones

---

## ✅ Criterios de Aceptación (Antes de pasar a código)
- [ ] UI/UX aprobado en prototipo interactivo
- [ ] Estructura de carpetas y arquitectura definida
- [ ] Firebase Auth y Firestore configurados y probados en consola
- [ ] `pubspec.yaml` con dependencias verificadas
- [ ] Plan de Provider y flujo de datos documentado
- [ ] Reglas de seguridad Firestore validadas
- [ ] Estrategia de pruebas y despliegue alineada al equipo

---

## 📌 Notas Finales
- Este plan es **agnóstico a versiones específicas** para garantizar compatibilidad con el ecosistema actual de Flutter (2025-2026).
- No se incluye código a solicitud explícita. Una vez validado este documento, se puede proceder a generar:
  1. Estructura de archivos y `pubspec.yaml` completo
  2. Implementación de providers y servicios Firebase
  3. Pantallas UI con navegación y estado
  4. Configuración de reglas Firestore y pruebas automatizadas
- ¿Deseas ajustar algún alcance (ej. agregar pasarela de pagos, roles de usuario, notificaciones push, o modo offline robusto) antes de iniciar la fase de código?
