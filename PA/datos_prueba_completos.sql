-- =============================================
-- DATOS DE PRUEBA COMPLETOS - ProyectoNew
-- =============================================

USE Proyectos;
GO

PRINT '============================================';
PRINT 'INICIANDO INSERCIÓN DE DATOS DE PRUEBA';
PRINT '============================================';

-- =============================================
-- 1. VARIABLES ESTRATÉGICAS
-- =============================================
PRINT 'Insertando Variables Estratégicas...';
SET IDENTITY_INSERT VariableEstrategica ON;
INSERT INTO VariableEstrategica (Id, Titulo, Descripcion) VALUES
(1, 'Crecimiento Sostenible', 'Enfoque en expansión con responsabilidad social y ambiental'),
(2, 'Innovación Tecnológica', 'Adopción de nuevas tecnologías para mejora continua'),
(3, 'Excelencia Operacional', 'Optimización de procesos y eficiencia organizacional'),
(4, 'Desarrollo Humano', 'Fortalecimiento del talento y capacidades del equipo');
SET IDENTITY_INSERT VariableEstrategica OFF;


-- =============================================
-- 2. OBJETIVOS ESTRATÉGICOS
-- =============================================
PRINT 'Insertando Objetivos Estratégicos...';
SET IDENTITY_INSERT ObjetivoEstrategico ON;
INSERT INTO ObjetivoEstrategico (Id, IdVariable, Titulo, Descripcion) VALUES
(1, 1, 'Expandir presencia en mercados regionales', 'Aumentar la cobertura geográfica en América Latina'),
(2, 1, 'Incrementar rentabilidad operativa', 'Mejorar márgenes de utilidad en un 15%'),
(3, 2, 'Transformación digital organizacional', 'Digitalizar el 80% de los procesos internos'),
(4, 2, 'Implementar inteligencia artificial', 'Integrar IA en procesos de toma de decisiones'),
(5, 3, 'Optimizar cadena de suministro', 'Reducir tiempos de entrega en un 30%'),
(6, 4, 'Desarrollar programa de liderazgo', 'Formar 50 líderes en metodologías ágiles');
SET IDENTITY_INSERT ObjetivoEstrategico OFF;


-- =============================================
-- 3. METAS ESTRATÉGICAS
-- =============================================
PRINT 'Insertando Metas Estratégicas...';
SET IDENTITY_INSERT MetaEstrategica ON;
INSERT INTO MetaEstrategica (Id, IdObjetivo, Titulo, Descripcion) VALUES
(1, 1, 'Abrir 5 nuevas oficinas regionales', 'Establecer presencia en Colombia, Perú, Chile, Argentina y México'),
(2, 2, 'Aumentar ventas en 20%', 'Incrementar ingresos anuales en 20% respecto al año anterior'),
(3, 3, 'Implementar ERP empresarial', 'Desplegar sistema ERP en todas las áreas de la organización'),
(4, 3, 'Migrar a la nube', 'Trasladar el 90% de infraestructura a servicios cloud'),
(5, 4, 'Desarrollar chatbot inteligente', 'Crear asistente virtual con procesamiento de lenguaje natural'),
(6, 5, 'Automatizar procesos logísticos', 'Implementar RPA en operaciones de almacén y distribución'),
(7, 6, 'Certificar equipo en Scrum', 'Lograr certificación PSM para 40 colaboradores');
SET IDENTITY_INSERT MetaEstrategica OFF;


-- =============================================
-- 4. USUARIOS
-- =============================================
PRINT 'Insertando Usuarios...';
SET IDENTITY_INSERT Usuario ON;
INSERT INTO Usuario (Id, Email, Contrasena, RutaAvatar, Activo) VALUES
(1, 'admin@proyectos.com', 'Admin123!', 'https://i.pravatar.cc/150?img=1', 1),
(2, 'jgarcia@proyectos.com', 'Pass123!', 'https://i.pravatar.cc/150?img=2', 1),
(3, 'mrodriguez@proyectos.com', 'Pass123!', 'https://i.pravatar.cc/150?img=3', 1),
(4, 'lmartinez@proyectos.com', 'Pass123!', 'https://i.pravatar.cc/150?img=4', 1),
(5, 'ahernandez@proyectos.com', 'Pass123!', 'https://i.pravatar.cc/150?img=5', 1),
(6, 'clopez@proyectos.com', 'Pass123!', 'https://i.pravatar.cc/150?img=6', 1);
SET IDENTITY_INSERT Usuario OFF;


