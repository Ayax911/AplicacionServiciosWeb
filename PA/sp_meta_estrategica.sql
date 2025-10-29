-- =============================================
-- STORED PROCEDURES - META ESTRATEGICA
-- =============================================

-- =============================================
-- 1. SP DETALLE: Obtener todas las metas estratégicas
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaEstrategicaDetalle
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        me.Id,
        me.IdObjetivo,
        me.Titulo,
        me.Descripcion,
        oe.Titulo AS Objetivo
    FROM MetaEstrategica me
    INNER JOIN ObjetivoEstrategico oe ON me.IdObjetivo = oe.Id
    ORDER BY oe.Titulo, me.Titulo;
END
GO

-- =============================================
-- 2. SP CREAR: Crear nueva meta estratégica
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaEstrategicaCrear
    @IdObjetivo INT,
    @Titulo NVARCHAR(200),
    @Descripcion NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que existe el objetivo estratégico
    IF NOT EXISTS (SELECT 1 FROM ObjetivoEstrategico WHERE Id = @IdObjetivo)
    BEGIN
        RAISERROR('El objetivo estratégico especificado no existe.', 16, 1);
        RETURN;
    END

    -- Validar que el título no esté vacío
    IF @Titulo IS NULL OR LTRIM(RTRIM(@Titulo)) = ''
    BEGIN
        RAISERROR('El título no puede estar vacío.', 16, 1);
        RETURN;
    END

    -- Insertar la meta estratégica
    INSERT INTO MetaEstrategica (IdObjetivo, Titulo, Descripcion)
    VALUES (@IdObjetivo, @Titulo, @Descripcion);

    DECLARE @IdNuevo INT = SCOPE_IDENTITY();

    -- Retornar la meta creada
    SELECT 
        me.Id,
        me.IdObjetivo,
        me.Titulo,
        me.Descripcion,
        oe.Titulo AS Objetivo
    FROM MetaEstrategica me
    INNER JOIN ObjetivoEstrategico oe ON me.IdObjetivo = oe.Id
    WHERE me.Id = @IdNuevo;
END
GO

-- =============================================
-- 3. SP ACTUALIZAR: Actualizar meta estratégica
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaEstrategicaActualizar
    @Id INT,
    @IdObjetivo INT,
    @Titulo NVARCHAR(200),
    @Descripcion NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que existe la meta
    IF NOT EXISTS (SELECT 1 FROM MetaEstrategica WHERE Id = @Id)
    BEGIN
        RAISERROR('La meta estratégica especificada no existe.', 16, 1);
        RETURN;
    END

    -- Validar que existe el objetivo estratégico
    IF NOT EXISTS (SELECT 1 FROM ObjetivoEstrategico WHERE Id = @IdObjetivo)
    BEGIN
        RAISERROR('El objetivo estratégico especificado no existe.', 16, 1);
        RETURN;
    END

    -- Validar que el título no esté vacío
    IF @Titulo IS NULL OR LTRIM(RTRIM(@Titulo)) = ''
    BEGIN
        RAISERROR('El título no puede estar vacío.', 16, 1);
        RETURN;
    END

    -- Actualizar la meta
    UPDATE MetaEstrategica
    SET 
        IdObjetivo = @IdObjetivo,
        Titulo = @Titulo,
        Descripcion = @Descripcion
    WHERE Id = @Id;

    -- Retornar la meta actualizada
    SELECT 
        me.Id,
        me.IdObjetivo,
        me.Titulo,
        me.Descripcion,
        oe.Titulo AS Objetivo
    FROM MetaEstrategica me
    INNER JOIN ObjetivoEstrategico oe ON me.IdObjetivo = oe.Id
    WHERE me.Id = @Id;
END
GO

-- =============================================
-- 4. SP ELIMINAR: Eliminar meta estratégica
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaEstrategicaEliminar
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que existe la meta
    IF NOT EXISTS (SELECT 1 FROM MetaEstrategica WHERE Id = @Id)
    BEGIN
        RAISERROR('La meta estratégica especificada no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si tiene asociaciones con proyectos
    IF EXISTS (SELECT 1 FROM Meta_Proyecto WHERE IdMeta = @Id)
    BEGIN
        RAISERROR('No se puede eliminar la Meta Estratégica porque tiene proyectos asociados.', 16, 1);
        RETURN;
    END

    -- Eliminar la meta
    DELETE FROM MetaEstrategica WHERE Id = @Id;

    SELECT 'Meta estratégica eliminada correctamente' AS Mensaje;
END
GO

-- =============================================
-- 5. SP LISTAR OBJETIVOS: Obtener objetivos estratégicos
-- =============================================
CREATE OR ALTER PROCEDURE SPObjetivoEstrategicoListar
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        Id,
        Titulo,
        Descripcion
    FROM ObjetivoEstrategico
    ORDER BY Titulo;
END
GO

-- =============================================
-- TABLAS NECESARIAS (si no existen)
-- =============================================
/*
-- Tabla ObjetivoEstrategico
CREATE TABLE ObjetivoEstrategico (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(MAX) NULL
);

-- Tabla MetaEstrategica
CREATE TABLE MetaEstrategica (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdObjetivo INT NOT NULL,
    Titulo NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(MAX) NULL,
    
    CONSTRAINT FK_MetaEstrategica_ObjetivoEstrategico 
        FOREIGN KEY (IdObjetivo) REFERENCES ObjetivoEstrategico(Id)
);

-- Índice
CREATE INDEX IX_MetaEstrategica_IdObjetivo 
    ON MetaEstrategica(IdObjetivo);
*/

-- =============================================
-- SCRIPT DE PRUEBA
-- =============================================
/*
-- Insertar objetivos estratégicos de prueba
INSERT INTO ObjetivoEstrategico (Titulo, Descripcion) VALUES
('Crecimiento Empresarial', 'Expandir la presencia en el mercado nacional e internacional'),
('Innovación Tecnológica', 'Implementar nuevas tecnologías para mejorar procesos'),
('Sostenibilidad', 'Reducir el impacto ambiental de las operaciones');

-- Crear metas estratégicas
EXEC SPMetaEstrategicaCrear 
    @IdObjetivo = 1, 
    @Titulo = 'Aumentar ventas en 20%', 
    @Descripcion = 'Incrementar las ventas anuales en un 20% durante el año fiscal';

EXEC SPMetaEstrategicaCrear 
    @IdObjetivo = 2, 
    @Titulo = 'Implementar ERP', 
    @Descripcion = 'Desarrollar e implementar sistema ERP para toda la organización';

-- Listar todas las metas
EXEC SPMetaEstrategicaDetalle;

-- Actualizar meta
EXEC SPMetaEstrategicaActualizar 
    @Id = 1, 
    @IdObjetivo = 1, 
    @Titulo = 'Aumentar ventas en 25%', 
    @Descripcion = 'Meta ajustada por proyecciones optimistas';

-- Eliminar meta (solo si no tiene proyectos asociados)
EXEC SPMetaEstrategicaEliminar @Id = 1;

-- Listar objetivos estratégicos
EXEC SPObjetivoEstrategicoListar;
*/
