Esta es la versión definitiva y ultra-detallada del **Manual Maestro de Ingeniería para CoffeeManage Pro**. Este documento ha sido expandido para cubrir cada regla lógica, flujo de datos y especificación técnica necesaria para que el equipo de **Antigravity** ejecute el proyecto con precisión absoluta en Android, iOS, Web y Windows.

---

# ☕ MANUAL MAESTRO DE IMPLEMENTACIÓN: COFFEEMANAGE PRO

**Líder de Proyecto:** Antigravity

**Ecosistema de Software:** Flutter Multiplataforma (Mobile, Desktop, Web)

**Identidad Visual:** Dark Coffee & Onyx Black Premium Concept

---

## 🎨 1. FILOSOFÍA VISUAL Y DISEÑO DE INTERFAZ (UI/UX)

El diseño de **Antigravity** para esta app no es solo estético, es funcional. Se basa en una jerarquía visual de alto contraste para entornos con iluminación variable (como una barra de café o una cocina oscura).

### 🎨 Sistema de Colores (Design System)

* **Onyx Base (`#121212`):** El lienzo principal. Proporciona un entorno de trabajo elegante y reduce el consumo energético en dispositivos móviles.
* **Coffee Elevation (`#1E1E1E`):** Color para tarjetas, modales y superficies elevadas. Crea profundidad sin romper la estética oscura.
* **Espresso Primary (`#3E2723`):** Utilizado exclusivamente para llamadas a la acción (CTA) de alto nivel: "Confirmar Pedido", "Pagar", "Iniciar Turno".
* **Cinnamon Accent (`#795548`):** Color para navegación secundaria, iconos de estado y botones de edición.
* **Latte Cream (`#D7CCC8`):** Tipografía y elementos de lectura. Seleccionado por su calidez y su contraste perfecto contra el fondo oscuro.

### 📱 Adaptabilidad de Interfaz por Plataforma

* **Mobile (Android/iOS):** Navegación optimizada para pulgares. Botones con un área táctil mínima de 48x48 píxeles.
* **Tablet (iPad/Android):** Interfaz de "Mapa de Mesas" a pantalla completa con soporte para gestos multitoque.
* **Desktop/Web (Windows/Chrome):** Dashboard administrativo con paneles colapsables y tablas de datos densas para análisis de inventario.

---

## 🏗️ 2. ARQUITECTURA DE SOFTWARE (CLEAN ARCHITECTURE)

Para garantizar que el sistema sea escalable y fácil de actualizar, **Antigravity** implementará una estructura de carpetas basada en la separación total de responsabilidades.

### 📂 Organización Exhaustiva de Directorios (`lib/`)

* **`core/`**: El núcleo del sistema.
* `constants/`: Definición de colores cafés, negros y strings globales.
* `theme/`: Configuración del Dark Theme (Material 3).
* `utils/`: Algoritmos de redondeo financiero y validadores de stock.


* **`domain/`**: El cerebro del negocio (Independiente de Firebase).
* `entities/`: Modelos puros: `UserEntity`, `IngredientEntity`, `OrderEntity`.
* `usecases/`: Casos de uso: `ProcessSale()`, `RefillStock()`, `ValidateRecipe()`.


* **`data/`**: La infraestructura técnica.
* `models/`: Mapeo de datos (fromFirestore/toJson).
* `repositories/`: Implementación de la comunicación con Firebase.
* `sources/`: Conexión directa a los servicios (Auth, Firestore, Storage).


* **`presentation/`**: La cara del sistema.
* `providers/`: Gestión de estado reactivo mediante **Provider**.
* `screens/`: Vistas de Login, POS, Cocina (KDS), Inventario y Reportes.
* `widgets/`: Componentes modulares como `ProductCard` y `TableStatus`.



---

## 🗄️ 3. ARQUITECTURA DE DATOS (ESQUEMA DE TABLAS/COLECCIONES)

El sistema utiliza una base de datos NoSQL (Firestore) organizada de forma relacional para garantizar que el inventario se descuente con precisión quirúrgica.

### A. Tabla: `usuarios` (Gestión de Personal)