-- =============================================
-- 5. TIPOS DE RESPONSABLE
-- =============================================
PRINT 'Insertando Tipos de Responsable...';
SET IDENTITY_INSERT TipoResponsable ON;
INSERT INTO TipoResponsable (Id, Titulo, Descripcion) VALUES
(1, 'Gerente de Proyecto', 'Responsable principal del proyecto'),
(2, 'Coordinador', 'Coordinador de actividades y recursos'),
(3, 'Director', 'Director de área o departamento'),
(4, 'Líder Técnico', 'Líder técnico especializado');
SET IDENTITY_INSERT TipoResponsable OFF;


-- =============================================
-- 6. RESPONSABLES
-- =============================================
PRINT 'Insertando Responsables...';
SET IDENTITY_INSERT Responsable ON;
INSERT INTO Responsable (Id, IdTipoResponsable, IdUsuario, Nombre) VALUES
(1, 3, 1, 'Juan García Pérez'),
(2, 1, 2, 'María Rodríguez López'),
(3, 1, 3, 'Luis Martínez Gómez'),
(4, 2, 4, 'Ana Hernández Silva'),
(5, 4, 5, 'Carlos López Díaz'),
(6, 1, 6, 'Carmen Torres Ruiz');


-- =============================================
-- 7. TIPOS DE PROYECTO
-- =============================================
PRINT 'Insertando Tipos de Proyecto...';
SET IDENTITY_INSERT TipoProyecto ON;
INSERT INTO TipoProyecto (Id, Nombre, Descripcion) VALUES
(1, 'Desarrollo de Software', 'Proyectos de desarrollo de aplicaciones y sistemas'),
(2, 'Infraestructura TI', 'Proyectos de infraestructura tecnológica'),
(3, 'Investigación y Desarrollo', 'Proyectos de investigación e innovación'),
(4, 'Marketing Digital', 'Proyectos de marketing y comunicación'),
(5, 'Capacitación', 'Proyectos de formación y desarrollo'),
(6, 'Transformación Digital', 'Proyectos de cambio organizacional');
SET IDENTITY_INSERT TipoProyecto OFF;


-- =============================================
-- 8. PROYECTOS
-- =============================================
PRINT 'Insertando Proyectos...';
SET IDENTITY_INSERT Proyecto ON;
INSERT INTO Proyecto (Id, IdProyectoPadre, IdResponsable, IdTipoProyecto, Codigo, Titulo, Descripcion, FechaInicio, FechaFinPrevista, FechaFinalizacion, RutaLogo) VALUES
-- Proyectos principales (sin padre)
(1, NULL, 1, 1, 'PROJ-001', 'Sistema ERP Empresarial', 
 'Desarrollo e implementación de sistema ERP completo para gestión empresarial integral',
 '2024-01-15', '2025-12-31', NULL, 'https://cdn-icons-png.flaticon.com/512/2920/2920277.png'),

(2, NULL, 2, 2, 'PROJ-002', 'Modernización Infraestructura Cloud', 
 'Migración completa de infraestructura a servicios en la nube (AWS)',
 '2024-03-01', '2025-06-30', NULL, 'https://cdn-icons-png.flaticon.com/512/2920/2920349.png'),

(3, NULL, 3, 3, 'PROJ-003', 'Investigación IA Aplicada', 
 'Desarrollo de soluciones de inteligencia artificial para procesos organizacionales',
 '2024-02-01', '2025-12-31', NULL, 'https://cdn-icons-png.flaticon.com/512/4712/4712035.png'),

(4, NULL, 4, 4, 'PROJ-004', 'Campaña Digital 2025', 
 'Estrategia integral de marketing digital para posicionamiento de marca',
 '2025-01-01', '2025-12-31', NULL, 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),

(5, NULL, 5, 6, 'PROJ-005', 'Transformación Digital', 
 'Proyecto estratégico de transformación digital organizacional',
 '2024-06-01', '2026-06-30', NULL, 'https://cdn-icons-png.flaticon.com/512/4341/4341025.png'),

-- Subproyectos del ERP (PROJ-001)
(6, 1, 2, 1, 'PROJ-001-A', 'Módulo de Inventarios', 
 'Desarrollo del módulo de gestión de inventarios y almacenes',
 '2024-02-01', '2024-10-31', '2024-10-28', 'https://cdn-icons-png.flaticon.com/512/2921/2921222.png'),

