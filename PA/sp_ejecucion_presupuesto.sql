-- =============================================
-- STORED PROCEDURES - EJECUCION PRESUPUESTO
-- =============================================

-- =============================================
-- 1. SP DETALLE: Obtener todas las ejecuciones
-- =============================================
CREATE OR ALTER PROCEDURE SPEjecucionPresupuestoDetalle
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ep.Id,
        ep.IdPresupuesto,
        ep.Anio,
        ep.MontoPlaneado,
        ep.MontoEjecutado,
        ep.Observaciones
    FROM EjecucionPresupuesto ep
    ORDER BY ep.Anio DESC, ep.Id DESC;
END
GO

-- =============================================
-- 2. SP GUARDAR: Crear o actualizar ejecución
-- =============================================
CREATE OR ALTER PROCEDURE SPEjecucionPresupuestoGuardar
    @Id INT = NULL,
    @IdPresupuesto INT,
    @Anio INT,
    @MontoPlaneado DECIMAL(18,2),
    @MontoEjecutado DECIMAL(18,2),
    @Observaciones NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar que existe el presupuesto
    IF NOT EXISTS (SELECT 1 FROM Presupuesto WHERE Id = @IdPresupuesto)
    BEGIN
        RAISERROR('El presupuesto especificado no existe.', 16, 1);
        RETURN;
    END

    -- Validar que el año sea válido
    IF @Anio < 2000 OR @Anio > 2100
    BEGIN
        RAISERROR('El año debe estar entre 2000 y 2100.', 16, 1);
        RETURN;
    END

    -- Validar que los montos sean positivos
    IF @MontoPlaneado < 0 OR @MontoEjecutado < 0
    BEGIN
        RAISERROR('Los montos no pueden ser negativos.', 16, 1);
        RETURN;
    END

    -- Actualizar o insertar
    IF @Id IS NOT NULL AND @Id > 0
    BEGIN
        -- Verificar que existe el registro
        IF NOT EXISTS (SELECT 1 FROM EjecucionPresupuesto WHERE Id = @Id)
        BEGIN
            RAISERROR('La ejecución de presupuesto especificada no existe.', 16, 1);
            RETURN;
        END

        -- ACTUALIZAR
        UPDATE EjecucionPresupuesto
        SET 
            IdPresupuesto = @IdPresupuesto,
            Anio = @Anio,
            MontoPlaneado = @MontoPlaneado,
            MontoEjecutado = @MontoEjecutado,
            Observaciones = @Observaciones
        WHERE Id = @Id;

        SELECT 'Ejecución de presupuesto actualizada correctamente' AS Mensaje;
    END
    ELSE
    BEGIN
        -- Validar que no exista duplicado (mismo presupuesto y año)
        IF EXISTS (SELECT 1 FROM EjecucionPresupuesto WHERE IdPresupuesto = @IdPresupuesto AND Anio = @Anio)
        BEGIN
            RAISERROR('Ya existe una ejecución para este presupuesto en el año especificado.', 16, 1);
            RETURN;
        END

        -- INSERTAR
        INSERT INTO EjecucionPresupuesto (
            IdPresupuesto, Anio, MontoPlaneado, MontoEjecutado, Observaciones
        )
        VALUES (
            @IdPresupuesto, @Anio, @MontoPlaneado, @MontoEjecutado, @Observaciones
        );

        SELECT 'Ejecución de presupuesto creada correctamente' AS Mensaje;
    END
END
GO

-- =============================================
-- 3. SP POR PRESUPUESTO: Obtener ejecuciones de un presupuesto
-- =============================================
CREATE OR ALTER PROCEDURE SPEjecucionPresupuestoPorPresupuesto
    @IdPresupuesto INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ep.Id,
        ep.IdPresupuesto,
        ep.Anio,
        ep.MontoPlaneado,
        ep.MontoEjecutado,
        ep.Observaciones
    FROM EjecucionPresupuesto ep
    WHERE ep.IdPresupuesto = @IdPresupuesto
    ORDER BY ep.Anio DESC;
END
GO

-- =============================================
-- 4. SP POR AÑO: Obtener ejecuciones de un año específico
-- =============================================
CREATE OR ALTER PROCEDURE SPEjecucionPresupuestoPorAnio
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ep.Id,
        ep.IdPresupuesto,
        ep.Anio,
        ep.MontoPlaneado,
        ep.MontoEjecutado,
        ep.Observaciones
    FROM EjecucionPresupuesto ep
    WHERE ep.Anio = @Anio
    ORDER BY ep.IdPresupuesto;
END
GO

-- =============================================
-- 5. SP RESUMEN: Obtener resumen de ejecución
-- =============================================
CREATE OR ALTER PROCEDURE SPEjecucionPresupuestoResumen
    @Anio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ep.Anio,
        COUNT(*) AS TotalEjecuciones,
        SUM(ep.MontoPlaneado) AS TotalPlaneado,
        SUM(ep.MontoEjecutado) AS TotalEjecutado,
        SUM(ep.MontoPlaneado - ep.MontoEjecutado) AS DiferenciaTotal,
        AVG(CASE 
            WHEN ep.MontoPlaneado > 0 
            THEN (ep.MontoEjecutado / ep.MontoPlaneado) * 100 
            ELSE 0 
        END) AS PorcentajeEjecucionPromedio
    FROM EjecucionPresupuesto ep
    WHERE (@Anio IS NULL OR ep.Anio = @Anio)
    GROUP BY ep.Anio
    ORDER BY ep.Anio DESC;
END
GO

-- =============================================
-- SCRIPT DE PRUEBA
-- =============================================
/*
-- Listar todas las ejecuciones
EXEC SPEjecucionPresupuestoDetalle;

-- Crear nueva ejecución
EXEC SPEjecucionPresupuestoGuardar 
    @Id = NULL, 
    @IdPresupuesto = 1, 
    @Anio = 2025, 
    @MontoPlaneado = 5000000, 
    @MontoEjecutado = 3000000,
    @Observaciones = 'Ejecución del primer trimestre';

-- Actualizar ejecución existente
EXEC SPEjecucionPresupuestoGuardar 
    @Id = 1, 
    @IdPresupuesto = 1, 
    @Anio = 2025, 
    @MontoPlaneado = 5000000, 
    @MontoEjecutado = 4000000,
    @Observaciones = 'Ejecución actualizada';

-- Consultar por presupuesto
EXEC SPEjecucionPresupuestoPorPresupuesto @IdPresupuesto = 1;

-- Consultar por año
EXEC SPEjecucionPresupuestoPorAnio @Anio = 2025;

-- Ver resumen general
EXEC SPEjecucionPresupuestoResumen;

-- Ver resumen de un año específico
EXEC SPEjecucionPresupuestoResumen @Anio = 2025;
*/
