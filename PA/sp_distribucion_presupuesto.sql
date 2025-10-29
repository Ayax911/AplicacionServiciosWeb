-- =============================================
-- STORED PROCEDURES - PRESUPUESTO
-- =============================================

-- =============================================
-- 1. SP DETALLE: Obtener todos los presupuestos
-- =============================================
CREATE OR ALTER PROCEDURE SPPresupuestoDetalle
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.Id,
        p.IdProyecto,
        p.MontoSolicitado,
        p.Estado,
        p.MontoAprobado,
        p.PeriodoAnio,
        p.FechaSolicitud,
        p.FechaAprobacion,
        p.Observaciones,
        
        -- Información del Proyecto
        pr.Codigo AS CodigoProyecto,
        pr.Titulo AS TituloProyecto,
        r.Nombre AS ResponsableProyecto
        
    FROM Presupuesto p
    LEFT JOIN Proyecto pr ON p.IdProyecto = pr.Id
    LEFT JOIN Responsable r ON pr.IdResponsable = r.Id
    
    ORDER BY p.PeriodoAnio DESC, p.FechaSolicitud DESC;
END
GO

-- =============================================
-- 2. SP GUARDAR: Crear o actualizar presupuesto
-- =============================================
CREATE OR ALTER PROCEDURE SPPresupuestoGuardar
    @Id INT = NULL,
    @IdProyecto INT,
    @MontoSolicitado DECIMAL(18,2),
    @Estado NVARCHAR(50),
    @MontoAprobado DECIMAL(18,2) = NULL,
    @PeriodoAnio INT,
    @FechaSolicitud DATETIME = NULL,
    @FechaAprobacion DATETIME = NULL,
    @Observaciones NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar que existe el proyecto
    IF NOT EXISTS (SELECT 1 FROM Proyecto WHERE Id = @IdProyecto)
    BEGIN
        RAISERROR('El proyecto especificado no existe.', 16, 1);
        RETURN;
    END

    -- Si no se proporciona fecha de solicitud, usar la actual
    IF @FechaSolicitud IS NULL
        SET @FechaSolicitud = GETDATE();

    -- Validar que el periodo sea válido
    IF @PeriodoAnio < 2000 OR @PeriodoAnio > 2100
    BEGIN
        RAISERROR('El periodo debe estar entre 2000 y 2100.', 16, 1);
        RETURN;
    END

    -- Actualizar o insertar
    IF @Id IS NOT NULL AND @Id > 0
    BEGIN
        -- Verificar que existe el registro
        IF NOT EXISTS (SELECT 1 FROM Presupuesto WHERE Id = @Id)
        BEGIN
            RAISERROR('El presupuesto especificado no existe.', 16, 1);
            RETURN;
        END

        -- ACTUALIZAR
        UPDATE Presupuesto
        SET 
            IdProyecto = @IdProyecto,
            MontoSolicitado = @MontoSolicitado,
            Estado = @Estado,
            MontoAprobado = @MontoAprobado,
            PeriodoAnio = @PeriodoAnio,
            FechaSolicitud = @FechaSolicitud,
            FechaAprobacion = @FechaAprobacion,
            Observaciones = @Observaciones
        WHERE Id = @Id;

        SELECT 'Presupuesto actualizado correctamente' AS Mensaje;
    END
    ELSE
    BEGIN
        -- INSERTAR
        INSERT INTO Presupuesto (
            IdProyecto, MontoSolicitado, Estado, MontoAprobado, 
            PeriodoAnio, FechaSolicitud, FechaAprobacion, Observaciones
        )
        VALUES (
            @IdProyecto, @MontoSolicitado, @Estado, @MontoAprobado,
            @PeriodoAnio, @FechaSolicitud, @FechaAprobacion, @Observaciones
        );

        SELECT 'Presupuesto creado correctamente' AS Mensaje;
    END
END
GO

-- =============================================
-- 3. SP POR PROYECTO: Obtener presupuestos de un proyecto
-- =============================================
CREATE OR ALTER PROCEDURE SPPresupuestoPorProyecto
    @IdProyecto INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.Id,
        p.IdProyecto,
        p.MontoSolicitado,
        p.Estado,
        p.MontoAprobado,
        p.PeriodoAnio,
        p.FechaSolicitud,
        p.FechaAprobacion,
        p.Observaciones,
        pr.Codigo AS CodigoProyecto,
        pr.Titulo AS TituloProyecto,
        r.Nombre AS ResponsableProyecto
    FROM Presupuesto p
    LEFT JOIN Proyecto pr ON p.IdProyecto = pr.Id
    LEFT JOIN Responsable r ON pr.IdResponsable = r.Id
    WHERE p.IdProyecto = @IdProyecto
    ORDER BY p.PeriodoAnio DESC;
END
GO

-- =============================================
-- STORED PROCEDURES - DISTRIBUCION PRESUPUESTO
-- =============================================

