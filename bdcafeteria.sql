-- ============================================================
--  BASE DE DATOS: bdcafeteria
--  Descripción  : Sistema de gestión de cafetería
--  Motor        : MySQL 8.x / MariaDB 10.6+
--  Generado por : Claude (Anthropic)
-- ============================================================

CREATE DATABASE IF NOT EXISTS bdcafeteria
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bdcafeteria;

-- ------------------------------------------------------------
-- 1. CATEGORIA
-- ------------------------------------------------------------
CREATE TABLE categoria (
  id            CHAR(36)      NOT NULL DEFAULT (UUID()),
  nombre        VARCHAR(60)   NOT NULL,
  descripcion   TEXT,
  orden         INT           NOT NULL DEFAULT 0,
  activa        BOOLEAN       NOT NULL DEFAULT TRUE,
  CONSTRAINT pk_categoria PRIMARY KEY (id),
  CONSTRAINT uq_categoria_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 2. INGREDIENTE
-- ------------------------------------------------------------
CREATE TABLE ingrediente (
  id              CHAR(36)        NOT NULL DEFAULT (UUID()),
  nombre          VARCHAR(100)    NOT NULL,
  unidad_medida   VARCHAR(20)     NOT NULL COMMENT 'g / ml / pieza',
  stock_minimo    DECIMAL(10,3)   NOT NULL DEFAULT 0,
  costo_unitario  DECIMAL(10,4),
  CONSTRAINT pk_ingrediente PRIMARY KEY (id),
  CONSTRAINT uq_ingrediente_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 3. INVENTARIO
-- ------------------------------------------------------------
CREATE TABLE inventario (
  id                    CHAR(36)        NOT NULL DEFAULT (UUID()),
  ingrediente_id        CHAR(36)        NOT NULL,
  stock_actual          DECIMAL(10,3)   NOT NULL DEFAULT 0,
  ultima_actualizacion  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                          ON UPDATE CURRENT_TIMESTAMP,
  ubicacion             VARCHAR(60)     COMMENT 'almacen / refrigerador / congelador',
  CONSTRAINT pk_inventario          PRIMARY KEY (id),
  CONSTRAINT uq_inventario_ingr     UNIQUE (ingrediente_id),
  CONSTRAINT fk_inventario_ingr     FOREIGN KEY (ingrediente_id)
    REFERENCES ingrediente (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 4. PRODUCTO
-- ------------------------------------------------------------
CREATE TABLE producto (
  id               CHAR(36)        NOT NULL DEFAULT (UUID()),
  categoria_id     CHAR(36)        NOT NULL,
  nombre           VARCHAR(100)    NOT NULL,
  descripcion      TEXT,
  precio           DECIMAL(10,2)   NOT NULL,
  disponible       BOOLEAN         NOT NULL DEFAULT TRUE,
  imagen_url       VARCHAR(255),
  tiempo_prep_min  INT             COMMENT 'minutos estimados de preparación',
  CONSTRAINT pk_producto         PRIMARY KEY (id),
  CONSTRAINT fk_producto_categ   FOREIGN KEY (categoria_id)
    REFERENCES categoria (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 5. RECETA
-- ------------------------------------------------------------
CREATE TABLE receta (
  id              CHAR(36)        NOT NULL DEFAULT (UUID()),
  producto_id     CHAR(36)        NOT NULL,
  ingrediente_id  CHAR(36)        NOT NULL,
  cantidad        DECIMAL(10,3)   NOT NULL,
  unidad          VARCHAR(20)     NOT NULL COMMENT 'g / ml / unidad',
  CONSTRAINT pk_receta            PRIMARY KEY (id),
  CONSTRAINT uq_receta_prod_ingr  UNIQUE (producto_id, ingrediente_id),
  CONSTRAINT fk_receta_prod       FOREIGN KEY (producto_id)
    REFERENCES producto (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_receta_ingr       FOREIGN KEY (ingrediente_id)
    REFERENCES ingrediente (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 6. PROVEEDOR
-- ------------------------------------------------------------
CREATE TABLE proveedor (
  id                CHAR(36)        NOT NULL DEFAULT (UUID()),
  nombre            VARCHAR(100)    NOT NULL,
  contacto          VARCHAR(100),
  telefono          VARCHAR(20),
  email             VARCHAR(100),
  condiciones_pago  TEXT,
  activo            BOOLEAN         NOT NULL DEFAULT TRUE,
  CONSTRAINT pk_proveedor PRIMARY KEY (id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 7. ORDEN_COMPRA
-- ------------------------------------------------------------
CREATE TABLE orden_compra (
  id              CHAR(36)        NOT NULL DEFAULT (UUID()),
  proveedor_id    CHAR(36)        NOT NULL,
  fecha           DATE            NOT NULL,
  fecha_entrega   DATE,
  estado          VARCHAR(20)     NOT NULL DEFAULT 'borrador'
                    COMMENT 'borrador / enviada / recibida / cancelada',
  total           DECIMAL(10,2)   NOT NULL DEFAULT 0,
  CONSTRAINT pk_orden_compra       PRIMARY KEY (id),
  CONSTRAINT fk_orden_compra_prov  FOREIGN KEY (proveedor_id)
    REFERENCES proveedor (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 8. DETALLE_ORDEN_COMPRA
-- ------------------------------------------------------------
CREATE TABLE detalle_orden_compra (
  id              CHAR(36)        NOT NULL DEFAULT (UUID()),
  orden_id        CHAR(36)        NOT NULL,
  ingrediente_id  CHAR(36)        NOT NULL,
  cantidad        DECIMAL(10,3)   NOT NULL,
  precio_unitario DECIMAL(10,4)   NOT NULL,
  subtotal        DECIMAL(10,2)   GENERATED ALWAYS AS
                    (ROUND(cantidad * precio_unitario, 2)) STORED,
  CONSTRAINT pk_detalle_orden_compra    PRIMARY KEY (id),
  CONSTRAINT fk_doc_orden               FOREIGN KEY (orden_id)
    REFERENCES orden_compra (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_doc_ingr                FOREIGN KEY (ingrediente_id)
    REFERENCES ingrediente (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 9. CLIENTE
-- ------------------------------------------------------------
CREATE TABLE cliente (
  id               CHAR(36)        NOT NULL DEFAULT (UUID()),
  nombre           VARCHAR(100)    NOT NULL,
  telefono         VARCHAR(20),
  email            VARCHAR(100),
  fecha_registro   DATE            NOT NULL DEFAULT (CURDATE()),
  puntos_fidelidad INT             NOT NULL DEFAULT 0,
  notas            TEXT            COMMENT 'alergias, preferencias',
  CONSTRAINT pk_cliente       PRIMARY KEY (id),
  CONSTRAINT uq_cliente_email UNIQUE (email)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 10. EMPLEADO
-- ------------------------------------------------------------
CREATE TABLE empleado (
  id            CHAR(36)        NOT NULL DEFAULT (UUID()),
  nombre        VARCHAR(100)    NOT NULL,
  rol           VARCHAR(30)     NOT NULL COMMENT 'cajero / mesero / cocinero / admin',
  telefono      VARCHAR(20),
  email         VARCHAR(100),
  fecha_ingreso DATE            NOT NULL DEFAULT (CURDATE()),
  activo        BOOLEAN         NOT NULL DEFAULT TRUE,
  pin_acceso    VARCHAR(60)     COMMENT 'hash bcrypt, nullable',
  CONSTRAINT pk_empleado       PRIMARY KEY (id),
  CONSTRAINT uq_empleado_email UNIQUE (email)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 11. MESA
-- ------------------------------------------------------------
CREATE TABLE mesa (
  id         CHAR(36)        NOT NULL DEFAULT (UUID()),
  numero     INT             NOT NULL,
  capacidad  INT             NOT NULL,
  estado     VARCHAR(20)     NOT NULL DEFAULT 'libre'
               COMMENT 'libre / ocupada / reservada',
  ubicacion  VARCHAR(50)     COMMENT 'interior / terraza / barra',
  CONSTRAINT pk_mesa        PRIMARY KEY (id),
  CONSTRAINT uq_mesa_numero UNIQUE (numero)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 12. RESERVA
-- ------------------------------------------------------------
CREATE TABLE reserva (
  id           CHAR(36)        NOT NULL DEFAULT (UUID()),
  cliente_id   CHAR(36)        NOT NULL,
  mesa_id      CHAR(36)        NOT NULL,
  fecha_hora   DATETIME        NOT NULL,
  num_personas INT             NOT NULL,
  estado       VARCHAR(20)     NOT NULL DEFAULT 'confirmada'
                 COMMENT 'confirmada / cancelada / completada',
  notas        TEXT,
  CONSTRAINT pk_reserva          PRIMARY KEY (id),
  CONSTRAINT fk_reserva_cliente  FOREIGN KEY (cliente_id)
    REFERENCES cliente (id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_reserva_mesa     FOREIGN KEY (mesa_id)
    REFERENCES mesa (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 13. PEDIDO
-- ------------------------------------------------------------
CREATE TABLE pedido (
  id            CHAR(36)        NOT NULL DEFAULT (UUID()),
  cliente_id    CHAR(36),
  mesa_id       CHAR(36),
  empleado_id   CHAR(36)        NOT NULL,
  fecha_hora    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado        VARCHAR(20)     NOT NULL DEFAULT 'pendiente'
                  COMMENT 'pendiente / en_preparacion / listo / entregado / cancelado',
  total         DECIMAL(10,2)   NOT NULL DEFAULT 0,
  observaciones TEXT,
  CONSTRAINT pk_pedido            PRIMARY KEY (id),
  CONSTRAINT fk_pedido_cliente    FOREIGN KEY (cliente_id)
    REFERENCES cliente (id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_pedido_mesa       FOREIGN KEY (mesa_id)
    REFERENCES mesa (id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_pedido_empleado   FOREIGN KEY (empleado_id)
    REFERENCES empleado (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 14. DETALLE_PEDIDO
-- ------------------------------------------------------------
CREATE TABLE detalle_pedido (
  id              CHAR(36)        NOT NULL DEFAULT (UUID()),
  pedido_id       CHAR(36)        NOT NULL,
  producto_id     CHAR(36)        NOT NULL,
  cantidad        INT             NOT NULL,
  precio_unitario DECIMAL(10,2)   NOT NULL,
  subtotal        DECIMAL(10,2)   GENERATED ALWAYS AS
                    (ROUND(cantidad * precio_unitario, 2)) STORED,
  notas           TEXT,
  CONSTRAINT pk_detalle_pedido      PRIMARY KEY (id),
  CONSTRAINT fk_dp_pedido           FOREIGN KEY (pedido_id)
    REFERENCES pedido (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_dp_producto         FOREIGN KEY (producto_id)
    REFERENCES producto (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 15. PAGO
-- ------------------------------------------------------------
CREATE TABLE pago (
  id          CHAR(36)        NOT NULL DEFAULT (UUID()),
  pedido_id   CHAR(36)        NOT NULL,
  metodo      VARCHAR(20)     NOT NULL COMMENT 'efectivo / tarjeta / transferencia',
  monto       DECIMAL(10,2)   NOT NULL,
  cambio      DECIMAL(10,2)   NOT NULL DEFAULT 0,
  fecha_hora  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  referencia  VARCHAR(100)    COMMENT 'número de transacción / voucher',
  CONSTRAINT pk_pago         PRIMARY KEY (id),
  CONSTRAINT fk_pago_pedido  FOREIGN KEY (pedido_id)
    REFERENCES pedido (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 16. FACTURA
-- ------------------------------------------------------------
CREATE TABLE factura (
  id             CHAR(36)        NOT NULL DEFAULT (UUID()),
  pedido_id      CHAR(36)        NOT NULL,
  folio          VARCHAR(40)     NOT NULL,
  rfc_cliente    VARCHAR(15)     NOT NULL,
  razon_social   VARCHAR(150)    NOT NULL,
  subtotal       DECIMAL(10,2)   NOT NULL,
  iva            DECIMAL(10,2)   NOT NULL COMMENT '16% sobre subtotal',
  total          DECIMAL(10,2)   NOT NULL,
  fecha_emision  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  xml_url        VARCHAR(255),
  CONSTRAINT pk_factura        PRIMARY KEY (id),
  CONSTRAINT uq_factura_folio  UNIQUE (folio),
  CONSTRAINT fk_factura_pedido FOREIGN KEY (pedido_id)
    REFERENCES pedido (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 17. CORTE_CAJA
-- ------------------------------------------------------------
CREATE TABLE corte_caja (
  id              CHAR(36)        NOT NULL DEFAULT (UUID()),
  empleado_id     CHAR(36)        NOT NULL,
  fecha_hora      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  total_ventas    DECIMAL(10,2)   NOT NULL DEFAULT 0,
  efectivo        DECIMAL(10,2)   NOT NULL DEFAULT 0,
  tarjeta         DECIMAL(10,2)   NOT NULL DEFAULT 0,
  transferencia   DECIMAL(10,2)   NOT NULL DEFAULT 0,
  num_pedidos     INT             NOT NULL DEFAULT 0,
  observaciones   TEXT,
  CONSTRAINT pk_corte_caja          PRIMARY KEY (id),
  CONSTRAINT fk_corte_caja_empleado FOREIGN KEY (empleado_id)
    REFERENCES empleado (id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 18. PROMOCION
-- ------------------------------------------------------------
CREATE TABLE promocion (
  id           CHAR(36)        NOT NULL DEFAULT (UUID()),
  nombre       VARCHAR(100)    NOT NULL,
  tipo         VARCHAR(20)     NOT NULL COMMENT 'porcentaje / monto / combo',
  valor        DECIMAL(10,2)   NOT NULL,
  fecha_inicio DATE,
  fecha_fin    DATE,
  activa       BOOLEAN         NOT NULL DEFAULT TRUE,
  codigo       VARCHAR(30)     COMMENT 'código de cupón, nullable',
  CONSTRAINT pk_promocion PRIMARY KEY (id),
  CONSTRAINT uq_promocion_codigo UNIQUE (codigo)
) ENGINE=InnoDB;

-- ============================================================
-- ÍNDICES ADICIONALES (rendimiento en consultas frecuentes)
-- ============================================================
CREATE INDEX idx_pedido_fecha       ON pedido (fecha_hora);
CREATE INDEX idx_pedido_estado      ON pedido (estado);
CREATE INDEX idx_pedido_mesa        ON pedido (mesa_id);
CREATE INDEX idx_detalle_pedido     ON detalle_pedido (pedido_id);
CREATE INDEX idx_detalle_producto   ON detalle_pedido (producto_id);
CREATE INDEX idx_inventario_stock   ON inventario (stock_actual);
CREATE INDEX idx_producto_categ     ON producto (categoria_id);
CREATE INDEX idx_reserva_fecha      ON reserva (fecha_hora);
CREATE INDEX idx_pago_pedido        ON pago (pedido_id);
CREATE INDEX idx_orden_compra_prov  ON orden_compra (proveedor_id);

-- ============================================================
-- DATOS DE PRUEBA (seed mínimo)
-- ============================================================

-- Categorías
INSERT INTO categoria (id, nombre, orden) VALUES
  ('cat-0001-0000-0000-000000000001', 'Bebidas calientes',  1),
  ('cat-0001-0000-0000-000000000002', 'Bebidas frías',      2),
  ('cat-0001-0000-0000-000000000003', 'Desayunos',          3),
  ('cat-0001-0000-0000-000000000004', 'Postres',            4),
  ('cat-0001-0000-0000-000000000005', 'Platos del día',     5);

-- Empleados
INSERT INTO empleado (id, nombre, rol) VALUES
  ('emp-0001-0000-0000-000000000001', 'Ana García',    'admin'),
  ('emp-0001-0000-0000-000000000002', 'Luis Pérez',    'cajero'),
  ('emp-0001-0000-0000-000000000003', 'María López',   'mesero'),
  ('emp-0001-0000-0000-000000000004', 'Carlos Ruiz',   'cocinero');

-- Mesas
INSERT INTO mesa (id, numero, capacidad, ubicacion) VALUES
  ('mesa-001-0000-0000-000000000001', 1, 2, 'interior'),
  ('mesa-001-0000-0000-000000000002', 2, 4, 'interior'),
  ('mesa-001-0000-0000-000000000003', 3, 4, 'terraza'),
  ('mesa-001-0000-0000-000000000004', 4, 6, 'terraza'),
  ('mesa-001-0000-0000-000000000005', 5, 2, 'barra');

-- Ingredientes
INSERT INTO ingrediente (id, nombre, unidad_medida, stock_minimo, costo_unitario) VALUES
  ('ingr-001-0000-0000-000000000001', 'Café molido',     'g',     500,  0.0350),
  ('ingr-001-0000-0000-000000000002', 'Leche entera',    'ml',   2000,  0.0018),
  ('ingr-001-0000-0000-000000000003', 'Azúcar blanca',   'g',     300,  0.0012),
  ('ingr-001-0000-0000-000000000004', 'Harina de trigo', 'g',    1000,  0.0009),
  ('ingr-001-0000-0000-000000000005', 'Huevo fresco',    'pieza',   12, 2.5000),
  ('ingr-001-0000-0000-000000000006', 'Mantequilla',     'g',     200,  0.0280),
  ('ingr-001-0000-0000-000000000007', 'Cacao en polvo',  'g',     200,  0.0420);

-- Inventario inicial
INSERT INTO inventario (ingrediente_id, stock_actual, ubicacion) VALUES
  ('ingr-001-0000-0000-000000000001', 2000,  'almacen'),
  ('ingr-001-0000-0000-000000000002', 10000, 'refrigerador'),
  ('ingr-001-0000-0000-000000000003', 3000,  'almacen'),
  ('ingr-001-0000-0000-000000000004', 5000,  'almacen'),
  ('ingr-001-0000-0000-000000000005', 60,    'refrigerador'),
  ('ingr-001-0000-0000-000000000006', 1000,  'refrigerador'),
  ('ingr-001-0000-0000-000000000007', 800,   'almacen');

-- Productos
INSERT INTO producto (id, categoria_id, nombre, precio, tiempo_prep_min) VALUES
  ('prod-001-0000-0000-000000000001', 'cat-0001-0000-0000-000000000001', 'Café americano',    35.00, 3),
  ('prod-001-0000-0000-000000000002', 'cat-0001-0000-0000-000000000001', 'Capuchino',         45.00, 5),
  ('prod-001-0000-0000-000000000003', 'cat-0001-0000-0000-000000000001', 'Chocolate caliente',42.00, 5),
  ('prod-001-0000-0000-000000000004', 'cat-0001-0000-0000-000000000002', 'Café frío',         48.00, 5),
  ('prod-001-0000-0000-000000000005', 'cat-0001-0000-0000-000000000003', 'Desayuno completo', 95.00,15),
  ('prod-001-0000-0000-000000000006', 'cat-0001-0000-0000-000000000004', 'Brownie de chocolate',38.00,20);

-- Recetas
INSERT INTO receta (producto_id, ingrediente_id, cantidad, unidad) VALUES
  ('prod-001-0000-0000-000000000001','ingr-001-0000-0000-000000000001', 18,  'g'),
  ('prod-001-0000-0000-000000000001','ingr-001-0000-0000-000000000003',  5,  'g'),
  ('prod-001-0000-0000-000000000002','ingr-001-0000-0000-000000000001', 18,  'g'),
  ('prod-001-0000-0000-000000000002','ingr-001-0000-0000-000000000002',150,  'ml'),
  ('prod-001-0000-0000-000000000002','ingr-001-0000-0000-000000000003',  8,  'g'),
  ('prod-001-0000-0000-000000000003','ingr-001-0000-0000-000000000002',200,  'ml'),
  ('prod-001-0000-0000-000000000003','ingr-001-0000-0000-000000000007', 20,  'g'),
  ('prod-001-0000-0000-000000000006','ingr-001-0000-0000-000000000004', 80,  'g'),
  ('prod-001-0000-0000-000000000006','ingr-001-0000-0000-000000000005',  1,  'pieza'),
  ('prod-001-0000-0000-000000000006','ingr-001-0000-0000-000000000006', 50,  'g'),
  ('prod-001-0000-0000-000000000006','ingr-001-0000-0000-000000000007', 30,  'g');

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
