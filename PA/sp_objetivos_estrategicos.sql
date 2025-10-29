USE ProyectosNew;
GO

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS - OBJETIVOS ESTRATÉGICOS
-- =============================================

-- SP LISTAR: Obtener todos los objetivos estratégicos con información completa
CREATE OR ALTER PROCEDURE [dbo].[SPObjetivoEstrategicoDetalle]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        oe.Id,
        oe.IdVariable,
        ve.Titulo AS Variable,
        oe.Titulo,
        oe.Descripcion
    FROM ObjetivoEstrategico oe
    INNER JOIN VariableEstrategica ve ON oe.IdVariable = ve.Id
    ORDER BY ve.Titulo ASC, oe.Titulo ASC;
END
GO


-- SP LISTAR SIMPLE: Obtener lista básica de objetivos estratégicos
CREATE OR ALTER PROCEDURE [dbo].[SPObjetivoEstrategicoListar]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        Id,
        IdVariable,
        Titulo,
        Descripcion
    FROM ObjetivoEstrategico
    ORDER BY Titulo ASC;
END
GO


-- SP POR VARIABLE: Obtener objetivos de una variable estratégica específica
CREATE OR ALTER PROCEDURE [dbo].[SPObjetivoEstrategicoPorVariable]
    @IdVariable INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar que la variable existe
    IF NOT EXISTS (SELECT 1 FROM VariableEstrategica WHERE Id = @IdVariable)
    BEGIN
        RAISERROR('La Variable Estratégica especificada no existe.', 16, 1);
        RETURN;
    END
    
    SELECT 
        oe.Id,
        oe.IdVariable,
        ve.Titulo AS Variable,
        oe.Titulo,
        oe.Descripcion
    FROM ObjetivoEstrategico oe
    INNER JOIN VariableEstrategica ve ON oe.IdVariable = ve.Id
    WHERE oe.IdVariable = @IdVariable
    ORDER BY oe.Titulo ASC;
END
GO