(7, 1, 3, 1, 'PROJ-001-B', 'Módulo de Ventas y CRM', 
 'Desarrollo del módulo de ventas y gestión de relaciones con clientes',
 '2024-03-01', '2024-12-31', NULL, 'https://cdn-icons-png.flaticon.com/512/3135/3135706.png'),

(8, 1, 5, 1, 'PROJ-001-C', 'Módulo Contable', 
 'Desarrollo del módulo contable y financiero del ERP',
 '2024-04-01', '2025-03-31', NULL, 'https://cdn-icons-png.flaticon.com/512/2920/2920231.png'),

-- Subproyectos de Infraestructura (PROJ-002)
(9, 2, 2, 2, 'PROJ-002-A', 'Migración a AWS', 
 'Migración de servidores y aplicaciones a Amazon Web Services',
 '2024-04-01', '2025-02-28', NULL, 'https://cdn-icons-png.flaticon.com/512/2920/2920277.png'),

(10, 2, 4, 2, 'PROJ-002-B', 'Implementación Ciberseguridad', 
 'Implementación de sistemas de seguridad perimetral y monitoreo',
 '2024-05-01', '2025-04-30', NULL, 'https://cdn-icons-png.flaticon.com/512/2913/2913133.png'),

-- Subproyectos de IA (PROJ-003)
(11, 3, 3, 3, 'PROJ-003-A', 'Chatbot Inteligente', 
 'Desarrollo de chatbot con NLP para atención al cliente',
 '2024-03-15', '2024-11-30', NULL, 'https://cdn-icons-png.flaticon.com/512/4712/4712027.png'),

(12, 3, 5, 3, 'PROJ-003-B', 'Motor de Recomendaciones', 
 'Sistema de recomendaciones basado en machine learning',
 '2024-06-01', '2025-05-31', NULL, 'https://cdn-icons-png.flaticon.com/512/4341/4341139.png');
SET IDENTITY_INSERT Proyecto OFF;


-- =============================================
-- 9. META_PROYECTO
-- =============================================
PRINT 'Insertando Meta_Proyecto...';
INSERT INTO Meta_Proyecto (IdMeta, IdProyecto, FechaAsociacion) VALUES
(3, 1, '2024-01-15'),  -- ERP
(3, 6, '2024-02-01'),  -- Inventarios
(3, 7, '2024-03-01'),  -- Ventas
(3, 8, '2024-04-01'),  -- Contable
(4, 2, '2024-03-01'),  -- Cloud
(4, 9, '2024-04-01'),  -- AWS
(5, 3, '2024-02-01'),  -- IA
(5, 11, '2024-03-15'), -- Chatbot
(5, 12, '2024-06-01'), -- Recomendaciones
(2, 4, '2025-01-01'),  -- Marketing
(3, 5, '2024-06-01'),  -- Transformación
(4, 5, '2024-06-01');


-- =============================================
-- 10. PRESUPUESTOS
-- =============================================
PRINT 'Insertando Presupuestos...';
SET IDENTITY_INSERT Presupuesto ON;
INSERT INTO Presupuesto (Id, IdProyecto, MontoSolicitado, Estado, MontoAprobado, PeriodoAnio, FechaSolicitud, FechaAprobacion, Observaciones) VALUES
(1, 1, 15000000.00, 'Aprobado', 14000000.00, 2024, '2023-12-01', '2023-12-20', 'Aprobado con reducción del 7%'),
(2, 2, 8000000.00, 'Aprobado', 8000000.00, 2024, '2023-12-05', '2023-12-22', 'Aprobado monto completo'),
(3, 3, 12000000.00, 'Aprobado', 11000000.00, 2024, '2023-12-10', '2023-12-28', 'Aprobado con ajustes menores'),
(4, 4, 5000000.00, 'Aprobado', 4500000.00, 2024, '2024-11-15', '2024-12-05', 'Aprobado para campaña 2025'),
(5, 5, 20000000.00, 'Aprobado', 18000000.00, 2024, '2024-04-01', '2024-05-15', 'Proyecto estratégico aprobado'),
(6, 1, 16000000.00, 'Pendiente', NULL, 2025, '2024-11-20', NULL, 'En revisión por comité'),
(7, 2, 9000000.00, 'Aprobado', 8500000.00, 2025, '2024-11-25', '2024-12-10', 'Aprobado para continuidad'),
(8, 3, 13000000.00, 'Rechazado', NULL, 2025, '2024-12-01', '2024-12-15', 'Requiere replanteo de alcance');
SET IDENTITY_INSERT Presupuesto OFF;


