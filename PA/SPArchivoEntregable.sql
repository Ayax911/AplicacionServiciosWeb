---SPArchivoEntregableDetalle
CREATE OR ALTER PROCEDURE [dbo].[SPArchivoEntregableDetalle]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        AE.IdArchivo,
        AE.IdEntregable,
        A.Nombre AS NombreArchivo,
        A.Tipo AS TipoArchivo,
        A.Fecha AS FechaArchivo,
        E.Titulo AS TituloEntregable,
        E.Codigo AS CodigoEntregable
    FROM [dbo].[Archivo_Entregable] AE
    INNER JOIN [dbo].[Archivo] A ON AE.IdArchivo = A.Id
    INNER JOIN [dbo].[Entregable] E ON AE.IdEntregable = E.Id
    ORDER BY A.Fecha DESC;
END
go

---SPArchivoEntregableEliminar
CREATE OR ALTER PROCEDURE [dbo].[SPArchivoEntregableEliminar]
    @IdArchivo INT,
    @IdEntregable INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Archivo_Entregable WHERE IdArchivo = @IdArchivo AND IdEntregable = @IdEntregable)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'La relación no existe' AS Mensaje;
            RETURN;
        END;
        
        DELETE FROM Archivo_Entregable 
        WHERE IdArchivo = @IdArchivo AND IdEntregable = @IdEntregable;
        
        COMMIT TRANSACTION;
        SELECT 1 AS Resultado, 'Relación eliminada correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
go

---SPArchivoEntregableGuardar
CREATE OR ALTER PROCEDURE [dbo].[SPArchivoEntregableGuardar]
    @IdArchivo INT,
    @IdEntregable INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Archivo WHERE Id = @IdArchivo)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'El archivo no existe' AS Mensaje;
            RETURN;
        END;
        
        IF NOT EXISTS (SELECT 1 FROM Entregable WHERE Id = @IdEntregable)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'El entregable no existe' AS Mensaje;
            RETURN;
        END;
        
        IF EXISTS (SELECT 1 FROM Archivo_Entregable WHERE IdArchivo = @IdArchivo AND IdEntregable = @IdEntregable)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'La relación ya existe' AS Mensaje;
            RETURN;
        END;
        
        INSERT INTO Archivo_Entregable (IdArchivo, IdEntregable)
        VALUES (@IdArchivo, @IdEntregable);
        
        COMMIT TRANSACTION;
        SELECT 1 AS Resultado, 'Relación creada correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
go