-- SP CREAR: Insertar nuevo objetivo estratégico
CREATE OR ALTER PROCEDURE [dbo].[SPObjetivoEstrategicoCrear]
    @IdVariable INT,
    @Titulo NVARCHAR(255),
    @Descripcion NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que la variable estratégica exista
        IF NOT EXISTS (SELECT 1 FROM VariableEstrategica WHERE Id = @IdVariable)
        BEGIN
            RAISERROR('La Variable Estratégica especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validar que el título no esté vacío
        IF LTRIM(RTRIM(ISNULL(@Titulo, ''))) = ''
        BEGIN
            RAISERROR('El título no puede estar vacío.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validar que el título no exceda 255 caracteres
        IF LEN(@Titulo) > 255
        BEGIN
            RAISERROR('El título no debe exceder 255 caracteres.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Insertar el objetivo estratégico
        INSERT INTO ObjetivoEstrategico (IdVariable, Titulo, Descripcion)
        VALUES (@IdVariable, TRIM(@Titulo), ISNULL(@Descripcion, ''));
        
        DECLARE @NuevoId INT = SCOPE_IDENTITY();
        
        -- Retornar el nuevo registro completo
        SELECT 
            oe.Id,
            oe.IdVariable,
            ve.Titulo AS Variable,
            oe.Titulo,
            oe.Descripcion
        FROM ObjetivoEstrategico oe
        INNER JOIN VariableEstrategica ve ON oe.IdVariable = ve.Id
        WHERE oe.Id = @NuevoId;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO


-- SP ACTUALIZAR: Modificar objetivo estratégico
CREATE OR ALTER PROCEDURE [dbo].[SPObjetivoEstrategicoActualizar]
    @Id INT,
    @IdVariable INT,
    @Titulo NVARCHAR(255),
    @Descripcion NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que el objetivo estratégico exista
        IF NOT EXISTS (SELECT 1 FROM ObjetivoEstrategico WHERE Id = @Id)
        BEGIN
            RAISERROR('El Objetivo Estratégico especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validar que la variable estratégica exista
        IF NOT EXISTS (SELECT 1 FROM VariableEstrategica WHERE Id = @IdVariable)
        BEGIN
            RAISERROR('La Variable Estratégica especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validar que el título no esté vacío
        IF LTRIM(RTRIM(ISNULL(@Titulo, ''))) = ''
        BEGIN
            RAISERROR('El título no puede estar vacío.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validar que el título no exceda 255 caracteres
        IF LEN(@Titulo) > 255
        BEGIN
            RAISERROR('El título no debe exceder 255 caracteres.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Actualizar el objetivo estratégico
        UPDATE ObjetivoEstrategico
        SET 
            IdVariable = @IdVariable,
            Titulo = TRIM(@Titulo),
            Descripcion = ISNULL(@Descripcion, '')
        WHERE Id = @Id;
        
        -- Retornar el registro actualizado
        SELECT 
            oe.Id,
            oe.IdVariable,
            ve.Titulo AS Variable,
            oe.Titulo,
            oe.Descripcion
        FROM ObjetivoEstrategico oe
        INNER JOIN VariableEstrategica ve ON oe.IdVariable = ve.Id
        WHERE oe.Id = @Id;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO


-- SP ELIMINAR: Eliminar objetivo estratégico
CREATE OR ALTER PROCEDURE [dbo].[SPObjetivoEstrategicoEliminar]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validar que el objetivo estratégico exista
        IF NOT EXISTS (SELECT 1 FROM ObjetivoEstrategico WHERE Id = @Id)
        BEGIN
            RAISERROR('El Objetivo Estratégico especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validar si tiene metas estratégicas asociadas
        DECLARE @CantidadMetas INT;
        SELECT @CantidadMetas = COUNT(*) 
        FROM MetaEstrategica 
        WHERE IdObjetivo = @Id;
        
        IF @CantidadMetas > 0
        BEGIN
            DECLARE @MsgError NVARCHAR(200);
            SET @MsgError = 'No se puede eliminar. El Objetivo tiene ' + 
                           CAST(@CantidadMetas AS NVARCHAR(10)) + 
                           ' Meta(s) Estratégica(s) asociada(s).';
            RAISERROR(@MsgError, 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Guardar info antes de eliminar (para retornar)
        DECLARE @TituloEliminado NVARCHAR(255);
        SELECT @TituloEliminado = Titulo 
        FROM ObjetivoEstrategico 
        WHERE Id = @Id;
        
        -- Eliminar el objetivo estratégico
        DELETE FROM ObjetivoEstrategico
        WHERE Id = @Id;
        
        -- Retornar confirmación
        SELECT 
            @Id AS Id,
            @TituloEliminado AS TituloEliminado,
            'Objetivo Estratégico eliminado exitosamente.' AS Mensaje;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO


-- SP CONTAR: Obtener cantidad de objetivos
CREATE OR ALTER PROCEDURE [dbo].[SPObjetivoEstrategicoContar]
    @IdVariable INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @IdVariable IS NULL
    BEGIN
        SELECT COUNT(*) AS Total FROM ObjetivoEstrategico;
    END
    ELSE
    BEGIN
        -- Validar que la variable existe
        IF NOT EXISTS (SELECT 1 FROM VariableEstrategica WHERE Id = @IdVariable)
        BEGIN
            RAISERROR('La Variable Estratégica especificada no existe.', 16, 1);
            RETURN;
        END
        
        SELECT COUNT(*) AS Total 
        FROM ObjetivoEstrategico 
        WHERE IdVariable = @IdVariable;
    END
END
GO


-- SP RESUMEN: Obtener resumen de objetivos y metas
CREATE OR ALTER PROCEDURE [dbo].[SPObjetivoEstrategicoResumen]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ve.Id,
        ve.Titulo AS Variable,
        COUNT(DISTINCT oe.Id) AS TotalObjetivos,
        COUNT(DISTINCT me.Id) AS TotalMetas
    FROM VariableEstrategica ve
    LEFT JOIN ObjetivoEstrategico oe ON ve.Id = oe.IdVariable
    LEFT JOIN MetaEstrategica me ON oe.Id = me.IdObjetivo
    GROUP BY ve.Id, ve.Titulo
    ORDER BY ve.Titulo ASC;
END
GO

-- =============================================
-- SP DETALLE: Obtener proyectos con toda la información relacionada
-- =============================================
CREATE OR ALTER PROCEDURE SPProyectosTRDetalle
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Datos principales del proyecto
        p.Id,
        p.Codigo,
        p.Titulo,
        p.Descripcion,
        p.FechaInicio,
        p.FechaFinPrevista,
        p.FechaFinalizacion,
        p.IdTipoProyecto,
        p.IdResponsable,
        p.IdProyectoPadre,
        p.RutaLogo,
        
        -- Estado (puedes ajustar la lógica según tus necesidades)
        CASE 
            WHEN p.FechaFinalizacion IS NOT NULL THEN 'Finalizado'
            WHEN p.FechaFinPrevista < GETDATE() AND p.FechaFinalizacion IS NULL THEN 'Retrasado'
            WHEN p.FechaInicio <= GETDATE() AND p.FechaFinalizacion IS NULL THEN 'En Progreso'
            ELSE 'Planificado'
        END AS Estado,
        
        CASE 
            WHEN p.FechaFinalizacion IS NOT NULL THEN 'Proyecto completado'
            WHEN p.FechaFinPrevista < GETDATE() AND p.FechaFinalizacion IS NULL THEN 'Proyecto con retraso'
            WHEN p.FechaInicio <= GETDATE() AND p.FechaFinalizacion IS NULL THEN 'Proyecto en ejecución'
            ELSE 'Proyecto por iniciar'
        END AS DescripcionEstado,
        
        -- Datos del Responsable
        r.Nombre AS Responsable,
        
        -- Datos del Tipo de Proyecto
        tp.Nombre AS TipoProyecto,
        tp.Descripcion AS DescripcionTipoProyecto,
        
        -- Datos del Proyecto Padre (si existe)
        pp.Titulo AS ProyectoPadre,
        pp.Codigo AS CodigoProyectoPadre
        
    FROM Proyecto p
    LEFT JOIN Responsable r ON p.IdResponsable = r.Id
    LEFT JOIN TipoProyecto tp ON p.IdTipoProyecto = tp.Id
    LEFT JOIN Proyecto pp ON p.IdProyectoPadre = pp.Id
    
    ORDER BY p.FechaInicio DESC, p.Titulo;
END
GO