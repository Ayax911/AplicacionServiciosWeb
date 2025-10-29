-- =============================================
-- 1. SP DETALLE: Obtener todas las asociaciones con información completa
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaProyectoDetalle
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Claves primarias
        mp.IdMeta,
        mp.IdProyecto,
        mp.FechaAsociacion,
        
        -- Información de Meta Estratégica
        me.Titulo AS TituloMeta,
        me.Descripcion AS DescripcionMeta,
        oe.Titulo AS ObjetivoEstrategico,
        
        -- Información de Proyecto
        p.Codigo AS CodigoProyecto,
        p.Titulo AS TituloProyecto,
        tp.Nombre AS TipoProyecto,
        r.Nombre AS ResponsableProyecto
        
    FROM Meta_Proyecto mp
    
    INNER JOIN MetaEstrategica me ON mp.IdMeta = me.Id
    INNER JOIN ObjetivoEstrategico oe ON me.IdObjetivo = oe.Id
    INNER JOIN Proyecto p ON mp.IdProyecto = p.Id
    LEFT JOIN TipoProyecto tp ON p.IdTipoProyecto = tp.Id
    LEFT JOIN Responsable r ON p.IdResponsable = r.Id
    
    ORDER BY mp.FechaAsociacion DESC, me.Titulo, p.Titulo;
END
GO

-- =============================================
-- 2. SP POR PROYECTO: Obtener metas de un proyecto específico
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaProyectoPorProyecto
    @IdProyecto INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Claves primarias
        mp.IdMeta,
        mp.IdProyecto,
        mp.FechaAsociacion,
        
        -- Información de Meta Estratégica
        me.Titulo AS TituloMeta,
        me.Descripcion AS DescripcionMeta,
        oe.Titulo AS ObjetivoEstrategico,
        
        -- Información de Proyecto
        p.Codigo AS CodigoProyecto,
        p.Titulo AS TituloProyecto,
        tp.Nombre AS TipoProyecto,
        r.Nombre AS ResponsableProyecto
        
    FROM Meta_Proyecto mp
    
    INNER JOIN MetaEstrategica me ON mp.IdMeta = me.Id
    INNER JOIN ObjetivoEstrategico oe ON me.IdObjetivo = oe.Id
    INNER JOIN Proyecto p ON mp.IdProyecto = p.Id
    LEFT JOIN TipoProyecto tp ON p.IdTipoProyecto = tp.Id
    LEFT JOIN Responsable r ON p.IdResponsable = r.Id
    
    WHERE mp.IdProyecto = @IdProyecto
    
    ORDER BY me.Titulo;
END
GO

-- =============================================
-- 3. SP POR META: Obtener proyectos de una meta específica
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaProyectoPorMeta
    @IdMeta INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Claves primarias
        mp.IdMeta,
        mp.IdProyecto,
        mp.FechaAsociacion,
        
        -- Información de Meta Estratégica
        me.Titulo AS TituloMeta,
        me.Descripcion AS DescripcionMeta,
        oe.Titulo AS ObjetivoEstrategico,
        
        -- Información de Proyecto
        p.Codigo AS CodigoProyecto,
        p.Titulo AS TituloProyecto,
        tp.Nombre AS TipoProyecto,
        r.Nombre AS ResponsableProyecto
        
    FROM Meta_Proyecto mp
    
    INNER JOIN MetaEstrategica me ON mp.IdMeta = me.Id
    INNER JOIN ObjetivoEstrategico oe ON me.IdObjetivo = oe.Id
    INNER JOIN Proyecto p ON mp.IdProyecto = p.Id
    LEFT JOIN TipoProyecto tp ON p.IdTipoProyecto = tp.Id
    LEFT JOIN Responsable r ON p.IdResponsable = r.Id
    
    WHERE mp.IdMeta = @IdMeta
    
    ORDER BY p.Titulo;
END
GO

