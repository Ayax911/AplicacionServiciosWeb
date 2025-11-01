---SPPresupuestoDetalle
CREATE OR ALTER PROCEDURE [dbo].[SPPresupuestoDetalle]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        P.Id,
        P.IdProyecto,
        P.MontoSolicitado,
        P.Estado,
        P.MontoAprobado,
        P.PeriodoAnio,
        P.FechaSolicitud,
        P.FechaAprobacion,
        P.Observaciones,
        PR.Titulo AS TituloProyecto,
        PR.Codigo AS CodigoProyecto
    FROM [dbo].[Presupuesto] P
    INNER JOIN [dbo].[Proyecto] PR ON P.IdProyecto = PR.Id
    ORDER BY P.FechaSolicitud DESC;
END
go

---SPPresupuestoEliminar
CREATE OR ALTER PROCEDURE [dbo].[SPPresupuestoEliminar]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Presupuesto WHERE Id = @Id)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'El presupuesto no existe' AS Mensaje;
            RETURN;
        END;
        
        DELETE FROM Presupuesto WHERE Id = @Id;
        
        COMMIT TRANSACTION;
        SELECT 1 AS Resultado, 'Presupuesto eliminado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
go

---SPPresupuestoGuardar
CREATE OR ALTER PROCEDURE[dbo].[SPPresupuestoGuardar]
    @Id INT = NULL,
    @IdProyecto INT,
    @MontoSolicitado DECIMAL(15,2),
    @Estado NVARCHAR(20) = 'Pendiente',
    @MontoAprobado DECIMAL(15,2) = NULL,
    @PeriodoAnio INT = NULL,
    @FechaSolicitud DATE = NULL,
    @FechaAprobacion DATE = NULL,
    @Observaciones NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Proyecto WHERE Id = @IdProyecto)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'El proyecto no existe' AS Mensaje;
            RETURN;
        END;
        
        IF @Estado NOT IN ('Pendiente', 'Aprobado', 'Rechazado')
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'Estado inválido. Debe ser: Pendiente, Aprobado o Rechazado' AS Mensaje;
            RETURN;
        END;
        
        IF @Id IS NULL OR @Id = 0
        BEGIN
            INSERT INTO Presupuesto (IdProyecto, MontoSolicitado, Estado, MontoAprobado, PeriodoAnio, FechaSolicitud, FechaAprobacion, Observaciones)
            VALUES (@IdProyecto, @MontoSolicitado, @Estado, @MontoAprobado, @PeriodoAnio, ISNULL(@FechaSolicitud, GETDATE()), @FechaAprobacion, @Observaciones);
            
            DECLARE @IdNuevoPresupuesto INT = SCOPE_IDENTITY();
            COMMIT TRANSACTION;
            SELECT 1 AS Resultado, 'Presupuesto insertado correctamente' AS Mensaje, @IdNuevoPresupuesto AS Id;
        END
        ELSE
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Presupuesto WHERE Id = @Id)
            BEGIN
                ROLLBACK TRANSACTION;
                SELECT 0 AS Resultado, 'El presupuesto no existe' AS Mensaje;
                RETURN;
            END;
            
            UPDATE Presupuesto
            SET IdProyecto = @IdProyecto,
                MontoSolicitado = @MontoSolicitado,
                Estado = @Estado,
                MontoAprobado = @MontoAprobado,
                PeriodoAnio = @PeriodoAnio,
                FechaSolicitud = ISNULL(@FechaSolicitud, FechaSolicitud),
                FechaAprobacion = @FechaAprobacion,
                Observaciones = @Observaciones
            WHERE Id = @Id;
            
            COMMIT TRANSACTION;
            SELECT 1 AS Resultado, 'Presupuesto actualizado correctamente' AS Mensaje, @Id AS Id;
        END;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
go