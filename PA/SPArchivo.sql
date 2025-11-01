---SPArchivoDetalle
CREATE OR ALTER PROCEDURE [dbo].[SPArchivoDetalle]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        A.Id,
        A.IdUsuario,
        A.Ruta,
        A.Nombre,
        A.Tipo,
        A.Fecha,
        U.Email AS EmailUsuario
    FROM [dbo].[Archivo] A
    INNER JOIN [dbo].[Usuario] U ON A.IdUsuario = U.Id
    ORDER BY A.Fecha DESC;
END
go

---SPArchivoEliminar
CREATE OR ALTER PROCEDURE [dbo].[SPArchivoEliminar]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Archivo WHERE Id = @Id)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'El archivo no existe' AS Mensaje;
            RETURN;
        END;
        
        DELETE FROM Archivo WHERE Id = @Id;
        
        COMMIT TRANSACTION;
        SELECT 1 AS Resultado, 'Archivo eliminado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
go

---SPArchivoGuardar
CREATE OR ALTER PROCEDURE [dbo].[SPArchivoGuardar]
    @Id INT = NULL,
    @IdUsuario INT,
    @Ruta NVARCHAR(MAX),
    @Nombre NVARCHAR(255),
    @Tipo NVARCHAR(50) = NULL,
    @Fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Id = @IdUsuario)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'El usuario no existe' AS Mensaje;
            RETURN;
        END;
        
        IF @Id IS NULL OR @Id = 0
        BEGIN
            INSERT INTO Archivo (IdUsuario, Ruta, Nombre, Tipo, Fecha)
            VALUES (@IdUsuario, @Ruta, @Nombre, @Tipo, ISNULL(@Fecha, GETDATE()));
            
            DECLARE @IdNuevoArchivo INT = SCOPE_IDENTITY();
            COMMIT TRANSACTION;
            SELECT 1 AS Resultado, 'Archivo insertado correctamente' AS Mensaje, @IdNuevoArchivo AS Id;
        END
        ELSE
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Archivo WHERE Id = @Id)
            BEGIN
                ROLLBACK TRANSACTION;
                SELECT 0 AS Resultado, 'El archivo no existe' AS Mensaje;
                RETURN;
            END;
            
            UPDATE Archivo
            SET IdUsuario = @IdUsuario,
                Ruta = @Ruta,
                Nombre = @Nombre,
                Tipo = @Tipo,
                Fecha = ISNULL(@Fecha, Fecha)
            WHERE Id = @Id;
            
            COMMIT TRANSACTION;
            SELECT 1 AS Resultado, 'Archivo actualizado correctamente' AS Mensaje, @Id AS Id;
        END;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END;
go

