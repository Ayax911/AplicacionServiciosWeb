--Procedimientos almacenados - Actividad
--SPActividadDetalle
CREATE OR ALTER   PROCEDURE [dbo].[SPActividadDetalle]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        A.Id,
        A.IdEntregable,
        A.Titulo,
        A.Descripcion,
        A.FechaInicio,
        A.FechaFinPrevista,
        A.FechaModificacion,
        A.FechaFinalizacion,
        A.Prioridad,
        A.PorcentajeAvance,
        -- Campos del Entregable
        E.Titulo AS TituloEntregable,
        E.Codigo AS CodigoEntregable
    FROM 
        [dbo].[Actividad] A
    INNER JOIN 
        [dbo].[Entregable] E ON A.IdEntregable = E.Id
    ORDER BY 
        A.FechaInicio DESC;
END
go

---SPActividadEliminar
CREATE OR ALTER PROCEDURE [dbo].[SPActividadEliminar]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Verificar si existe
        IF NOT EXISTS (SELECT 1 FROM Actividad WHERE Id = @Id)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'La actividad no existe' AS Mensaje;
            RETURN;
        END;
        
        -- Eliminar
        DELETE FROM Actividad WHERE Id = @Id;
        
        COMMIT TRANSACTION;
        SELECT 1 AS Resultado, 'Actividad eliminada correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
go
---SPActividadGuardar
CREATE OR ALTER PROCEDURE [dbo].[SPActividadGuardar]
    @Id INT = NULL,
    @IdEntregable INT,
    @Titulo NVARCHAR(255),
    @Descripcion NVARCHAR(MAX) = NULL,
    @FechaInicio DATE = NULL,
    @FechaFinPrevista DATE = NULL,
    @Prioridad INT = NULL,
    @PorcentajeAvance INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Entregable WHERE Id = @IdEntregable)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT -1 AS Id, 'El entregable no existe' AS Mensaje;
            RETURN;
        END;

        IF @Id IS NULL OR @Id = 0
        BEGIN
            INSERT INTO Actividad (IdEntregable, Titulo, Descripcion, FechaInicio, FechaFinPrevista, FechaModificacion, Prioridad, PorcentajeAvance)
            VALUES (@IdEntregable, @Titulo, @Descripcion, @FechaInicio, @FechaFinPrevista, GETDATE(), @Prioridad, @PorcentajeAvance);

            DECLARE @IdNuevo INT = SCOPE_IDENTITY();
            COMMIT TRANSACTION;
            SELECT @IdNuevo AS Id, 'Actividad insertada correctamente' AS Mensaje;
        END
        ELSE
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Actividad WHERE Id = @Id)
            BEGIN
                ROLLBACK TRANSACTION;
                SELECT -1 AS Id, 'La actividad no existe' AS Mensaje;
                RETURN;
            END;

            UPDATE Actividad
            SET Titulo = @Titulo,
                Descripcion = @Descripcion,
                FechaInicio = @FechaInicio,
                FechaFinPrevista = @FechaFinPrevista,
                FechaModificacion = GETDATE(),
                Prioridad = @Prioridad,
                PorcentajeAvance = @PorcentajeAvance
            WHERE Id = @Id;

            COMMIT TRANSACTION;
            SELECT @Id AS Id, 'Actividad actualizada correctamente' AS Mensaje;
        END;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT -1 AS Id, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
go