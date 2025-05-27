# Plan de desarrollo - MVP Clínica SOAT

Este documento define el alcance del MVP (Producto Mínimo Viable) del sistema clínico basado en el Manual Tarifario SOAT. El objetivo es crear una herramienta funcional que pueda ser utilizada en una clínica real como prueba piloto.

---

## 🎯 Objetivo del MVP

Construir una aplicación que permita:
- Consultar y gestionar el manual SOAT (procedimientos, categorías, tarifas).
- Registrar atenciones médicas y los procedimientos realizados.
- Calcular automáticamente los valores a cobrar, ajustados al SMMLV.
- Generar un resumen de factura o liquidación.
- Tener una interfaz web simple que permita operar estas funciones.

---

## 🧱 Módulos del MVP

### 1. **Catálogo SOAT**
- Importar el manual tarifario SOAT (desde XLS o CSV).
- Mostrar procedimientos, categorías, grupos, y tarifas base.
- Filtrado y búsqueda por código o nombre.

### 2. **Ajuste por SMMLV**
- Definir el valor del SMMLV (ajustable anualmente).
- Calcular automáticamente las tarifas actualizadas según el manual.
- Aplicar reglas por grupo, factor multiplicador, etc.

### 3. **Registro de atención**
- Seleccionar paciente (nombre, documento).
- Asociar procedimientos realizados.
- Registrar fecha, especialidad, y profesional (si aplica).

### 4. **Facturación / Liquidación**
- Calcular totales por grupo y subtotal.
- Generar un resumen imprimible o exportable.
- Mostrar desglose por procedimiento y ajuste aplicado.

### 5. **Interfaz de usuario**
- Web app sencilla (SPA) con KnockoutJS.
- CRUD básico para las entidades anteriores.
- Visualizar los totales y simulación de facturación.

---

## 🔧 Tecnologías

- **Frontend**: JavaScript, KnockoutJS, TypeScript
- **Backend**: C# .NET
- **Base de datos**: PostgreSQL
- **Contenedores**: Linux + Podman

---

## 📌 Propuesta de Fases

| Fase | Módulo                     | Estado |
|------|----------------------------|--------|
| 1    | Cargar manual SOAT         | 🔲 Por hacer |
| 2    | Base de datos y modelos    | 🔲 Por hacer |
| 3    | Backend API                | 🔲 Por hacer |
| 4    | Lógica de precios ajustados| 🔲 Por hacer |
| 5    | Registro de atención       | 🔲 Por hacer |
| 6    | Simulación de factura      | 🔲 Por hacer |
| 7    | UI web básica              | 🔲 Por hacer |

---

## 🧠 Notas personales

- Esta app está pensada inicialmente para uso personal y desarrollo experimental.
- El objetivo es presentar la herramienta a una clínica interesada en usarla como piloto gratuito.

