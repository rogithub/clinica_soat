---
# Campos Requeridos para la Tabla de Pacientes - RIPS y FES para SOAT

Este documento detalla los campos necesarios para la tabla de pacientes, cumpliendo con los requerimientos establecidos por el gobierno de Colombia según la Resolución 1036 de 2022 y otras normativas relacionadas con RIPS y FES para SOAT.

---

# Campos de la Tabla de Pacientes

| Código | Nombre del Campo | Tipo | Longitud | Obligatorio | Descripción |
|--------|------------------|------|-----------|--------------|-------------|
| U01 | tipoIdentificacion | Cadena | 2 | Sí | Tipo de documento de identificación del paciente. Valores permitidos: CC, CE, CD, PA, SC, PE, DE, PT. |
| U02 | numIdentificacion | Cadena | 4-20 | Sí | Número de identificación del paciente. |
| U03 | codSexoBiologico | Cadena | 2 | Sí | Sexo biológico del paciente. Valores permitidos: 01 (Masculino), 02 (Femenino). |
| U04 | fechaNacimiento | Fecha | 10 | Sí | Fecha de nacimiento del paciente en formato AAAA-MM-DD. |
| U05 | codPaisOrigen | Cadena | 3 | Sí | Código del país de origen del paciente según la normativa vigente. |
| U06 | codZonaTerritorialResidencia | Cadena | 2 | No | Código de la zona territorial de residencia del paciente. |
| U07 | incapacidad | Cadena | 2 | Sí | Indicador de incapacidad del paciente. |
| U08 | consecutivo | Numérico | 1-7 | Sí | Número consecutivo del registro. |

---

# Fuentes Oficiales

- Resolución 1036 de 2022: https://miscuentasmedicas.com/ANEXO-resolucion-1036-de-2022
- Guía sobre la estructura de los datos a reportar en los RIPS en formato JSON: https://miscuentasmedicas.com/guia-sobre-la-estructura-de-los-datos-a-reportar-en-los-RIPS-en-formato-JSON
- Sistema de Información de Prestaciones de Salud - RIPS: https://www.minsalud.gov.co/proteccionsocial/paginas/rips.aspx

---

Este documento está diseñado para facilitar la implementación y verificación de los campos requeridos en la tabla de pacientes, asegurando el cumplimiento con las normativas vigentes en Colombia.

---