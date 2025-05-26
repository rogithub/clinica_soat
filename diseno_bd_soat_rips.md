
# Diseño de Base de Datos para Facturación SOAT – RIPS y FEV

Este esquema está basado en los **Lineamientos para la generación, validación y envío del RIPS como soporte de la Factura Electrónica de Venta (FEV) en Salud**, versión 3.2 (mayo de 2025).

---

## 🧩 Entidades Principales

| Tabla / Entidad           | Descripción                                                                 |
|---------------------------|-----------------------------------------------------------------------------|
| `Usuarios`                | Datos del paciente (afiliado)                                               |
| `Facturas`                | Factura Electrónica de Venta (FEV) en formato XML                          |
| `RIPS`                    | Registro Individual de Prestación de Servicios de Salud en formato JSON     |
| `ServiciosSalud`          | Servicios y tecnologías prestadas (consultas, procedimientos, etc.)         |
| `Pagadores`               | EPS, SOAT, ARL, medicina prepagada, etc.                                    |
| `Glosas`                  | Objeciones de pago                                                          |
| `NotasCreditoDebito`     | Notas que ajustan la factura (crédito o débito)                             |
| `ProfesionalesSalud`     | Personal que presta el servicio (RETHUS, REPS)                              |
| `CódigosCUPS`             | Catálogo de procedimientos y servicios de salud                             |
| `CUV`                     | Código Único de Validación que relaciona RIPS y FEV                         |

---

## 🗃️ Relaciones Clave

- Una `Factura` puede tener múltiples `RIPS`.
- Un `RIPS` se asocia a un `Usuario`, uno o varios `ServiciosSalud`, y posibles `NotasCreditoDebito`.
- Las `Glosas` deben vincularse al `ServicioSalud` específico.
- Cada `Factura` debe estar validada (CUV) para ser radicada.

---

## 🛠️ Estructura Sugerida de Tablas (SQL-style)

### `Usuarios`
```sql
id_usuario PK
tipo_documento
numero_documento
nombre
apellido
fecha_nacimiento
sexo
codigo_eps
tipo_afiliado
```

### `Facturas`
```sql
id_factura PK
numero_factura
fecha_emision
tipo_factura (monousuario, multiusuario)
valor_total
estado_validacion
id_cuv FK
xml_factura TEXT
```

### `RIPS`
```sql
id_rips PK
id_factura FK
id_usuario FK
json_rips TEXT
fecha_generacion
tipo_servicio
estado_validacion
```

### `ServiciosSalud`
```sql
id_servicio PK
id_rips FK
codigo_cups
descripcion_servicio
valor_servicio
fecha_servicio
```

### `Pagadores`
```sql
id_pagador PK
nombre_pagador
tipo_pagador (SOAT, EPS, ARL, etc.)
nit
```

### `Glosas`
```sql
id_glosa PK
id_servicio FK
motivo_glosa
valor_objetado
fecha_glosa
estado_respuesta
```

### `NotasCreditoDebito`
```sql
id_nota PK
id_factura FK
tipo_nota (crédito, débito)
motivo
valor
fecha_emision
estado_validacion
```

### `CUV`
```sql
id_cuv PK
codigo_cuv
fecha_validacion
id_factura FK
id_rips FK
```

---

## ✅ Consideraciones Técnicas

- El JSON del RIPS y el XML de la FEV deben almacenarse (campo `TEXT` o archivo vinculado).
- Aplica las reglas de validación definidas por la **Resolución 2275 de 2023**.
- Implementa catálogos de referencia como:
  - CUPS (procedimientos)
  - MIPRES (medicamentos e insumos)
  - BDUA (usuarios afiliados)
  - ReTHUS (profesionales de salud)
- Usa claves compuestas o consecutivos para enlazar usuario + servicio + factura.
- Soporta facturación monousuario o multiusuario con múltiples servicios.
- Toda factura con RIPS debe ser validada (CUV) para poder ser radicada.

---

## 🧪 Enlaces útiles

- [Portal Facturación Electrónica en Salud (MinSalud)](https://www.sispro.gov.co/central-financiamiento/Pages/facturacion-electronica.aspx)
- [Resolución 2275 de 2023 – RIPS y FEV](https://www.minsalud.gov.co)

---