-- =============================================
-- 4. SP CREAR: Insertar nueva asociación Meta-Proyecto
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaProyectoCrear
    @IdMeta INT,
    @IdProyecto INT,
    @FechaAsociacion DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Si no se proporciona fecha, usar la actual
    IF @FechaAsociacion IS NULL
        SET @FechaAsociacion = GETDATE();

    -- Verificar si ya existe la asociación
    IF EXISTS (SELECT 1 FROM Meta_Proyecto WHERE IdMeta = @IdMeta AND IdProyecto = @IdProyecto)
    BEGIN
        RAISERROR('Ya existe una asociación entre esta meta y este proyecto.', 16, 1);
        RETURN;
    END

    -- Verificar que existe la meta
    IF NOT EXISTS (SELECT 1 FROM MetaEstrategica WHERE Id = @IdMeta)
    BEGIN
        RAISERROR('La meta estratégica especificada no existe.', 16, 1);
        RETURN;
    END

    -- Verificar que existe el proyecto
    IF NOT EXISTS (SELECT 1 FROM Proyecto WHERE Id = @IdProyecto)
    BEGIN
        RAISERROR('El proyecto especificado no existe.', 16, 1);
        RETURN;
    END

    -- Insertar la asociación
    INSERT INTO Meta_Proyecto (IdMeta, IdProyecto, FechaAsociacion)
    VALUES (@IdMeta, @IdProyecto, @FechaAsociacion);

    -- Retornar la asociación creada
    SELECT 
        mp.IdMeta,
        mp.IdProyecto,
        mp.FechaAsociacion,
        me.Titulo AS TituloMeta,
        me.Descripcion AS DescripcionMeta,
        oe.Titulo AS ObjetivoEstrategico,
        p.Codigo AS CodigoProyecto,
        p.Titulo AS TituloProyecto,
        tp.Nombre AS TipoProyecto,
        r.Nombre AS ResponsableProyecto
    FROM Meta_Proyecto mp
    INNER JOIN MetaEstrategica me ON mp.IdMeta = me.Id
    INNER JOIN ObjetivoEstrategico oe ON me.IdObjetivo = oe.Id
    INNER JOIN Proyecto p ON mp.IdProyecto = p.Id
    LEFT JOIN TipoProyecto tp ON p.IdTipoProyecto = tp.Id
    LEFT JOIN Responsable r ON p.IdResponsable = r.Id
    WHERE mp.IdMeta = @IdMeta AND mp.IdProyecto = @IdProyecto;
END
GO

-- =============================================
-- 5. SP ACTUALIZAR: Modificar fecha de asociación
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaProyectoActualizar
    @IdMeta INT,
    @IdProyecto INT,
    @FechaAsociacion DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que existe la asociación
    IF NOT EXISTS (SELECT 1 FROM Meta_Proyecto WHERE IdMeta = @IdMeta AND IdProyecto = @IdProyecto)
    BEGIN
        RAISERROR('La asociación especificada no existe.', 16, 1);
        RETURN;
    END

    -- Actualizar la fecha de asociación
    UPDATE Meta_Proyecto
    SET FechaAsociacion = @FechaAsociacion
    WHERE IdMeta = @IdMeta AND IdProyecto = @IdProyecto;

    -- Retornar la asociación actualizada
    SELECT 
        mp.IdMeta,
        mp.IdProyecto,
        mp.FechaAsociacion,
        me.Titulo AS TituloMeta,
        me.Descripcion AS DescripcionMeta,
        oe.Titulo AS ObjetivoEstrategico,
        p.Codigo AS CodigoProyecto,
        p.Titulo AS TituloProyecto,
        tp.Nombre AS TipoProyecto,
        r.Nombre AS ResponsableProyecto
    FROM Meta_Proyecto mp
    INNER JOIN MetaEstrategica me ON mp.IdMeta = me.Id
    INNER JOIN ObjetivoEstrategico oe ON me.IdObjetivo = oe.Id
    INNER JOIN Proyecto p ON mp.IdProyecto = p.Id
    LEFT JOIN TipoProyecto tp ON p.IdTipoProyecto = tp.Id
    LEFT JOIN Responsable r ON p.IdResponsable = r.Id
    WHERE mp.IdMeta = @IdMeta AND mp.IdProyecto = @IdProyecto;
END
GO