-- =============================================
-- 1. SP DETALLE: Obtener todas las distribuciones
-- =============================================
CREATE OR ALTER PROCEDURE SPDistribucionPresupuestoDetalle
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        dp.Id,
        dp.IdPresupuestoPadre,
        dp.IdProyectoHijo,
        dp.MontoAsignado
    FROM DistribucionPresupuesto dp
    ORDER BY dp.IdPresupuestoPadre, dp.IdProyectoHijo;
END
GO

-- =============================================
-- 2. SP CREAR: Crear nueva distribución
-- =============================================
CREATE OR ALTER PROCEDURE SPDistribucionPresupuestoCrear
    @IdPresupuestoPadre INT,
    @IdProyectoHijo INT,
    @MontoAsignado DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que existe el presupuesto padre
    IF NOT EXISTS (SELECT 1 FROM Presupuesto WHERE Id = @IdPresupuestoPadre)
    BEGIN
        RAISERROR('El presupuesto padre especificado no existe.', 16, 1);
        RETURN;
    END

    -- Validar que existe el proyecto hijo
    IF NOT EXISTS (SELECT 1 FROM Proyecto WHERE Id = @IdProyectoHijo)
    BEGIN
        RAISERROR('El proyecto hijo especificado no existe.', 16, 1);
        RETURN;
    END

    -- Validar que el monto sea positivo
    IF @MontoAsignado <= 0
    BEGIN
        RAISERROR('El monto asignado debe ser mayor a cero.', 16, 1);
        RETURN;
    END

    -- Validar que no exista duplicado
    IF EXISTS (SELECT 1 FROM DistribucionPresupuesto 
               WHERE IdPresupuestoPadre = @IdPresupuestoPadre 
               AND IdProyectoHijo = @IdProyectoHijo)
    BEGIN
        RAISERROR('Ya existe una distribución entre este presupuesto y este proyecto.', 16, 1);
        RETURN;
    END

    -- Insertar la distribución
    INSERT INTO DistribucionPresupuesto (IdPresupuestoPadre, IdProyectoHijo, MontoAsignado)
    VALUES (@IdPresupuestoPadre, @IdProyectoHijo, @MontoAsignado);

    -- Retornar la distribución creada
    SELECT 
        dp.Id,
        dp.IdPresupuestoPadre,
        dp.IdProyectoHijo,
        dp.MontoAsignado
    FROM DistribucionPresupuesto dp
    WHERE dp.IdPresupuestoPadre = @IdPresupuestoPadre 
    AND dp.IdProyectoHijo = @IdProyectoHijo;
END
GO

-- =============================================
-- 3. SP ACTUALIZAR: Modificar monto asignado
-- =============================================
CREATE OR ALTER PROCEDURE SPDistribucionPresupuestoActualizar
    @Id INT,
    @MontoAsignado DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que existe la distribución
    IF NOT EXISTS (SELECT 1 FROM DistribucionPresupuesto WHERE Id = @Id)
    BEGIN
        RAISERROR('La distribución especificada no existe.', 16, 1);
        RETURN;
    END

    -- Validar que el monto sea positivo
    IF @MontoAsignado <= 0
    BEGIN
        RAISERROR('El monto asignado debe ser mayor a cero.', 16, 1);
        RETURN;
    END

    -- Actualizar el monto
    UPDATE DistribucionPresupuesto
    SET MontoAsignado = @MontoAsignado
    WHERE Id = @Id;

    -- Retornar la distribución actualizada
    SELECT 
        dp.Id,
        dp.IdPresupuestoPadre,
        dp.IdProyectoHijo,
        dp.MontoAsignado
    FROM DistribucionPresupuesto dp
    WHERE dp.Id = @Id;
END
GO

-- =============================================
-- 4. SP ELIMINAR: Eliminar una distribución
-- =============================================
CREATE OR ALTER PROCEDURE SPDistribucionPresupuestoEliminar
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que existe la distribución
    IF NOT EXISTS (SELECT 1 FROM DistribucionPresupuesto WHERE Id = @Id)
    BEGIN
        RAISERROR('La distribución especificada no existe.', 16, 1);
        RETURN;
    END

    -- Eliminar la distribución
    DELETE FROM DistribucionPresupuesto
    WHERE Id = @Id;

    -- Retornar confirmación
    SELECT 'Distribución eliminada correctamente' AS Mensaje;
END
GO

-- =============================================
-- 5. SP POR PRESUPUESTO: Distribuciones de un presupuesto
-- =============================================
CREATE OR ALTER PROCEDURE SPDistribucionPresupuestoPorPresupuesto
    @IdPresupuestoPadre INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        dp.Id,
        dp.IdPresupuestoPadre,
        dp.IdProyectoHijo,
        dp.MontoAsignado
    FROM DistribucionPresupuesto dp
    WHERE dp.IdPresupuestoPadre = @IdPresupuestoPadre
    ORDER BY dp.IdProyectoHijo;
