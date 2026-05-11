actua como un administrador de base de datos:  Proyecto cafeteria, que entidades se necesitan para su gestion
<img width="1283" height="443" alt="image" src="https://github.com/user-attachments/assets/a0f02d7a-1c3a-4d41-81b6-4e7c86e0ff07" />

## Entidades para un Sistema de Gestión de Cafetería

Aquí están las entidades principales agrupadas por dominio:

---

### 🛒 Ventas y Pedidos
- **Pedido** — cabecera del ticket (fecha, hora, total, estado)
- **DetallePedido** — líneas del pedido (producto, cantidad, precio unitario)
- **Mesa** — número, capacidad, estado (libre/ocupada/reservada)
- **Reserva** — fecha, hora, número de personas, cliente

---

### 🍽️ Menú y Productos
- **Producto** — nombre, descripción, precio, disponibilidad
- **Categoria** — desayunos, bebidas, postres, platos del día, etc.
- **Receta** — relación producto ↔ ingredientes con cantidades
- **Ingrediente** — unidad de medida, stock mínimo

---

### 📦 Inventario y Proveedores
- **Inventario** — stock actual por ingrediente, fecha de última actualización
- **Proveedor** — nombre, contacto, condiciones de pago
- **OrdenCompra** — pedido al proveedor (fecha, estado, total)
- **DetalleOrdenCompra** — ingrediente, cantidad, precio negociado

---

### 👥 Personas
- **Cliente** — datos opcionales para fidelización o reservas
- **Empleado** — nombre, rol (cajero, mesero, cocinero, admin), turno
- **Turno** — horario de entrada/salida por empleado

---

### 💳 Facturación y Pagos
- **Factura** — folio fiscal, RFC, datos del cliente, timbre
- **Pago** — método (efectivo, tarjeta, transferencia), monto, cambio
- **CorteDeCaja** — resumen de ventas por turno/día

---

### 📊 Entidades de Soporte
- **TipoDescuento / Promocion** — cupones, combos, happy hour
- **ConfiguracionSistema** — IVA, moneda, nombre del negocio, etc.
- **Auditoria / Log** — cambios críticos trazables (quién modificó qué)

---

### Relaciones clave

```
Cliente      ──< Pedido >── Mesa
Pedido       ──< DetallePedido >── Producto
Producto     ──< Receta >── Ingrediente
Ingrediente  ──  Inventario
Pedido       ──  Pago ── Factura
OrdenCompra  ──  Proveedor
Empleado     ──  Turno / CorteDeCaja
```

---

¿Quieres que profundice en alguna entidad específica, genere el **modelo entidad-relación (ERD)**, los **scripts DDL en SQL**, o defina las **relaciones con cardinalidades**?

## Las entidades con sus atributos y tipo en forma de tabla para cada una de las entidades
## Tablas
<img width="769" height="579" alt="image" src="https://github.com/user-attachments/assets/7fc52607-bd64-4809-8fec-61b65f4123ef" />
<img width="759" height="543" alt="image" src="https://github.com/user-attachments/assets/6d6b6d23-ebd8-4154-aef8-ab335281eb24" />
<img width="781" height="530" alt="image" src="https://github.com/user-attachments/assets/035fced7-8265-4c5a-8966-b60848334b90" />
<img width="798" height="325" alt="image" src="https://github.com/user-attachments/assets/80f3e21a-8bdb-4c1b-bc5b-4cc8f369f285" />
<img width="787" height="665" alt="image" src="https://github.com/user-attachments/assets/a56bbad1-69ac-4610-9509-ce5e697cee66" />

## De acuerdo a tu respuesta anterior puedes generar un script en sql para descargar con el nombre bdcafeteria para las 10 con sus relaciones
El script incluye las **18 tablas** completas (las 17 entidades más sus relaciones) con:

- `CREATE DATABASE bdcafeteria` con charset `utf8mb4`
- Llaves primarias con `UUID()`, llaves foráneas con `ON UPDATE CASCADE`
- Columnas calculadas (`subtotal` en `detalle_pedido` y `detalle_orden_compra`)
- 10 índices adicionales para consultas frecuentes
- Seed de datos de prueba: 5 categorías, 4 empleados, 5 mesas, 7 ingredientes, 6 productos y sus recetas

Compatible con **MySQL 8.x** y **MariaDB 10.6+`. Para ejecutarlo:

```bash
mysql -u root -p < bdcafeteria.sql
```

¿Quieres que agregue vistas, procedimientos almacenados o triggers (por ejemplo, uno que descuente inventario al registrar un pedido)?