| Campo | Tipo | Descripción |
| --- | --- | --- |
| `uid` | String | Identificador único de Firebase Auth. |
| `nombre` | String | Nombre para mostrar en el ticket. |
| `rol` | Enum | `admin`, `mesero`, `cocina`. |
| `status` | Boolean | Control de acceso (Activo/Inactivo). |

### B. Tabla: `ingredientes` (Inventario Crudo)

| Campo | Tipo | Descripción |
| --- | --- | --- |
| `id_ingrediente` | String | ID del insumo (Ej: "cafe_arabica"). |
| `nombre` | String | Nombre del insumo. |
| `stock_actual` | Double | Cantidad real (gramos o mililitros). |
| `alerta_minima` | Double | Nivel crítico para reabastecimiento. |

### C. Tabla: `productos` (Menú y Recetas)

| Campo | Tipo | Descripción |
| --- | --- | --- |
| `id_producto` | String | ID del producto (Ej: "latte_12oz"). |
| `nombre` | String | Nombre comercial. |
| `precio` | Double | Precio de venta al público. |
| **`receta`** | Map | Diccionario de insumos: `{ "leche": 250, "cafe": 18 }`. |

### D. Tabla: `pedidos` (Transacciones y Comandas)

| Campo | Tipo | Descripción |
| --- | --- | --- |
| `id_pedido` | String | Identificador de la venta. |
| `items` | Array | Lista de productos pedidos. |
| `estado` | Enum | `pendiente`, `preparando`, `listo`, `pagado`. |
| `total` | Double | Monto total de la transacción. |
| `timestamp` | Date | Fecha y hora exacta de creación. |

---

## 🚀 4. FLUJOS OPERATIVOS Y FASES DE IMPLEMENTACIÓN

### 🔹 Fase 1: Seguridad y Acceso (Auth)

* **Login Personalizado:** Pantalla de acceso con estética **Antigravity** (Negros y Cafés).
* **Control de Roles:** El sistema redirige automáticamente:
* Admin ➔ Dashboard Financiero.
* Mesero ➔ Mapa de Mesas.
* Cocina ➔ Monitor de Pedidos.



### 🔹 Fase 2: Inteligencia de Inventario

* **Algoritmo de Descuento Atómico:** Cada vez que se confirma un pedido, el sistema consulta la tabla de `productos`, extrae la `receta` y resta proporcionalmente de la tabla `ingredientes`.
* **Bloqueo Preventivo:** Si un ingrediente llega a su `stock_actual` mínimo, el sistema deshabilita instantáneamente todos los productos que dependen de él.

### 🔹 Fase 3: Punto de Venta y Gestión de Salón (POS)

* **Mapa de Mesas Interactivo:** Visualización en tiempo real. Las mesas cambian de estado (Negro: Libre, Café: Ocupada) sincrónicamente en todos los dispositivos.
* **Comanda Digital:** Selección rápida de productos con modificadores (Ej: "Con leche de almendras").

### 🔹 Fase 4: Monitor de Cocina (KDS)

* **Semáforo de Prioridad:**
* **Verde (< 5 min):** Pedido a tiempo.
* **Café Claro (5-10 min):** Alerta de servicio.
* **Rojo (> 10 min):** Retraso crítico, notificación automática al Admin.


* **Feedback en Tiempo Real:** Al marcar como "Listo", el mesero recibe una notificación visual en su tablet.

### 🔹 Fase 5: Auditoría, Cierre y Facturación

* **Corte de Caja:** Conciliación entre ventas registradas y stock consumido.
* **Logs de Auditoría:** Registro de cada acción (cancelaciones, cortesías, descuentos) vinculada al UID del empleado responsable.
* **Generación de Tickets:** Exportación de facturas en PDF con branding de Antigravity para impresoras térmicas.

---

## 🛠️ 5. ESPECIFICACIONES TÉCNICAS Y RESILIENCIA

* **Soporte Offline Robustos:** Implementación de persistencia local. Si el local pierde internet, CoffeeManage Pro sigue operando y sincroniza los cambios con Firebase en cuanto se recupera la señal.
* **Sincronización Multidispositivo:** Uso de `Streams` para asegurar que un cambio en la caja se vea reflejado en la cocina en menos de 1 segundo.
* **Compatibilidad de Hardware:** Soporte para periféricos USB (Windows) y Bluetooth (Android/iOS) para impresión de tickets.