END
GO

-- =============================================
-- 6. SP POR PROYECTO HIJO: Distribuciones a un proyecto
-- =============================================
CREATE OR ALTER PROCEDURE SPDistribucionPresupuestoPorProyectoHijo
    @IdProyectoHijo INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        dp.Id,
        dp.IdPresupuestoPadre,
        dp.IdProyectoHijo,
        dp.MontoAsignado
    FROM DistribucionPresupuesto dp
    WHERE dp.IdProyectoHijo = @IdProyectoHijo
    ORDER BY dp.IdPresupuestoPadre;
END
GO

-- =============================================
-- 7. SP ELIMINAR POR PRESUPUESTO: Eliminar todas las distribuciones
-- =============================================
CREATE OR ALTER PROCEDURE SPDistribucionPresupuestoEliminarPorPresupuesto
    @IdPresupuestoPadre INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CantidadEliminada INT;

    -- Eliminar todas las distribuciones del presupuesto
    DELETE FROM DistribucionPresupuesto
    WHERE IdPresupuestoPadre = @IdPresupuestoPadre;

    SET @CantidadEliminada = @@ROWCOUNT;

    -- Retornar confirmación
    SELECT 
        @CantidadEliminada AS CantidadEliminada,
        'Distribuciones eliminadas correctamente' AS Mensaje;
END
GO

-- =============================================
-- TABLAS NECESARIAS (si no existen)
-- =============================================
/*
-- Tabla Presupuesto
CREATE TABLE Presupuesto (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdProyecto INT NOT NULL,
    MontoSolicitado DECIMAL(18,2) NOT NULL CHECK (MontoSolicitado >= 0),
    Estado NVARCHAR(50) NOT NULL,
    MontoAprobado DECIMAL(18,2) NULL CHECK (MontoAprobado >= 0),
    PeriodoAnio INT NOT NULL,
    FechaSolicitud DATETIME NOT NULL DEFAULT GETDATE(),
    FechaAprobacion DATETIME NULL,
    Observaciones NVARCHAR(MAX) NULL,
    
    CONSTRAINT FK_Presupuesto_Proyecto FOREIGN KEY (IdProyecto) 
        REFERENCES Proyecto(Id)
);

-- Tabla DistribucionPresupuesto
CREATE TABLE DistribucionPresupuesto (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdPresupuestoPadre INT NOT NULL,
    IdProyectoHijo INT NOT NULL,
    MontoAsignado DECIMAL(18,2) NOT NULL CHECK (MontoAsignado > 0),
    
    CONSTRAINT FK_DistribucionPresupuesto_Presupuesto 
        FOREIGN KEY (IdPresupuestoPadre) REFERENCES Presupuesto(Id),
    CONSTRAINT FK_DistribucionPresupuesto_ProyectoHijo 
        FOREIGN KEY (IdProyectoHijo) REFERENCES Proyecto(Id),
    CONSTRAINT UK_DistribucionPresupuesto_Presupuesto_Proyecto 
        UNIQUE (IdPresupuestoPadre, IdProyectoHijo)
);

-- Índices
CREATE INDEX IX_Presupuesto_IdProyecto ON Presupuesto(IdProyecto);
CREATE INDEX IX_Presupuesto_PeriodoAnio ON Presupuesto(PeriodoAnio);
CREATE INDEX IX_DistribucionPresupuesto_IdPresupuestoPadre 
    ON DistribucionPresupuesto(IdPresupuestoPadre);
CREATE INDEX IX_DistribucionPresupuesto_IdProyectoHijo 
    ON DistribucionPresupuesto(IdProyectoHijo);
*/

-- =============================================
-- SCRIPT DE PRUEBA
-- =============================================
/*
-- Crear presupuestos
EXEC SPPresupuestoGuardar 
    @Id = NULL, 
    @IdProyecto = 1, 
    @MontoSolicitado = 10000000, 
    @Estado = 'Aprobado',
    @MontoAprobado = 9500000,
    @PeriodoAnio = 2025,
    @FechaSolicitud = '2025-01-15',
    @FechaAprobacion = '2025-02-01',
    @Observaciones = 'Presupuesto aprobado con reducción del 5%';

-- Crear distribución
EXEC SPDistribucionPresupuestoCrear 
    @IdPresupuestoPadre = 1, 
    @IdProyectoHijo = 2, 
    @MontoAsignado = 3000000;

-- Listar distribuciones
EXEC SPDistribucionPresupuestoDetalle;

-- Actualizar monto de distribución
EXEC SPDistribucionPresupuestoActualizar 
    @Id = 1, 
    @MontoAsignado = 3500000;

-- Consultar por presupuesto
EXEC SPDistribucionPresupuestoPorPresupuesto @IdPresupuestoPadre = 1;

-- Eliminar distribución
EXEC SPDistribucionPresupuestoEliminar @Id = 1;
*/
