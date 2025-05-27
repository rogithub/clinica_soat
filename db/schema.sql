BEGIN TRANSACTION;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- For UUID generation
CREATE EXTENSION IF NOT EXISTS unaccent;    -- Para buscar en español ignorando acentos

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

CREATE TABLE IF NOT EXISTS User_Roles (
    Id UUID NOT NULL UNIQUE,
    RoleId UUID NOT NULL,
    UserId UUID NOT NULL,
    PRIMARY KEY(Id),
    FOREIGN KEY(RoleId) REFERENCES Roles(Id) ON DELETE CASCADE,
    FOREIGN KEY(UserId) REFERENCES Users(Id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Reset_Password (
    Id UUID NOT NULL UNIQUE,
    UserId UUID NOT NULL,
    UsedDate TIMESTAMP NULL,  
    ExpiryDate TIMESTAMP NOT NULL,  
    PRIMARY KEY(Id),
    FOREIGN KEY(UserId) REFERENCES Users(Id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Settings (       
       Key                VARCHAR(300) NOT NULL UNIQUE,
       Value              TEXT NULL, -- long values like buttons
       PRIMARY KEY(Key)
);


-- Tabla para categorías clínicas (clasificación médica)
-- Cómo funciona el árbol en este modelo:
--    Cada fila representa un nodo en el árbol.
--    El campo ParentId apunta al Id del nodo padre.
--    El nodo raíz tiene ParentId en NULL.
--    Puedes tener múltiples niveles de jerarquía.
--    "Orden" puede usarse para ordenar hermanos (nodos con el mismo padre).
CREATE TABLE CategoriasClinicas (
    Id SERIAL PRIMARY KEY,
    Nombre TEXT NOT NULL,
    ParentId INTEGER,
    Orden INTEGER,
    FOREIGN KEY(ParentId) REFERENCES CategoriasClinicas(Id) ON DELETE SET NULL,
);

CREATE INDEX idx_categoriasclinicas_parentid
ON CategoriasClinicas (ParentId);

-- Función que valida que no haya ciclos
CREATE OR REPLACE FUNCTION check_no_cycles()
RETURNS TRIGGER AS $$
DECLARE
    current_id INTEGER;
BEGIN
    -- Si ParentId es NULL, no hay problema
    IF NEW.ParentId IS NULL THEN
        RETURN NEW;
    END IF;

    -- Recorre hacia arriba desde el nuevo ParentId
    current_id := NEW.ParentId;
    WHILE current_id IS NOT NULL LOOP
        IF current_id = NEW.Id THEN
            RAISE EXCEPTION 'Ciclo detectado: una categoría no puede ser su propio ancestro.';
        END IF;

        SELECT ParentId INTO current_id FROM CategoriasClinicas WHERE Id = current_id;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que llama la función antes de INSERT o UPDATE
CREATE TRIGGER trigger_no_cycles
BEFORE INSERT OR UPDATE ON CategoriasClinicas
FOR EACH ROW EXECUTE FUNCTION check_no_cycles();


-- Tabla para grupos quirúrgicos (niveles de complejidad para tarifas)
CREATE TABLE GruposTarifarios (
    Id SERIAL PRIMARY KEY,
    Codigo INTEGER UNIQUE NOT NULL,  -- ej. 9, 10, 11, etc.
    Descripcion TEXT NOT NULL,        -- ej. 'Grupo Quirúrgico 9'
    Factor NUMERIC NOT NULL -- Multiplicador sobre el 
);

CREATE TABLE IF NOT EXISTS Procedimientos  (
    id                 SERIAL NOT NULL PRIMARY KEY,  -- Auto-increment primary key
    Codigo             VARCHAR(36) UNIQUE NOT NULL,  -- código del procedimiento o Guid si no es procedimiento
    Nombre             TEXT NOT NULL,
    UserUpdatedId      UUID,                         -- UUID for GUIDs
    DateStamp          TIMESTAMP,
    search_vector      tsvector,                     -- Full-text search vector
    CategoriaClinicaId INTEGER,                      -- puede ser nulo
    GrupoTarifarioId  INTEGER,                       -- puede ser nulo
    FOREIGN KEY(UserUpdatedId) REFERENCES Users(Id) ON DELETE SET NULL,
    FOREIGN KEY(CategoriaClinicaId) REFERENCES CategoriasClinicas(Id) ON DELETE SET NULL,
    FOREIGN KEY(GruposTarifarios) REFERENCES GruposTarifarios(Id) ON DELETE SET NULL
);

CREATE INDEX idx_procedimientos_codigo ON Procedimientos (Codigo);


-- Create a GIN index for the `search_vector` column to optimize full-text searches
CREATE INDEX idx_search_vector ON Procedimientos USING GIN (search_vector);

-- Update the search_vector for existing rows with Spanish language processing
UPDATE Procedimientos
SET search_vector = to_tsvector('spanish', Nombre);

-- Optionally, you could set up a trigger to update the `search_vector` automatically when the relevant columns change.
CREATE OR REPLACE FUNCTION update_search_vector() 
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector := to_tsvector('spanish', NEW.Nombre);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger to call the function on INSERT or UPDATE
CREATE TRIGGER procedimientos_search_vector_trigger
BEFORE INSERT OR UPDATE ON Procedimientos
FOR EACH ROW EXECUTE FUNCTION update_search_vector();


CREATE TABLE IF NOT EXISTS FactoresCobro
(
    Id SERIAL NOT NULL PRIMARY KEY,
    EsVigente BOOLEAN NOT NULL,  -- solo uno será vigente a la vez
    FechaPublicado TIMESTAMP NOT NULL,
    ValorPesos DECIMAL(18, 2) NOT NULL,
    FechaCreado   TIMESTAMP NOT NULL,
    Nombre VARCHAR(300) NOT NULL UNIQUE, -- SMMLV, UVB,
    Descripcion TEXT  -- puede ser null, de que ley sale o quién se lo sacó de la cola
);

CREATE TABLE IF NOT EXISTS PreciosProcedimientos (
    Id            UUID NOT NULL UNIQUE,       
    ProcedimientoId    INTEGER NOT NULL,
    FactorCobroId      INTEGER NULL,              -- Nulo si es solo precio 
    FechaCreado   TIMESTAMP NOT NULL,          -- Changed to TIMESTAMP for date and time
    PrecioPesos           DECIMAL(18, 2),            -- Se debe capturar ya sea el precio en pesos o las unidades de factor
    UnidadesFactorCobro   DECIMAL(18, 2),            -- de cobro, el valor contrario será nulo
    UserUpdatedId UUID,
    PRIMARY KEY(Id),
    FOREIGN KEY(ProcedimientoId) REFERENCES Procedimientos(Id) ON DELETE CASCADE,
    FOREIGN KEY(UserUpdatedId) REFERENCES Users(Id) ON DELETE SET NULL,
    FOREIGN KEY(SalarioMinimoId) REFERENCES SalariosMinimos(Id) ON DELETE SET NULL
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
    Id             UUID NOT NULL UNIQUE,         
    FechaAtencion  TIMESTAMP NOT NULL,           
    UserUpdatedId  UUID,                         
    PacienteId      UUID,                         
    PRIMARY KEY(Id),
    FOREIGN KEY(UserUpdatedId) REFERENCES Users(Id) ON DELETE SET NULL,
    FOREIGN KEY(PacienteId) REFERENCES Pacientes(Id) ON DELETE SET NULL
);

-- Create index on FechaAjuste
CREATE INDEX idx_atenciones_fecha_atencion ON Ajustes(FechaAtencion);


CREATE TABLE IF NOT EXISTS ProcedimientosAtencion (
    Id                  UUID NOT NULL UNIQUE,           
    ProcedimientoId     INTEGER,                  
    AtencionId          UUID NOT NULL,                  
    Cantidad            DECIMAL(18, 2),                 
    PrecioUnitarioVenta DECIMAL(18, 2),                         
    PrecioProcedimientoId    UUID NOT NULL,
    UserUpdatedId       UUID,                           
    DateStamp           TIMESTAMP,                      
    PRIMARY KEY(Id),
    FOREIGN KEY(ProcedimientoId) REFERENCES Procedimientos(Id) ON DELETE CASCADE,
    FOREIGN KEY(AtencionId) REFERENCES Atenciones(Id) ON DELETE CASCADE,
    FOREIGN KEY(UserUpdatedId) REFERENCES Users(Id) ON DELETE SET NULL,
    FOREIGN KEY(PrecioProcedimientoId) REFERENCES PreciosProcedimientos(Id) ON DELETE SET NULL
);


COMMIT;