---
Tienes toda la razón. Un **Manual Maestro de Ingeniería** sin su archivo de configuración de dependencias es como una receta de café sin granos. Para que el equipo de **Antigravity** pueda compilar este proyecto en Android, iOS, Windows y Web con todas las funciones mencionadas (Firebase, Provider, Impresión, Offline), este es el bloque técnico que faltaba.

Aquí tienes el `pubspec.yaml` optimizado y categorizado:

---

## 🛠️ 6. DEPENDENCIAS Y STACK TECNOLÓGICO (`pubspec.yaml`)

Para asegurar la resiliencia y el rendimiento de **CoffeeManage Pro**, utilizaremos las versiones más estables y compatibles con Flutter 3.x.

### 📦 Gestión de Estado y Arquitectura

* **`provider`**: El estándar del proyecto para la gestión de estado reactivo.
* **`get_it`**: Localizador de servicios para implementar la Inyección de Dependencias de Clean Architecture.
* **`equatable`**: Para simplificar la comparación de objetos en las `Entities` del dominio.

### 🔥 Backend y Persistencia (Firebase)

* **`firebase_core`**: Núcleo de conexión.
* **`firebase_auth`**: Manejo de sesiones de empleados.
* **`cloud_firestore`**: Base de datos NoSQL con soporte nativo para persistencia offline y streams.
* **`connectivity_plus`**: Para detectar el estado de la red y gestionar el feedback visual de "Modo Offline".

### 🖥️ Soporte Multiplataforma y Hardware (Windows/iOS/Android)

* **`blue_thermal_printer`**: Para la conexión con impresoras térmicas vía Bluetooth (especialmente útil en tablets y móviles).
* **`esc_pos_utils`**: Generación de comandos de impresión estándar para tickets de café.
* **`win32`**: (Opcional/Específico) Para integraciones profundas con el sistema de archivos o periféricos en Windows.
* **`printing`**: Manejo de generación de PDFs (Facturación) y diálogo de impresión nativo.

### 🎨 UI y Visuales (Antigravity Design)

* **`google_fonts`**: Para implementar la tipografía premium (Ej: *Montserrat* o *Poppins*) que contraste con el fondo Onyx.
* **`flutter_spinkit`**: Animaciones de carga elegantes en color Cinnamon Accent.
* **`font_awesome_flutter`**: Iconografía detallada para insumos y tipos de café.

---

## 📋 Configuración del Archivo `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # --- GESTIÓN DE ESTADO & ARQUITECTURA ---
  provider: ^6.1.1
  get_it: ^7.7.0
  equatable: ^2.0.5

  # --- BACKEND (FIREBASE) ---
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0

  # --- HARDWARE & IMPRESIÓN ---
  # Ideal para Windows y Mobile
  printing: ^5.12.0
  pdf: ^3.10.7
  blue_thermal_printer: ^0.1.2  # Android/iOS
  flutter_pos_printer_platform: ^1.1.2 # Soporte USB para Windows

  # --- UI & UX (ANTIGRAVITY STYLE) ---
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10
  font_awesome_flutter: ^10.7.0
  intl: ^0.19.0 # Manejo de fechas y moneda local

  # --- UTILIDADES ---
  connectivity_plus: ^6.0.3
  logger: ^2.3.0

