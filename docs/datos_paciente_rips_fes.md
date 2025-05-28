# Datos que se deben capturar de un paciente (RIPS y Factura Electrónica de Salud - Colombia)

## 🧾 Identificación del Paciente
- Tipo de documento (CC, TI, RC, CE, PA, MS, etc.)
- Número de documento
- Lugar de expedición
- Primer apellido
- Segundo apellido
- Primer nombre
- Segundo nombre
- Fecha de nacimiento
- Sexo al nacer (M/F)
- Género (según autorreconocimiento)
- Grupo étnico (según clasificación DANE)
- Pertenencia a población especial (desplazado, víctima, indígena, etc.)

## 📍 Datos de Ubicación y Contacto
- Departamento y municipio de residencia
- Dirección de residencia
- Barrio/vereda
- Zona (urbana/rural)
- Teléfono de contacto
- Correo electrónico

## 🏥 Datos del Aseguramiento y Afiliación
- Tipo de régimen (Contributivo, Subsidiado, Especial, Excepción, Vinculado)
- EPS actual (Nombre y código Habilitación)
- Estado de afiliación (Activo, Suspendido)
- Nivel del SISBEN (si aplica)
- Tipo de afiliado (Cotizante, Beneficiario)

## 📋 Datos Clínicos Relevantes (para Historia Clínica y FES)
- Peso y talla (para algunos procedimientos/tarifas)
- Grupo sanguíneo y Rh
- Estado de embarazo (si aplica)
- Discapacidad (tipo y grado)
- Diagnóstico principal actual (código CIE-10)
- Diagnósticos relacionados
- Antecedentes relevantes
- Fecha de ingreso al servicio
- Fecha de egreso (si aplica)

## 👨‍👩‍👧‍👦 Datos del Responsable o Acudiente (si aplica)
- Nombres y apellidos
- Tipo y número de documento
- Parentesco
- Dirección y teléfono

## 📄 Consentimientos y Autorizaciones
- Consentimiento informado (digitalizado o evidencia)
- Autorización EPS (número, fecha, vigencia)
- Firma del paciente (digital o física)
- Documento de autorización de tratamiento de datos personales (Habeas Data)

## 💰 Datos Relevantes para la Facturación Electrónica en Salud
- Tipo de usuario (nuevo, recurrente, urgencias)
- Copago, cuota moderadora o valor a cargo del paciente
- Responsabilidad del pago (EPS, paciente, aseguradora, terceros)
- Tipo de servicio recibido (Consulta, Urgencias, Hospitalización, Procedimientos, Medicamentos, etc.)
- Datos del prestador (para asociar factura a una IPS/habilitación)
- Número de la historia clínica
- Códigos de servicios SOAT/ISS/CUPS aplicables
- Datos de georreferenciación del servicio (si aplica: telesalud, zonas dispersas, etc.)

## 📦 Estructuras complementarias sugeridas
- Afiliación (historial de EPS o régimen)
- Contactos de emergencia
- Coberturas o pólizas adicionales (SOAT, ARL, Medicina prepagada)
- Historial de cambios del paciente (auditoría de datos personales)

## 📚 Fuentes de referencia
1. [Resolución 1995 de 1999 - Historia Clínica](https://www.minsalud.gov.co/Normatividad_Nuevo/Resolución%201995%20de%201999.pdf)
2. [Resolución 1604 de 2013 - Estructura RIPS](https://www.minsalud.gov.co/sites/rid/Lists/BibliotecaDigital/RIDE/DE/DIJ/resolucion-1604-de-2013.pdf)
3. [Anexo Técnico 3 – Factura Electrónica de Salud](https://www.minsalud.gov.co/sites/rid/Lists/BibliotecaDigital/RIDE/DE/DIJ/anexo-tecnico-3-factura-electronica-salud.pdf)
4. [Manual de usuario FES - Facturación Electrónica de Salud](https://www.minsalud.gov.co/salud/Paginas/factura-electronica-en-salud.aspx)
