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

## ✅ CRITERIOS DE ÉXITO (DEFINITION OF DONE)

1. **Estética:** La UI es 100% fiel a los colores cafés y negros de Antigravity.
2. **Precisión:** El stock físico coincide al 100% con los reportes del sistema.
3. **Velocidad:** Tiempo de respuesta entre dispositivos menor a 1.5 segundos.
4. **Estabilidad:** Cero pérdida de datos en escenarios de desconexión.


## PROMPT 
Este es el **Prompt Maestro** diseñado para ser entregado a un modelo de IA avanzado (como Claude 3.5 Sonnet, GPT-4o o una instancia técnica de Gemini) para que actúe como el Arquitecto de Software Senior y Lead Developer de Antigravity.

El objetivo de este prompt es que la IA genere el código base, la estructura de archivos o la lógica de los algoritmos descritos en tu manual.

---

# ☕ Prompt de Ingeniería: Sistema CoffeeManage Pro

**Rol:** Actúa como un Arquitecto de Software Senior y Desarrollador Full-Stack experto en Flutter y Firebase, trabajando bajo los estándares de diseño y ejecución de la firma "Antigravity".

**Contexto del Proyecto:**
Debes iniciar el desarrollo de **CoffeeManage Pro**, una solución multiplataforma (Android, iOS, Web, Windows) para la gestión de cafeterías de especialidad. El sistema debe regirse por una estética **Dark Coffee & Onyx Black Premium** y una arquitectura de software impecable.

**Tarea Inmediata:**
Genera la estructura base del proyecto y el núcleo de la lógica de inventario siguiendo estas especificaciones:

### 1. Arquitectura de Archivos (Clean Architecture)

Implementa la estructura de directorios en `lib/` siguiendo el patrón de capas:

* `core/`: (constants, theme, utils).
* `domain/`: (entities, usecases, repositories interfaces).
* `data/`: (models, repositories implementations, datasources).
* `presentation/`: (providers/bloc, screens, widgets).

### 2. Diseño de Sistema (UI/UX - Antigravity Style)

Crea una clase `AppTheme` en Flutter que defina un `ThemeData` de Material 3 con:

* **Colores:** Onyx Base (#121212), Coffee Elevation (#1E1E1E), Espresso Primary (#3E2723), Cinnamon Accent (#795548), Latte Cream (#D7CCC8).
* **Componentes:** Tarjetas con bordes redondeados (16px), tipografía clara y contrastada, y botones táctiles optimizados (48x48 min).

### 3. Lógica de Negocio Crítica: "Algoritmo de Descuento Atómico"

Escribe una función en Dart/Flutter (Usecase) que realice lo siguiente:

* **Entrada:** Un `OrderEntity` que contiene una lista de productos.
* **Proceso:** Por cada producto, debe consultar su receta (`Map<String, double>`), acceder a la colección de `ingredientes` en Firestore y restar el stock correspondiente.
* **Validación de Seguridad:** Debe incluir una verificación de "Bloqueo Preventivo". Si el `stock_actual` de cualquier ingrediente es menor al requerimiento de la receta, la transacción debe cancelarse y arrojar una excepción de "Stock Insuficiente".

### 4. Modelo de Datos (NoSQL Relacional)

Genera las clases de modelo (`models/`) con métodos `fromFirestore` y `toJson` para:

* `IngredientModel`: (id, nombre, stockActual, alertaMinima).
* `ProductModel`: (id, nombre, precio, receta).
* `OrderModel`: (id, items, estado [Enum: pendiente, preparando, listo, pagado], total, timestamp).

### 5. Requerimiento Técnico de Sincronización

Configura un ejemplo de `StreamProvider` para el "Mapa de Mesas", asegurando que los cambios de estado (Libre/Ocupada) se reflejen en tiempo real en todos los dispositivos conectados mediante `snapshots()` de Firebase.

**Output Esperado:**

1. Código Dart estructurado y limpio.
2. Comentarios técnicos explicando la integración entre Firebase y la UI.
3. Un breve resumen de cómo se garantiza la persistencia offline en esta implementación.

---
