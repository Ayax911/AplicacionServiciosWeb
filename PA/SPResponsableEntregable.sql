---SPResponsableEntregableDetalle
CREATE OR ALTER PROCEDURE [dbo].[SPResponsableEntregableDetalle]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        RE.IdResponsable,
        RE.IdEntregable,
        RE.FechaAsociacion,
        R.Nombre AS NombreResponsable,
        TR.Titulo AS TipoResponsable,
        E.Titulo AS TituloEntregable,
        E.Codigo AS CodigoEntregable
    FROM [dbo].[Responsable_Entregable] RE
    INNER JOIN [dbo].[Responsable] R ON RE.IdResponsable = R.Id
    INNER JOIN [dbo].[TipoResponsable] TR ON R.IdTipoResponsable = TR.Id
    INNER JOIN [dbo].[Entregable] E ON RE.IdEntregable = E.Id
    ORDER BY RE.FechaAsociacion DESC;
END
go

---SPResponsableEntregableEliminar
CREATE OR ALTER PROCEDURE[dbo].[SPResponsableEntregableEliminar]
    @IdResponsable INT,
    @IdEntregable INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Responsable_Entregable WHERE IdResponsable = @IdResponsable AND IdEntregable = @IdEntregable)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'La relación no existe' AS Mensaje;
            RETURN;
        END;
        
        DELETE FROM Responsable_Entregable 
        WHERE IdResponsable = @IdResponsable AND IdEntregable = @IdEntregable;
        
        COMMIT TRANSACTION;
        SELECT 1 AS Resultado, 'Relación eliminada correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
go

---SPResponsableEntregableGuardar
CREATE OR ALTER PROCEDURE [dbo].[SPResponsableEntregableGuardar]
    @IdResponsable INT,
    @IdEntregable INT,
    @FechaAsociacion DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Responsable WHERE Id = @IdResponsable)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'El responsable no existe' AS Mensaje;
            RETURN;
        END;
        
        IF NOT EXISTS (SELECT 1 FROM Entregable WHERE Id = @IdEntregable)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'El entregable no existe' AS Mensaje;
            RETURN;
        END;
        
        IF EXISTS (SELECT 1 FROM Responsable_Entregable WHERE IdResponsable = @IdResponsable AND IdEntregable = @IdEntregable)
        BEGIN
            -- Actualizar fecha de asociación
            UPDATE Responsable_Entregable
            SET FechaAsociacion = ISNULL(@FechaAsociacion, GETDATE())
            WHERE IdResponsable = @IdResponsable AND IdEntregable = @IdEntregable;
            
            COMMIT TRANSACTION;
            SELECT 1 AS Resultado, 'Relación actualizada correctamente' AS Mensaje;
        END
        ELSE
        BEGIN
            -- Insertar nueva relación
            INSERT INTO Responsable_Entregable (IdResponsable, IdEntregable, FechaAsociacion)
            VALUES (@IdResponsable, @IdEntregable, ISNULL(@FechaAsociacion, GETDATE()));
            
            COMMIT TRANSACTION;
            SELECT 1 AS Resultado, 'Relación creada correctamente' AS Mensaje;
        END;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
go