-- =============================================
-- 11. DISTRIBUCIÓN PRESUPUESTO
-- =============================================
PRINT 'Insertando Distribución Presupuesto...';
SET IDENTITY_INSERT DistribucionPresupuesto ON;
INSERT INTO DistribucionPresupuesto (Id, IdPresupuestoPadre, IdProyectoHijo, MontoAsignado) VALUES
(1, 1, 6, 4000000.00),  -- Inventarios
(2, 1, 7, 5000000.00),  -- Ventas y CRM
(3, 1, 8, 5000000.00),  -- Contable
(4, 2, 9, 5000000.00),  -- Migración AWS
(5, 2, 10, 3000000.00), -- Ciberseguridad
(6, 3, 11, 6000000.00), -- Chatbot
(7, 3, 12, 5000000.00); -- Motor recomendaciones
SET IDENTITY_INSERT DistribucionPresupuesto OFF;


-- =============================================
-- 12. EJECUCIÓN PRESUPUESTO
-- =============================================
PRINT 'Insertando Ejecución Presupuesto...';
SET IDENTITY_INSERT EjecucionPresupuesto ON;
INSERT INTO EjecucionPresupuesto (Id, IdPresupuesto, Anio, MontoPlaneado, MontoEjecutado, Observaciones) VALUES
(1, 1, 2024, 14000000.00, 11200000.00, 'Ejecución al 80% - Proyecto en curso'),
(2, 2, 2024, 8000000.00, 6400000.00, 'Ejecución al 80% - Migración avanzando'),
(3, 3, 2024, 11000000.00, 7700000.00, 'Ejecución al 70% - Desarrollo en progreso'),
(4, 4, 2024, 4500000.00, 450000.00, 'Ejecución al 10% - Campaña iniciando'),
(5, 5, 2024, 18000000.00, 9000000.00, 'Ejecución al 50% - Avance según cronograma'),
(6, 6, 2025, 16000000.00, 0.00, 'Pendiente de aprobación'),
(7, 7, 2025, 8500000.00, 0.00, 'Planificado para inicio Q1 2025');
SET IDENTITY_INSERT EjecucionPresupuesto OFF;


-- =============================================
-- 13. ESTADOS
-- =============================================
PRINT 'Insertando Estados...';
SET IDENTITY_INSERT Estado ON;
INSERT INTO Estado (Id, Nombre, Descripcion) VALUES
(1, 'Planificado', 'Proyecto en fase de planificación'),
(2, 'En Progreso', 'Proyecto en ejecución activa'),
(3, 'En Pausa', 'Proyecto temporalmente suspendido'),
(4, 'Finalizado', 'Proyecto completado exitosamente'),
(5, 'Cancelado', 'Proyecto cancelado'),
(6, 'Retrasado', 'Proyecto con retraso en cronograma');
SET IDENTITY_INSERT Estado OFF;


-- =============================================
-- 14. ESTADO_PROYECTO
-- =============================================
PRINT 'Insertando Estado_Proyecto...';
INSERT INTO Estado_Proyecto (IdProyecto, IdEstado) VALUES
(1, 2),  -- ERP: En Progreso
(2, 2),  -- Infraestructura: En Progreso
(3, 2),  -- IA: En Progreso
(4, 1),  -- Marketing: Planificado
(5, 2),  -- Transformación: En Progreso
(6, 4),  -- Inventarios: Finalizado
(7, 2),  -- Ventas: En Progreso
(8, 2),  -- Contable: En Progreso
(9, 2),  -- AWS: En Progreso
(10, 2), -- Ciberseguridad: En Progreso
(11, 2), -- Chatbot: En Progreso
(12, 2); -- Recomendaciones: En Progreso


-- =============================================
-- 15. ENTREGABLES (ANTES de Archivo y Actividad)
-- =============================================
PRINT 'Insertando Entregables...';
SET IDENTITY_INSERT Entregable ON;
INSERT INTO Entregable (Id, Codigo, Titulo, Descripcion, FechaInicio, FechaFinPrevista, FechaModificacion, FechaFinalizacion) VALUES
(1, 'ENT-001-001', 'Base de Datos ERP', 
 'Diseño y creación de la base de datos completa del sistema ERP',
 '2024-01-20', '2024-03-15', '2024-03-10', '2024-03-12'),

