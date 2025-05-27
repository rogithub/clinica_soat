
# 🏥 Sistema de Facturación SOAT – MVP (Producto Mínimo Viable)

Este documento describe cómo iniciar el desarrollo de un sistema funcional básico para la **facturación de servicios médicos cubiertos por el SOAT**, conforme a la normativa de RIPS y FEV en Colombia.

---

## ✅ Objetivo Inicial

Desarrollar un sistema mínimo funcional (MVP) que permita **registrar, validar, generar y radicar** casos de atención médica relacionados con el SOAT.

---

## 🧱 1. Módulos Básicos del MVP

### 🔹 1. Registro de Atención

- Registro del paciente (víctima del accidente)
- Datos del accidente (fecha, ubicación, tipo)
- Registro de servicios prestados:
  - Procedimientos (CUPS)
  - Medicamentos, insumos, transporte, etc.

### 🔹 2. Validación de Datos

- Validación de códigos CUPS
- Validación de tipo y número de documento
- Validación de profesional y prestador

### 🔹 3. Generación del RIPS

- Generación del archivo JSON
- Conformidad con la estructura de MinSalud
- Tipos: consulta, procedimiento, urgencia, hospitalización, medicamentos

### 🔹 4. Generación de Factura Electrónica (FEV)

- Estructura XML
- Asociación con el RIPS
- Datos financieros y del paciente

### 🔹 5. Validación y Radicación

- Envío de FEV + RIPS al validador del Ministerio
- Recepción del CUV (Código Único de Validación)
- Registro de número de radicación ante SOAT

---

## 📋 2. Funcionalidades Mínimas para SOAT

| Módulo                        | Funcionalidad                                             |
|------------------------------|-----------------------------------------------------------|
| 🧑‍⚕️ Pacientes                | Registro de víctimas de accidentes                        |
| 🚑 Atención médica           | Registro de servicios por evento                          |
| 📦 Catálogos                  | CUPS, documentos, sexo, municipios                        |
| 📤 RIPS Generator            | Generación de estructura JSON válida                     |
| 📄 Facturación (FEV)         | Estructura XML con valores y servicios                    |
| 🔐 Validación CUV            | Comunicación con validador del MinSalud                  |
| 📁 Radicación                | Envío al pagador SOAT con CUV y soportes                 |
| 🧾 Reportes                  | Estado de radicación, glosas, pagos                       |

---

## 🚀 3. ¿Por Dónde Empezar?

### Etapa 1: Diseño

- Definir entidades clave: paciente, accidente, servicio, factura, RIPS
- Modelar base de datos: `Pacientes`, `Accidentes`, `Servicios`, `Facturas`, `RIPS`

### Etapa 2: Desarrollo

- Crear formularios para registrar atención
- Lógica para generación de RIPS JSON
- Módulo básico de facturación y validación local

### Etapa 3: Validación Externa

- Integrar API Docker del MinSalud (cuando se requiera)
- Generar CUV y validar flujo completo

---

## 🛠️ Herramientas Sugeridas

| Función                     | Herramienta recomendada                  |
|-----------------------------|------------------------------------------|
| Backend                     | .NET Core                                |
| Base de datos               | PostgreSQL                               |
| Frontend                    | MVC, knockout, javascrip                 |
| Validación RIPS-FEV         | API Docker o cliente-servidor del MinSalud |
| XML/JSON manejo             | Librerías estándar en tu stack elegido   |





## 📖 Licencia

Este proyecto está licenciado bajo los términos de la [Apache License 2.0](LICENSE).

---