-- =============================================
-- 6. SP ELIMINAR: Eliminar una asociación específica
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaProyectoEliminar
    @IdMeta INT,
    @IdProyecto INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que existe la asociación
    IF NOT EXISTS (SELECT 1 FROM Meta_Proyecto WHERE IdMeta = @IdMeta AND IdProyecto = @IdProyecto)
    BEGIN
        RAISERROR('La asociación especificada no existe.', 16, 1);
        RETURN;
    END

    -- Eliminar la asociación
    DELETE FROM Meta_Proyecto
    WHERE IdMeta = @IdMeta AND IdProyecto = @IdProyecto;

    -- Retornar confirmación
    SELECT 'Asociación eliminada correctamente' AS Mensaje;
END
GO

-- =============================================
-- 7. SP ELIMINAR POR PROYECTO: Eliminar todas las metas de un proyecto
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaProyectoEliminarPorProyecto
    @IdProyecto INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CantidadEliminada INT;

    -- Eliminar todas las asociaciones del proyecto
    DELETE FROM Meta_Proyecto
    WHERE IdProyecto = @IdProyecto;

    SET @CantidadEliminada = @@ROWCOUNT;

    -- Retornar confirmación
    SELECT 
        @CantidadEliminada AS CantidadEliminada,
        'Asociaciones eliminadas correctamente' AS Mensaje;
END
GO

-- =============================================
-- 8. SP ESTADÍSTICAS: Obtener métricas de asociaciones
-- =============================================
CREATE OR ALTER PROCEDURE SPMetaProyectoEstadisticas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Total de asociaciones
        (SELECT COUNT(*) FROM Meta_Proyecto) AS TotalAsociaciones,
        
        -- Metas sin proyectos
        (SELECT COUNT(*) FROM MetaEstrategica me 
         WHERE NOT EXISTS (SELECT 1 FROM Meta_Proyecto mp WHERE mp.IdMeta = me.Id)) AS MetasSinProyectos,
        
        -- Proyectos sin metas
        (SELECT COUNT(*) FROM Proyecto p 
         WHERE NOT EXISTS (SELECT 1 FROM Meta_Proyecto mp WHERE mp.IdProyecto = p.Id)) AS ProyectosSinMetas,
        
        -- Promedio de metas por proyecto
        (SELECT AVG(CAST(CantidadMetas AS FLOAT)) 
         FROM (SELECT COUNT(*) AS CantidadMetas 
               FROM Meta_Proyecto 
               GROUP BY IdProyecto) AS Subconsulta) AS PromedioMetasPorProyecto,
        
        -- Proyecto con más metas
        (SELECT TOP 1 p.Titulo 
         FROM Proyecto p
         INNER JOIN Meta_Proyecto mp ON p.Id = mp.IdProyecto
         GROUP BY p.Id, p.Titulo
         ORDER BY COUNT(*) DESC) AS ProyectoConMasMetas,
        
        -- Meta más asociada
        (SELECT TOP 1 me.Titulo 
         FROM MetaEstrategica me
         INNER JOIN Meta_Proyecto mp ON me.Id = mp.IdMeta
         GROUP BY me.Id, me.Titulo
         ORDER BY COUNT(*) DESC) AS MetaMasAsociada;
END
GO

-- =============================================
-- 9. SCRIPT DE PRUEBA: Verificar funcionamiento
-- =============================================
/*
-- Insertar datos de prueba (ajustar IDs según tu BD)
EXEC SPMetaProyectoCrear @IdMeta = 1, @IdProyecto = 1, @FechaAsociacion = '2025-01-15';
EXEC SPMetaProyectoCrear @IdMeta = 2, @IdProyecto = 1, @FechaAsociacion = '2025-01-20';

-- Consultar todas las asociaciones
EXEC SPMetaProyectoDetalle;

-- Consultar por proyecto
EXEC SPMetaProyectoPorProyecto @IdProyecto = 1;

-- Consultar por meta
EXEC SPMetaProyectoPorMeta @IdMeta = 1;

-- Actualizar fecha
EXEC SPMetaProyectoActualizar @IdMeta = 1, @IdProyecto = 1, @FechaAsociacion = '2025-02-01';

-- Ver estadísticas
EXEC SPMetaProyectoEstadisticas;

-- Eliminar asociación
EXEC SPMetaProyectoEliminar @IdMeta = 1, @IdProyecto = 1;
*/