(2, 'ENT-001-002', 'Módulo de Autenticación', 
 'Sistema de login y gestión de usuarios del ERP',
 '2024-03-15', '2024-05-30', '2024-05-28', '2024-05-29'),

(3, 'ENT-001-003', 'Dashboard Principal', 
 'Dashboard con indicadores y métricas principales',
 '2024-06-01', '2024-08-31', '2024-10-25', NULL),

(4, 'ENT-001A-001', 'Gestión de Almacenes', 
 'Funcionalidad para administrar múltiples almacenes',
 '2024-02-05', '2024-04-30', '2024-04-28', '2024-04-29'),

(7, 'ENT-001B-001', 'Gestión de Clientes', 
 'CRUD completo de clientes y contactos',
 '2024-03-05', '2024-05-31', '2024-10-25', NULL),

(8, 'ENT-001B-002', 'Proceso de Ventas', 
 'Flujo completo desde cotización hasta facturación',
 '2024-06-01', '2024-09-30', '2024-10-25', NULL),

(9, 'ENT-001B-003', 'CRM Integrado', 
 'Seguimiento de oportunidades y pipeline de ventas',
 '2024-10-01', '2024-12-31', NULL, NULL);
SET IDENTITY_INSERT Entregable OFF;


-- =============================================
-- 16. ARCHIVOS
-- =============================================
PRINT 'Insertando Archivos...';
SET IDENTITY_INSERT Archivo ON;
INSERT INTO Archivo (Id, IdUsuario, Ruta, Nombre, Tipo, Fecha) VALUES
(1, 1, '/documentos/erp/disenio_bd.pdf', 'Diseño Base de Datos ERP.pdf', 'pdf', '2024-02-14'),
(2, 1, '/documentos/erp/manual_usuario.pdf', 'Manual de Usuario ERP.pdf', 'pdf', '2024-05-20'),
(3, 2, '/documentos/inventarios/especificaciones.docx', 'Especificaciones Inventarios.docx', 'docx', '2024-04-15'),
(4, 3, '/documentos/ventas/flujo_ventas.pdf', 'Flujo de Proceso Ventas.pdf', 'pdf', '2024-07-10'),
(11, 6, '/marketing/estrategia/plan_contenidos_2025.pdf', 'Plan de Contenidos 2025.pdf', 'pdf', '2025-01-10'),
(12, 6, '/marketing/diseno/logo_campana.ai', 'Logo Campaña.ai', 'ai', '2025-01-15'),
(13, 4, '/marketing/reportes/metricas_q1.xlsx', 'Métricas Q1 2025.xlsx', 'xlsx', '2025-01-20'),
(14, 1, '/presupuesto/2024/solicitud_erp.xlsx', 'Solicitud Presupuesto ERP 2024.xlsx', 'xlsx', '2023-12-01'),
(15, 2, '/presupuesto/2024/justificacion_cloud.pdf', 'Justificación Migración Cloud.pdf', 'pdf', '2023-12-05');
SET IDENTITY_INSERT Archivo OFF;

-- =============================================
-- 17. ACTIVIDADES
-- =============================================
PRINT 'Insertando Actividades...';
SET IDENTITY_INSERT Actividad ON;
INSERT INTO Actividad (Id, IdEntregable, Titulo, Descripcion, FechaInicio, FechaFinPrevista, FechaModificacion, FechaFinalizacion, Prioridad, PorcentajeAvance) VALUES
(1, 1, 'Diseño del Modelo de Datos', 'Crear diagrama ER completo', '2024-01-20', '2024-02-15', '2024-02-14', '2024-02-14', 1, 100),
(2, 1, 'Creación de Tablas', 'Implementar todas las tablas en SQL Server', '2024-02-16', '2024-03-01', '2024-03-01', '2024-03-01', 1, 100),
(3, 1, 'Configuración de Constraints', 'Agregar FKs, PKs y validaciones', '2024-03-02', '2024-03-15', '2024-03-12', '2024-03-12', 1, 100),
(10, 4, 'CRUD de Almacenes', 'Crear interfaz de gestión', '2024-02-05', '2024-03-05', '2024-03-05', '2024-03-04', 1, 100),
(11, 4, 'Validaciones de Negocio', 'Reglas de negocio para almacenes', '2024-03-06', '2024-04-05', '2024-04-05', '2024-04-04', 1, 100),
(12, 4, 'Pruebas Unitarias', 'Testing completo del módulo', '2024-04-06', '2024-04-30', '2024-04-28', '2024-04-29', 2, 100);
SET IDENTITY_INSERT Actividad OFF;