```

---

## ⚠️ Notas de Implementación para el Equipo

1. **Compatibilidad Windows**: Al ejecutar en Windows, asegúrate de habilitar las capacidades de red y comunicación serial en el manifiesto de la aplicación.
2. **Permisos iOS**: Es obligatorio añadir los permisos de Bluetooth en el `Info.plist` para que la App pueda buscar impresoras térmicas en la barra de café.
3. **Manejo de Versiones**: Se recomienda usar `^` para recibir actualizaciones de parches, pero siempre fijar versiones mayores para evitar "breaking changes" en el algoritmo de inventario.

¿Necesitas que profundice en la configuración específica del **Info.plist** para iOS o los **Proyectos de Windows**?

## ✅ CRITERIOS DE ÉXITO (DEFINITION OF DONE)

1. **Estética:** La UI es 100% fiel a los colores cafés y negros de Antigravity.
2. **Precisión:** El stock físico coincide al 100% con los reportes del sistema.
3. **Velocidad:** Tiempo de respuesta entre dispositivos menor a 1.5 segundos.
4. **Estabilidad:** Cero pérdida de datos en escenarios de desconexión.


## PROMPT 

---

# ☕ Prompt de Ingeniería: CoffeeManage Pro (The Antigravity Ultimate Order)

**Rol:** Actúa como Arquitecto de Software Senior y Lead Developer de **Antigravity**. Tu misión es codificar el núcleo de **CoffeeManage Pro**, un sistema multiplataforma de alto rendimiento para gestión de café de especialidad.

### 1. Stack Tecnológico y Dependencias (`pubspec.yaml`)

El proyecto debe utilizar obligatoriamente las siguientes librerías para garantizar la estabilidad en Android, iOS, Web y Windows:

* **Estado:** `provider`, `get_it`, `equatable`.
* **Backend:** `firebase_core`, `cloud_firestore`, `firebase_auth`.
* **Hardware/Desktop:** `flutter_pos_printer_platform` (USB/Windows), `blue_thermal_printer` (Bluetooth/Mobile), `printing` & `pdf` (Facturación).
* **UI/UX:** `google_fonts`, `font_awesome_flutter`, `connectivity_plus`.

### 2. Gestión de Estado (Provider Pattern)

Implementa la capa de presentación utilizando **Provider**:

* **InventoryProvider:** Manejo de `ingredientes` con actualizaciones en tiempo real y disparadores para `alerta_minima`.
* **OrderProvider:** Gestión de carrito, cálculos financieros y lógica de envío.
* **TableProvider:** `StreamProvider` para el mapeo de mesas sincrónico.

### 3. Estructura de Datos (Firestore NoSQL)

Genera modelos en Dart (`fromFirestore`/`toJson`) para:

* **`usuarios`:** `{ uid, nombre, rol: admin|mesero|cocina, status: Bool }`
* **`ingredientes`:** `{ id, nombre, stock_actual: Double, alerta_minima: Double }`
* **`productos`:** `{ id, nombre, precio: Double, receta: Map<id_ingrediente, cantidad> }`
* **`pedidos`:** `{ id, items: List, estado: pendiente|preparando|listo|pagado, total: Double, timestamp: Timestamp }`

### 4. Adaptabilidad Windows & iOS

* **Windows:** Interfaz optimizada con `NavigationRail` lateral y lógica de impresión térmica vía USB/Serial.
* **iOS:** Uso de `SafeArea`, gestos táctiles de alta respuesta y notificaciones locales para cambios de estado de pedidos.

### 5. Lógica de Negocio: Descuento Atómico

Desarrolla un `Service` con **Firebase Transactions** que:

1. Valide la existencia de stock para cada ingrediente de la receta antes de confirmar.
2. Ejecute el descuento de forma atómica.
3. Lance una excepción controlada si el stock es insuficiente, la cual debe ser capturada por el `OrderProvider` para mostrar un error en la UI.

### 6. Identidad Visual (Antigravity Dark Mode)

Configura el `ThemeData` con Material 3:

* **Onyx Base:** #121212 | **Coffee Elevation:** #1E1E1E.
* **Espresso Primary:** #3E2723 | **Cinnamon Accent:** #795548.
* **Latte Cream (Texto):** #D7CCC8.

**Entregable:** Genera la estructura de carpetas (Clean Architecture), el archivo `pubspec.yaml` completo, los modelos de datos y la implementación del `InventoryProvider`.

---

### 💡 Nota para Antigravity:

Con este prompt, la IA te entregará un código listo para ser organizado en carpetas. Es la base técnica más sólida posible para asegurar que el inventario nunca falle y la estética se mantenga "Premium".

¿Deseas que ejecute este prompt ahora mismo para generarte el código base o prefieres ajustar alguna dependencia más?
