
-- Archivo: schema_camelcase.sql
-- Esquema con convenciones CamelCase aplicadas a tablas, columnas, índices y funciones

BEGIN TRANSACTION;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS unaccent;

CREATE TABLE IF NOT EXISTS Users (
    Id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Email VARCHAR(300) NOT NULL UNIQUE,
    IsActive BOOLEAN DEFAULT FALSE,
    PasswordHash BYTEA NOT NULL,
    PasswordSalt BYTEA NOT NULL,
    DateCreated TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS Roles (
    Id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Role VARCHAR(300) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS UserRoles (
    Id UUID NOT NULL UNIQUE,
    RoleId UUID NOT NULL,
    UserId UUID NOT NULL,
    PRIMARY KEY(Id),
    FOREIGN KEY(RoleId) REFERENCES Roles(Id) ON DELETE CASCADE,
    FOREIGN KEY(UserId) REFERENCES Users(Id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ResetPassword (
    Id UUID NOT NULL UNIQUE,
    UserId UUID NOT NULL,
    UsedDate TIMESTAMP NULL,
    ExpiryDate TIMESTAMP NOT NULL,
    PRIMARY KEY(Id),
    FOREIGN KEY(UserId) REFERENCES Users(Id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Settings (
    Key VARCHAR(300) NOT NULL UNIQUE,
    Value TEXT NULL,
    PRIMARY KEY(Key)
);

CREATE TABLE CategoriasClinicas (
    Id SERIAL PRIMARY KEY,
    Nombre TEXT NOT NULL,
    ParentId INTEGER,
    Orden INTEGER,
    FOREIGN KEY(ParentId) REFERENCES CategoriasClinicas(Id) ON DELETE SET NULL
);

CREATE INDEX IdxCategoriasClinicasParentId ON CategoriasClinicas (ParentId);

CREATE OR REPLACE FUNCTION CheckNoCycles()
RETURNS TRIGGER AS $$
DECLARE
    CurrentId INTEGER;
BEGIN
    IF NEW.ParentId IS NULL THEN
        RETURN NEW;
    END IF;

    CurrentId := NEW.ParentId;
    WHILE CurrentId IS NOT NULL LOOP
        IF CurrentId = NEW.Id THEN
            RAISE EXCEPTION 'Ciclo detectado: una categoría no puede ser su propio ancestro.';
        END IF;
        SELECT ParentId INTO CurrentId FROM CategoriasClinicas WHERE Id = CurrentId;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TriggerNoCycles
BEFORE INSERT OR UPDATE ON CategoriasClinicas
FOR EACH ROW EXECUTE FUNCTION CheckNoCycles();

CREATE TABLE GruposTarifarios (
    Id SERIAL PRIMARY KEY,
    Codigo INTEGER UNIQUE NOT NULL,
    Descripcion TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Procedimientos (
    Id SERIAL NOT NULL PRIMARY KEY,
    Codigo VARCHAR(36) UNIQUE NOT NULL,
    Nombre TEXT NOT NULL,
    UserUpdatedId UUID,
    DateStamp TIMESTAMP,
    SearchVector tsvector,
    CategoriaClinicaId INTEGER,
    GrupoTarifarioId INTEGER,
    FOREIGN KEY(UserUpdatedId) REFERENCES Users(Id) ON DELETE SET NULL,
    FOREIGN KEY(CategoriaClinicaId) REFERENCES CategoriasClinicas(Id) ON DELETE SET NULL,
    FOREIGN KEY(GrupoTarifarioId) REFERENCES GruposTarifarios(Id) ON DELETE SET NULL
);

CREATE INDEX IdxProcedimientosCodigo ON Procedimientos (Codigo);
CREATE INDEX IdxSearchVector ON Procedimientos USING GIN (SearchVector);

UPDATE Procedimientos SET SearchVector = to_tsvector('spanish', Nombre);

CREATE OR REPLACE FUNCTION UpdateSearchVector()
RETURNS TRIGGER AS $$
BEGIN
  NEW.SearchVector := to_tsvector('spanish', NEW.Nombre);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ProcedimientosSearchVectorTrigger
BEFORE INSERT OR UPDATE ON Procedimientos
FOR EACH ROW EXECUTE FUNCTION UpdateSearchVector();

CREATE TABLE IF NOT EXISTS FactoresCobro (
    Id SERIAL NOT NULL PRIMARY KEY,
    EsVigente BOOLEAN NOT NULL,
    FechaPublicado TIMESTAMP NOT NULL,
    ValorPesos DECIMAL(18, 2) NOT NULL,
    FechaCreado TIMESTAMP NOT NULL,
    Nombre VARCHAR(300) NOT NULL UNIQUE,
    Descripcion TEXT
);

CREATE TABLE IF NOT EXISTS PreciosProcedimientos (
    Id UUID NOT NULL UNIQUE,
    ProcedimientoId INTEGER NOT NULL,
    FactorCobroId INTEGER NULL,
    FechaCreado TIMESTAMP NOT NULL,
    PrecioPesos DECIMAL(18, 2),
    UnidadesFactorCobro DECIMAL(18, 2),
    UserUpdatedId UUID,
    PRIMARY KEY(Id),
    FOREIGN KEY(ProcedimientoId) REFERENCES Procedimientos(Id) ON DELETE CASCADE,
    FOREIGN KEY(UserUpdatedId) REFERENCES Users(Id) ON DELETE SET NULL,
    FOREIGN KEY(FactorCobroId) REFERENCES FactoresCobro(Id) ON DELETE SET NULL
);

CREATE TABLE Pacientes (
    Id SERIAL PRIMARY KEY,
    TipoDocumento TEXT,
    Documento TEXT UNIQUE,
    Nombre TEXT,
    FechaNacimiento DATE,
    Sexo TEXT
);

CREATE TABLE IF NOT EXISTS Atenciones (
    Id UUID NOT NULL UNIQUE,
    FechaAtencion TIMESTAMP NOT NULL,
    UserUpdatedId UUID,
    PacienteId UUID,
    PRIMARY KEY(Id),
    FOREIGN KEY(UserUpdatedId) REFERENCES Users(Id) ON DELETE SET NULL,
    FOREIGN KEY(PacienteId) REFERENCES Pacientes(Id) ON DELETE SET NULL
);

CREATE INDEX IdxAtencionesFechaAtencion ON Atenciones(FechaAtencion);

CREATE TABLE IF NOT EXISTS ProcedimientosAtencion (
    Id UUID NOT NULL UNIQUE,
    ProcedimientoId INTEGER,
    AtencionId UUID NOT NULL,
    Cantidad DECIMAL(18, 2),
    PrecioUnitarioVenta DECIMAL(18, 2),
    PrecioProcedimientoId UUID NOT NULL,
    UserUpdatedId UUID,
    DateStamp TIMESTAMP,
    PRIMARY KEY(Id),
    FOREIGN KEY(ProcedimientoId) REFERENCES Procedimientos(Id) ON DELETE CASCADE,
    FOREIGN KEY(AtencionId) REFERENCES Atenciones(Id) ON DELETE CASCADE,
    FOREIGN KEY(UserUpdatedId) REFERENCES Users(Id) ON DELETE SET NULL,
    FOREIGN KEY(PrecioProcedimientoId) REFERENCES PreciosProcedimientos(Id) ON DELETE SET NULL
);

COMMIT;