-- =============================================
-- 18. ARCHIVO_ENTREGABLE
-- =============================================
PRINT 'Insertando Archivo_Entregable...';
INSERT INTO Archivo_Entregable (IdArchivo, IdEntregable) VALUES
(1, 1),  -- Diseño BD -> Base de Datos ERP
(2, 1),  -- Manual Usuario -> Base de Datos ERP
(3, 4),  -- Especificaciones -> Gestión de Almacenes
(4, 8);  -- Flujo Ventas -> Proceso de Ventas


-- =============================================
-- 19. RESPONSABLE_ENTREGABLE
-- =============================================
PRINT 'Insertando Responsable_Entregable...';
INSERT INTO Responsable_Entregable (IdResponsable, IdEntregable, FechaAsociacion) VALUES
(2, 1, '2024-01-20'), 
(2, 2, '2024-03-15'), 
(2, 3, '2024-06-01'), 
(3, 7, '2024-03-05'),  
(3, 8, '2024-06-01'), 
(3, 9, '2024-10-01'); 



--============================================
-- 20. RESUMEN DE DATOS INSERTADOS
--============================================

SELECT 'Variables Estratégicas' AS Tabla, COUNT(*) AS Total FROM VariableEstrategica
UNION ALL 
SELECT 'Objetivos Estratégicos', COUNT(*) FROM ObjetivoEstrategico
UNION ALL 
SELECT 'Metas Estratégicas', COUNT(*) FROM MetaEstrategica
UNION ALL 
SELECT 'Usuarios', COUNT(*) FROM Usuario
UNION ALL 
SELECT 'Responsables', COUNT(*) FROM Responsable
UNION ALL 
SELECT 'Tipos de Proyecto', COUNT(*) FROM TipoProyecto
UNION ALL 
SELECT 'Proyectos', COUNT(*) FROM Proyecto
UNION ALL 
SELECT 'Meta_Proyecto', COUNT(*) FROM Meta_Proyecto
UNION ALL 
SELECT 'Presupuestos', COUNT(*) FROM Presupuesto
UNION ALL 
SELECT 'Distribución Presupuesto', COUNT(*) FROM DistribucionPresupuesto
UNION ALL 
SELECT 'Ejecución Presupuesto', COUNT(*) FROM EjecucionPresupuesto
UNION ALL 
SELECT 'Estados', COUNT(*) FROM Estado
UNION ALL 
SELECT 'Estado_Proyecto', COUNT(*) FROM Estado_Proyecto
UNION ALL
SELECT 'Entregables', COUNT(*) FROM Entregable
UNION ALL
SELECT 'Archivos', COUNT(*) FROM Archivo
UNION ALL
SELECT 'Actividades', COUNT(*) FROM Actividad
UNION ALL
SELECT 'Archivo_Entregable', COUNT(*) FROM Archivo_Entregable
UNION ALL
SELECT 'Responsable_Entregable', COUNT(*) FROM Responsable_Entregable;

-- =============================================
-- 21 CONSULTAS DE VERIFICACIÓN
-- =============================================

-- Verificar jerarquía de proyectos
SELECT 
    CASE WHEN p.IdProyectoPadre IS NULL THEN '📁 ' ELSE '  └─ ' END + p.Codigo AS Estructura,
    p.Titulo,
    tp.Nombre AS Tipo,
    r.Nombre AS Responsable
FROM Proyecto p
LEFT JOIN TipoProyecto tp ON p.IdTipoProyecto = tp.Id
LEFT JOIN Responsable r ON p.IdResponsable = r.Id
ORDER BY ISNULL(p.IdProyectoPadre, p.Id), p.Id;

-- Verificar presupuestos por proyecto
SELECT 
    pr.Codigo,
    pr.Titulo AS Proyecto,
    COUNT(p.Id) AS CantidadPresupuestos,
    SUM(p.MontoSolicitado) AS TotalSolicitado,
    SUM(p.MontoAprobado) AS TotalAprobado
FROM Proyecto pr
LEFT JOIN Presupuesto p ON pr.Id = p.IdProyecto
GROUP BY pr.Codigo, pr.Titulo
ORDER BY pr.Codigo;
