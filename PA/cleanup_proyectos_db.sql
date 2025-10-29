-- =============================================
-- SCRIPT DE LIMPIEZA TOTAL - ProyectosNew
-- Borra todas las tablas y reinicia los contadores de identidad
-- =============================================

USE ProyectosNew;
GO

-- =============================================
-- DESHABILITAR RESTRICCIONES DE INTEGRIDAD REFERENCIAL
-- =============================================
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

-- =============================================
-- ELIMINAR TODOS LOS DATOS (sin eliminar tablas)
-- =============================================
EXEC sp_MSForEachTable 'DELETE FROM ?';
GO

-- =============================================
-- REINICIAR CONTADORES DE IDENTIDAD
-- =============================================

-- Tablas de base estratégica
DBCC CHECKIDENT ('VariableEstrategica', RESEED, 0);
DBCC CHECKIDENT ('ObjetivoEstrategico', RESEED, 0);
DBCC CHECKIDENT ('MetaEstrategica', RESEED, 0);

-- Tablas de usuario y roles
DBCC CHECKIDENT ('Usuario', RESEED, 0);
DBCC CHECKIDENT ('TipoResponsable', RESEED, 0);
DBCC CHECKIDENT ('Responsable', RESEED, 0);

-- Tablas de proyectos
DBCC CHECKIDENT ('TipoProyecto', RESEED, 0);
DBCC CHECKIDENT ('Proyecto', RESEED, 0);

-- Tablas de presupuesto
DBCC CHECKIDENT ('Presupuesto', RESEED, 0);
DBCC CHECKIDENT ('DistribucionPresupuesto', RESEED, 0);
DBCC CHECKIDENT ('EjecucionPresupuesto', RESEED, 0);

-- Tablas de estados
DBCC CHECKIDENT ('Estado', RESEED, 0);

-- Tablas de entregables
DBCC CHECKIDENT ('Entregable', RESEED, 0);
DBCC CHECKIDENT ('Actividad', RESEED, 0);
DBCC CHECKIDENT ('Archivo', RESEED, 0);

-- Tablas de productos
DBCC CHECKIDENT ('TipoProducto', RESEED, 0);
DBCC CHECKIDENT ('Producto', RESEED, 0);

GO

-- =============================================
-- REABILITAR RESTRICCIONES DE INTEGRIDAD REFERENCIAL
-- =============================================
EXEC sp_MSForEachTable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

-- =============================================
-- CONFIRMACIÓN
-- =============================================
PRINT '✅ Base de datos limpiada completamente';
PRINT '✅ Todos los contadores de identidad reiniciados a 0';
PRINT '✅ Restricciones de integridad rehabilitadas';
PRINT '';
PRINT 'Ahora puedes ejecutar el script de datos de prueba sin errores.';
GO
