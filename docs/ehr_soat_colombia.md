# Historia Clínica Electrónica (EHR) para Software SOAT en Colombia

Este documento resume la forma más fácil y compatible de almacenar datos de historia clínica electrónica (EHR) en un sistema de atención médica basado en el SOAT en Colombia.

---

## ✅ 1. Base de Datos Estructurada (PostgreSQL)

Se recomienda iniciar con un modelo relacional mínimo viable que cumpla los requisitos del RIPS y la Norma Técnica de Historia Clínica Electrónica en Colombia.

### Tablas recomendadas:

- `Pacientes`
- `Atenciones`
- `ProfesionalesSalud`
- `HistoriasClinicas`
- `NotasEvolucion`, `OrdenesMedicas`, `Formulaciones`, `Diagnosticos`
- `Procedimientos` (SOAT y CUPS)
- `DocumentosAdjuntos`

---

## ✅ 2. Uso opcional de estructura FHIR simplificada

Para futura interoperabilidad, puedes usar el estándar [FHIR](https://hl7.org/fhir/) como guía. No es obligatorio implementar FHIR completo.

Recursos útiles:

- `Patient`
- `Encounter`
- `Condition`
- `Observation`
- `Procedure`
- `MedicationRequest`
- `DocumentReference`

Puedes almacenarlos como `JSONB` en PostgreSQL si deseas mayor flexibilidad.

---

## ✅ 3. Requisitos de Historia Clínica en Colombia

Según la [Resolución 1995 de 1999](https://www.minsalud.gov.co/Normatividad_Nuevo/Resoluci%C3%B3n%201995%20de%201999.pdf):

Elementos mínimos:

- Identificación del paciente y profesional
- Motivo de consulta
- Antecedentes
- Examen físico
- Diagnósticos (CIE-10)
- Conducta médica (formulación, remisión, etc.)
- Firma digital (ideal)

---

## ✅ 4. Compatibilidad con RIPS

Muchos datos se usarán para el reporte a RIPS (AC, AP, AM, AT, etc.).

Recomendaciones:

- Usa codificación oficial (CIE10, CUPS)
- Modela datos para facilitar la generación de archivos RIPS

---

## ✅ 5. Herramientas sugeridas

Tecnologías compatibles con tu stack (.NET, JS, PostgreSQL):

- **Entity Framework Core** (modelado de datos)
- **KnockoutJS/TypeScript** (frontend)
- **DinkToPDF** (generar PDFs)
- **PostgreSQL JSONB** (almacenar estructuras FHIR u observaciones clínicas)

---

## ✅ 6. Seguridad y cumplimiento

- Encriptar datos sensibles
- Control de acceso basado en roles
- Registro de accesos (logs/auditoría)

---

## ✅ Ejemplo de tabla `HistoriasClinicas`

```sql
CREATE TABLE HistoriasClinicas (
    Id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    PacienteId UUID NOT NULL,
    ProfesionalId UUID NOT NULL,
    FechaRegistro TIMESTAMP NOT NULL DEFAULT NOW(),
    MotivoConsulta TEXT,
    Antecedentes JSONB,
    ExamenFisico JSONB,
    Diagnosticos JSONB,
    Conducta JSONB,
    NotasEvolucion JSONB,
    FirmaDigital TEXT,
    FOREIGN KEY (PacienteId) REFERENCES Pacientes(Id),
    FOREIGN KEY (ProfesionalId) REFERENCES ProfesionalesSalud(Id)
);
```

---

## 📂 Recursos descargables y ejemplos

### Repositorio SQL-on-FHIR

- GitHub: [https://github.com/FHIR/sql-on-fhir-v2](https://github.com/FHIR/sql-on-fhir-v2)
- Contiene scripts SQL, estructuras relacionales y ejemplos en Markdown.

```bash
git clone https://github.com/FHIR/sql-on-fhir-v2.git
```

### Documentación oficial en Markdown:

- Disponible en: `input/pagecontent/*.md` dentro del repositorio.

---

## Siguientes pasos sugeridos

1. Clona el repositorio `sql-on-fhir-v2`
2. Adapta el esquema SQL a requisitos de SOAT y RIPS
3. Crea vistas para generación de RIPS (AC, AP, etc.)
4. Usa JSONB para mayor flexibilidad
5. Documenta tu modelo con archivos `.md`

---

¿Necesitas que te prepare un modelo específico? Pídemelo y te armo el archivo SQL completo.

