ALTER SCHEMA Sesion transfer dbo.TblRolesPorMenus

ALTER SCHEMA RRHH transfer dbo.TblTiposDeEvaluaciones

ALTER TABLE RRHH.TblEvaluacionesAplicadasEncabezado
ADD FOREIGN KEY (IdEmpleado) REFERENCES RRHH.TblEmpleados(IdEmpleado);

drop TABLE Sesion.TblRolesPorMenus
/*
	AUTOR:		Joél Rodríguez
	FECHA:		08/08/2020
*/
--PROCEDIMIENTO PARA AGREGAR UN USUARIO
ALTER PROC Sesion.SPAgregarUsuario	(
											@_TxtNombres		NVARCHAR(50)
											,@_TxtApellidos		NVARCHAR(50)
											,@_TxtDireccion		NVARCHAR(150)
											,@_TxtEmail			NVARCHAR(100)
											,@_TxtPassword		NVARCHAR(130)
											,@_TxtToken         NVARCHAR(250)
									)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			int
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId			=	ISNULL(MAX(a.IdUsuario),0)
	FROM	Sesion.TblUsuarios	AS	a
	
	SELECT	@_IdUsuario		=	b.IdUsuario
	FROM	Sesion.TblTokens	as b
	WHERE	b.TxtToken		= @_TxtToken
	BEGIN TRY
		INSERT INTO Sesion.TblUsuarios	(
											IdUsuario
											,TxtNombres
											,TxtApellidos
											,TxtDireccion
											,TxtEmail
											,TxtPassword	
											,IdUsuarioIngresadoPor 
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtNombres
											,@_TxtApellidos
											,@_TxtDireccion
											,@_TxtEmail
											,@_TxtPassword
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 

EXEC Sesion.SPAgregarUsuario 'Prueba', 'Peres', 'Melchor', 'corre@gmial.com', '123'
--------------------------------------------------------------------------------




/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/
create proc Sesion.SPObtenerUsuarios
as
begin
	select
		a.IdUsuario
		,concat(a.TxtNombres, ' ', a.TxtApellidos) as TxtNombres
		,a.TxtDireccion
		,a.TxtEmail
		,a.TxtPassword
		,a.FechaIngreso
		,a.IntEstado
	from Sesion.TblUsuarios as a
	where a.IntEstado > 0
end





/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/

create proc Sesion.SPObtenerDatosUsuario(
		@_IdUsuario int
										)
as
begin
	select 
	a.IdUsuario,
	a.TxtNombres,
	a.TxtApellidos,
	a.TxtDireccion,
	a.TxtEmail,
	a.TxtPassword
	from Sesion.TblUsuarios as a
	where a.IdUsuario = @_IdUsuario
end

CREATE PROC Sesion.SPEliminarUsuario (
	@_IdUsuario INT
)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	Sesion.TblUsuarios
			SET		IntEstado = 0
					
			WHERE	IdUsuario = @_IdUsuario

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdUsuario
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END

CREATE PROC Sesion.SPActualizarUsuario (
	@_IdUsuario INT,
	@_TxtNombres NVARCHAR(50),
	@_TxtApellidos NVARCHAR(50),
	@_TxtDireccion NVARCHAR(150),
	@_TxtEmail NVARCHAR(100),
	@_TxtPassword NVARCHAR(130)
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	Sesion.TblUsuarios
			SET		TxtNombres = @_TxtNombres,
					TxtApellidos = @_TxtApellidos,
					TxtDireccion = @_TxtDireccion,
					TxtEmail = @_TxtEmail,
					TxtPassword = @_TxtPassword
					
			WHERE	IdUsuario = @_IdUsuario

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdUsuario
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


--Iniciar sesion
alter PROC Sesion.SPInicioDeSesion(@_TxtEmail NVARCHAR(100), 
									@_TxtPassword NVARCHAR(130), 
									@_TxtToken NVARCHAR(250), 
									@_VigenciaEnMinutos INT)

AS
DECLARE @_IdUsuario INT, @_TxtUsuario NVARCHAR(100), @_UltimoId int, @_IntResultado TINYINT, @_FilasAfectadas TINYINT, @_IdInstitucion SMALLINT

BEGIN
	SELECT
		@_IdUsuario = a.IdUsuario,
		@_TxtUsuario = CONCAT(a.TxtNombres, ' ', a.TxtApellidos),
		@_IdInstitucion = b.IdUsuario
	FROM Sesion.TblUsuarios AS a
		LEFT JOIN Sesion.TblUsuariosPorInstitucion AS b
		ON b.IdUsuario = a.IdUsuario
	WHERE a.TxtEmail = @_TxtEmail
		AND a.TxtPassword = @_TxtPassword
		AND a.IntEstado = 1

	BEGIN TRAN
		SELECT 
			@_UltimoId = ISNULL(MAX(a.IdToken),0)
		FROM Sesion.TblTokens AS a

		UPDATE Sesion.TblTokens
		SET IntEstado = 0
		WHERE IdUsuario = @_IdUsuario
			AND IntEstado > 0

	BEGIN TRY
		INSERT INTO Sesion.TblTokens(IdToken, IdUsuario, TxtToken, VigenciaEnMinutos, FechaIngreso, IntEstado)
		VALUES (@_UltimoId + 1, @_IdUsuario, @_TxtToken, @_VigenciaEnMinutos, GETDATE(), 1)
		SET @_FilasAfectadas = @@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas = 0
	END CATCH

	--determina si se realizo correctamente la transaccion
	IF(@_FilasAfectadas > 0)
		BEGIN
			SET @_IntResultado = 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_IntResultado = 0
			SET	@_TxtToken = 'Usuario o contraseña invalida'
			ROLLBACK
		END
	--devolver resultado
	SELECT
		IntResultado = @_IntResultado,
		TxtToken = @_TxtToken,
		TxtUsuario = @_TxtUsuario,
		IdInstitucion = @_IdInstitucion
END

--SP Funcion verificar token expirado

CREATE FUNCTION Sesion.FnVerificarVigenciaToken( @_TxtToken NVARCHAR(250))

RETURNS TINYINT
AS
BEGIN
	DECLARE @_IntResultado TINYINT, @_VigenciaEnMinutos INT = 30, @_FechaYHoraDeCreacion DATETIME = '2001-01-01 01:01:01.001', 
			@_FechaYHoraActual DATETIME = getDate(), @_TiempoDeUsoEnMinutos INT
	SELECT
		@_VigenciaEnMinutos = a.VigenciaEnMinutos,
		@_FechaYHoraDeCreacion = a.FechaIngreso
	FROM Sesion.TblTokens AS a
	WHERE a.TxtToken = @_TxtToken
		AND a.IntEstado = 1

	SET @_TiempoDeUsoEnMinutos = DATEDIFF(MINUTE, @_FechaYHoraDeCreacion, @_FechaYHoraActual)

	IF(@_TiempoDeUsoEnMinutos > @_VigenciaEnMinutos)
		BEGIN
			SET @_IntResultado = 0
		END
	ELSE
		BEGIN
			SET @_IntResultado = 1
		END

	RETURN @_IntResultado
END

--SP Actualizar vigencia del token en cada transaccion

CREATE PROC Sesion.SPActualizarVigenciaToken(@_TxtToken NVARCHAR(250))

AS
BEGIN
	--eliminar Tokens Expirados
	DELETE Sesion.TblTokens
	WHERE IntEstado = 0

	UPDATE Sesion.TblTokens
	SET FechaIngreso = getdate()
	WHERE TxtToken = @_TxtToken
		AND IntEstado = 1
END

--SP Estado del token

alter PROC Sesion.SPObtenerEstadoToken(@_TxtToken NVARCHAR(250))
AS
DECLARE @_EstadoToken TINYINT = 0
BEGIN
	--0 = Expirado, 1 = Vigente
	SELECT @_EstadoToken = Sesion.FnVerificarVigenciaToken(@_TxtToken)
	IF(@_EstadoToken = 1)
		BEGIN
			EXEC Sesion.SPActualizarVigenciaToken @_TxtToken
		END

	SELECT EstadoToken = @_EstadoToken
END

/*
Autor: José Quixchán
Fehca: 17/09/20
*/
--Funcion Obtener ID usuario
create function Sesion.FnObtenerIdUsuario(
											@_TxtToken nvarchar(250)
										)
returns int
as 
begin
	declare @_IdUsuario int = 0

	select @_IdUsuario = a.IdUsuario
	from Sesion.TblTokens as a
	where a.TxtToken = @_TxtToken
			and a.IntEstado = 1 
	return @_IdUsuario
end

drop function Sesion.ObtenerIdUsuario

/*
Autor: José Quixchán
Fehca: 17/09/20
*/
-- SP para generar menu de acceso

create proc Sesion.SPMenuUsuario ( @_TxtToken nvarchar(250), @_IdModulo TINYINT)

as
DECLARE @_IdUsuario INT = 0
begin	
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)

	SELECT b.IdMenu, a.TxtNombre, a.TxtLink, a.IdMenuPadre, a.TxtImagen, b.Agregar, b.ModificarActualizar, b.Eliminar, b.Consultar, b.Imprimir, b.Aprobar, b.Reversar, b.Finalizar

	FROM Sesion.TblMenus AS a
		LEFT JOIN Sesion.TblRolesPorMenus AS b
		ON a.IdMenu = b.IdMenu
		LEFT JOIN Sesion.TblRoles AS c
		ON c.IdRol = b.IdRol
		LEFT JOIN Sesion.TblUsuariosPorRoles AS d
		ON d.IdRol = c.IdRol
		LEFT JOIN Sesion.TblUsuarios AS e
		ON e.IdUsuario = d.IdUsuario
	
	WHERE 
		a.IntEstado = 1 AND a.IdModulo = @_IdModulo AND b.IntEstado = 1 AND c.IntEstado = 1 AND d.IntEstado = 1 AND e.IntEstado = 1 AND d.IdUsuario = @_IdUsuario
	ORDER BY
		a.DblOrden ASC
end



---------------------------------------------------------Especialidad-------------------------------------------------------
/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO PARA AGREGAR Especialidad
CREATE PROC RRHH.SPAgregarEspecialidad	(@_TxtEspecialidad NVARCHAR(100), @_TxtToken	NVARCHAR(250))	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario				INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId			=	ISNULL(MAX(a.IdEspecialidad),0)
	FROM	RRHH.TblEspecialidades	AS	a
	
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	 
	BEGIN TRY
		INSERT INTO RRHH.TblEspecialidades(
											IdEspecialidad
											,TxtEspecialidad
											,IdUsuario
																							
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtEspecialidad
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/

ALTER PROC RRHH.SPEliminarEspecialidad (
	@_IdEspecialidad SMALLINT
)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblEspecialidades
			SET		IntEstado = 0
					
			WHERE	IdEspecialidad = @_IdEspecialidad

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdEspecialidad
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO Modificar Especialidad

CREATE PROC RRHH.SPActualizarEspecialidad (
	@_IdEspecialidad SMALLINT,
	@_TxtEspecialidad NVARCHAR(100) 
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblEspecialidades
			SET		TxtEspecialidad = @_TxtEspecialidad
					
					
			WHERE	IdEspecialidad = @_IdEspecialidad

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdEspecialidad
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 01/10/20
*/
create proc RRHH.SPObtenerEspecialidades
as
begin
	select
		a.IdEspecialidad
		,a.TxtEspecialidad
		,a.FechaIngreso
		

	from RRHH.TblEspecialidades as a
	where a.IntEstado > 0
end


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/

create proc RRHH.SPObtenerDatosEspecialidad(
		@_IdRegistro int
										)
as
begin
	select 
	a.IdEspecialidad,
	a.TxtEspecialidad

	from RRHH.TblEspecialidades as a
	where a.IdEspecialidad = @_IdRegistro
end

-------------------------------------Puestos----------------------------------------

/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO PARA AGREGAR Puesto
CREATE PROC RRHH.SPAgregarPuestos	(@_TxtPuesto NVARCHAR(200), @_TxtToken	NVARCHAR(250))	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario				INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId			=	ISNULL(MAX(a.IdPuesto),0)
	FROM	RRHH.TblPuestos	AS	a
	
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	 
	BEGIN TRY
		INSERT INTO RRHH.TblPuestos(
											IdPuesto
											,TxtPuesto
											,IdUsuario
																							
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtPuesto
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 



/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--SP PARA ELIMINAR PUESTO
alter PROC RRHH.SPEliminarPuesto (
	@_IdRegistro smallint
)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblPuestos
			SET		IntEstado = 0
					
			WHERE	IdPuesto = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO Modificar Pueto

CREATE PROC RRHH.SPActualizarPuesto (
	@_IdRegistro SMALLINT,
	@_TxtPuesto NVARCHAR(200) 
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblPuestos
			SET		TxtPuesto = @_TxtPuesto
					
					
			WHERE	IdPuesto = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 01/10/20
*/
create proc RRHH.SPObtenerPuestos
as
begin
	select
		a.IdPuesto
		,a.TxtPuesto
		,a.FechaIngreso
		

	from RRHH.TblPuestos as a
	where a.IntEstado > 0
end


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/

create proc RRHH.SPObtenerDatosPuesto(
		@_IdRegistro int
										)
as
begin
	select 
	a.IdPuesto,
	a.TxtPuesto

	from RRHH.TblPuestos as a
	where a.IdPuesto = @_IdRegistro
end

------------------------------------Renglones-------------------------------------------------


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO PARA AGREGAR Renglones
CREATE PROC RRHH.SPAgregarRenglon	(@_TxtRenglon NVARCHAR(250), @_TxtToken	NVARCHAR(250))	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario				INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId			=	ISNULL(MAX(a.IdRenglon),0)
	FROM	RRHH.TblRenglones	AS	a
	
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	 
	BEGIN TRY
		INSERT INTO RRHH.TblRenglones(
											IdRenglon
											,TxtRenglon
											,IdUsuario
																							
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtRenglon
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 



/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--SP PARA ELIMINAR PUESTO
CREATE PROC RRHH.SPEliminarRenglon (
	@_IdRegistro INT
)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblRenglones
			SET		IntEstado = 0
					
			WHERE	IdRenglon = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO Modificar Pueto

CREATE PROC RRHH.SPActualizarRenglon (
	@_IdRegistro  SMALLINT,
	@_TxtRenglon NVARCHAR(200) 
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblRenglones
			SET		TxtRenglon = @_TxtRenglon
					
					
			WHERE	IdRenglon = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 01/10/20
*/
create proc RRHH.SPObtenerRenglones
as
begin
	select
		a.IdRenglon
		,a.TxtRenglon
		,a.FechaIngreso
		

	from RRHH.TblRenglones as a
	where a.IntEstado > 0
end


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/

create proc RRHH.SPObtenerDatosRenglon(
		@_IdRegistro int
										)
as
begin
	select 
	a.IdRenglon,
	a.TxtRenglon

	from RRHH.TblRenglones as a
	where a.IdRenglon = @_IdRegistro
end

-------------------------------------------------------Servicios---------------------------------


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO PARA AGREGAR Renglones
CREATE PROC RRHH.SPAgregarServicio	(@_TxtServicio NVARCHAR(200), @_TxtToken	NVARCHAR(250))	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario				INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId			=	ISNULL(MAX(a.IdServicio),0)
	FROM	RRHH.TblServicios	AS	a
	
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	 
	BEGIN TRY
		INSERT INTO RRHH.TblServicios(
											IdServicio
											,TxtServicio
											,IdUsuario
																							
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtServicio
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 



/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--SP PARA ELIMINAR PUESTO
CREATE PROC RRHH.SPEliminarServicio (
	@_IdRegistro INT
)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblServicios
			SET		IntEstado = 0
					
			WHERE	IdServicio = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO Modificar Pueto

alter PROC RRHH.SPActualizarServicio (
	@_IdRegistro  INT,
	@_TxtServicio NVARCHAR(200) 
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblServicios
			SET		TxtServicio = @_TxtServicio
					
					
			WHERE	IdServicio = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 01/10/20
*/

create proc RRHH.SPObtenerServicios
as
begin
	select
		a.IdServicio
		,a.TxtServicio
		,a.FechaIngreso
		

	from RRHH.TblServicios as a
	where a.IntEstado > 0
end


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/

create proc RRHH.SPObtenerDatosServicio(
		@_IdRegistro int
										)
as
begin
	select 
	a.IdServicio,
	a.TxtServicio

	from RRHH.TblServicios as a
	where a.IdServicio = @_IdRegistro
end

--------------------------------------------------Empleados------------------------------------------
--PROCEDIMIENTO PARA AGREGAR UN Empleado
create PROC RRHH.SPAgregarEmpleado	(
											@_TxtNit		    NVARCHAR(15)
											,@_TxtDpi			NVARCHAR(30)
											,@_TxtNombres		NVARCHAR(50)
											,@_TxtApellidos		NVARCHAR(20)
											,@_IdPuesto			SMALLINT
											,@_IdEspecialidad	SMALLINT
											,@_IdServicio		SMALLINT
											,@_IdRenglon		SMALLINT
											,@_IdInstitucion	SMALLINT
											,@_TxtToken			NVARCHAR(250)
										)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId					=	ISNULL(MAX(a.IdEmpleado),0)
	FROM	RRHH.TblEmpleados			AS	a
	
	--Se obtiene el ID del usuario
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	BEGIN TRY
		INSERT INTO RRHH.TblEmpleados(
											IdEmpleado
											,TxtNit
											,TxtDpi
											,TxtNombres
											,TxtApellidos
											,IdPuesto
											,IdEspecialidad
											,IdServicio
											,IdRenglon
											,IdInstitucion
											,IdUsuario
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtNit
											,@_TxtDpi
											,@_TxtNombres
											,@_TxtApellidos
											,@_IdPuesto
											,@_IdEspecialidad
											,@_IdServicio
											,@_IdRenglon
											,@_IdInstitucion
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN



/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/

--PROCEDIMIENTO PARA AGREGAR Empleado
CREATE PROC RRHH.SPAgregarEmpleado	(
											@_TxtNit		    NVARCHAR(15)
											,@_TxtDpi			NVARCHAR(30)
											,@_TxtNombres		NVARCHAR(50)
											,@_TxtApellidos		NVARCHAR(20)
											,@_IdPuesto			SMALLINT
											,@_IdEspecialidad	SMALLINT
											,@_IdServicio		SMALLINT
											,@_IdRenglon		SMALLINT
											,@_IdInstitucion	SMALLINT
											,@_TxtToken			NVARCHAR(250)
										)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId					=	ISNULL(MAX(a.IdEmpleado),0)
	FROM	RRHH.TblEmpleados			AS	a
	
	--Se obtiene el ID del usuario
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	BEGIN TRY
		INSERT INTO RRHH.TblEmpleados(
											IdEmpleado
											,TxtNit
											,TxtDpi
											,TxtNombres
											,TxtApellidos
											,IdPuesto
											,IdEspecialidad
											,IdServicio
											,IdRenglon
											,IdInstitucion
											,IdUsuario
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtNit
											,@_TxtDpi
											,@_TxtNombres
											,@_TxtApellidos
											,@_IdPuesto
											,@_IdEspecialidad
											,@_IdServicio
											,@_IdRenglon
											,@_IdInstitucion
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 



/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--SP PARA ELIMINAR Empleado
CREATE PROC RRHH.SPEliminarEmpleado (
										@_IdRegistro int
									
									)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblEmpleados
			SET		IntEstado = 0
					
			WHERE	IdEmpleado = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO Modificar Empleado

ALTER PROC RRHH.SPActualizarEmpleado (
	@_IdRegistro  INT,
	@_TxtNit NVARCHAR(15),
										@_TxtDpi NVARCHAR(30),
										@_TxtNombres NVARCHAR(50),
										@_TxtApellidos NVARCHAR(50),
										@_IdPuesto smallint,
										@_IdEspecialidad smallint,
										@_IdServicio smallint,
										@_IdRenglon smallint,
										@_IdInstitucion smallint
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblEmpleados
			SET		TxtNit =			 @_TxtNit,
					TxtDpi =				@_TxtDpi,
					TxtNombres =			@_TxtNombres,
					TxtApellidos =			@_TxtApellidos,
					IdPuesto =				@_IdPuesto,
					IdEspecialidad =		@_IdEspecialidad,
					IdServicio =			 @_IdServicio,
					IdRenglon =				@_IdRegistro,
					IdInstitucion =			@_IdInstitucion

					
					
			WHERE	IdEmpleado = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 01/10/20
*/
create proc RRHH.SPObtenerEmpleados 
as
begin
	select
		 a.IdEmpleado
		,a.TxtNit
		,a.IdPuesto
		,a.TxtNombres
		,a.TxtApellidos
		,b.TxtPuesto
		,c.TxtEspecialidad
		,d.TxtServicio
		,e.TxtRenglon
		,f.TxtNombre					as TxtInstitucion
		,a.FechaIngreso
		
		

	from RRHH.TblEmpleados			as a
	left join RRHH.TblPuestos		as b
	on b.IdPuesto					=	a.IdPuesto
	left join RRHH.TblEspecialidades as c
	on c.IdEspecialidad				= a.IdEspecialidad
	left join RRHH.TblServicios			as d
	on d.IdServicio						= a.IdServicio
	left join RRHH.TblRenglones				as e
	on e.IdRenglon						= a.IdRenglon
	left join  Sistema.TblInstituciones	as f
	on f.IdInstitucion					= a.IdInstitucion
	 
	where a.IntEstado > 0
end


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/

create proc RRHH.SPObtenerDatosEmpleado(
		@_IdRegistro int
										)
as
begin
	select 
	a.IdEmpleado,
	a.TxtNit,
	a.TxtDpi,
	a.TxtNombres,
	a.TxtApellidos,
	a.IdPuesto,
	a.IdEspecialidad,
	a.IdServicio,
	a.IdRenglon,
	a.IdInstitucion

	from RRHH.TblEmpleados as a
	where a.IdEmpleado = @_IdRegistro
end
--------------------------------------------Factores-------------------------------------------

/*
	AUTOR:		Joél Rodríguez
	FECHA:		21/10/2020
*/

--PROCEDIMIENTO PARA AGREGAR
CREATE PROC RRHH.SPAgregarFactor (
											@_TxtFactor	    NVARCHAR(200)
											,@_TxtDescripcion		NVARCHAR(max)
											,@_TxtToken			NVARCHAR(250)
										)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId					=	ISNULL(MAX(a.IdFactor),0)
	FROM	RRHH.TblFactores		AS	a
	
	--Se obtiene el ID del usuario
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	BEGIN TRY
		INSERT INTO RRHH.TblFactores(
											IdFactor
											,TxtFactor
											,TxtDescripcion
											,IdUsuario
											
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtFactor
											,@_TxtDescripcion
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 



/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO Modificar Empleado

CREATE PROC RRHH.SPActualizarFactor (
										@_IdRegistro  SMALLINT,
										@_TxtFactor	    NVARCHAR(200)
										,@_TxtDescripcion		NVARCHAR(max)
										
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblFactores
			SET		TxtFactor =			 @_TxtFactor,
					TxtDescripcion =	@_TxtDescripcion
		

					
					
			WHERE	IdFactor = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--SP PARA ELIMINAR Empleado
alter PROC RRHH.SPEliminarFactor (
										@_IdRegistro smallint
									)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblFactores
			SET		IntEstado = 0
					
			WHERE	IdFactor = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 01/10/20
*/
create proc RRHH.SPObtenerFactores
as
begin
	select
		a.IdFactor
		,a.TxtFactor
		,a.TxtDescripcion
		,CONCAT(b.TxtNombres, ' ', b.TxtApellidos) as TxtUsuario
		,a.FechaIngreso

	from 
		RRHH.TblFactores			as a
		left join	Sesion.TblUsuarios as b
		on b.IdUsuario		=  a.IdUsuario 
	where a.IntEstado > 0
end


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/
alter proc RRHH.SPObtenerDatosFactor(
		@_IdRegistro smallint
										)
as
begin
	select 
	a.TxtFactor,
	a.TxtDescripcion


	from RRHH.TblFactores as a
	where a.IdFactor = @_IdRegistro
end

---------------------------------------------------SubFactores-------------------------------------------------

/*
	AUTOR:		Joél Rodríguez
	FECHA:		21/10/2020
*/

--PROCEDIMIENTO PARA AGREGAR
CREATE PROC RRHH.SPAgregarSubFactor (
											@_TxtSubFactor	    NVARCHAR(200)
											,@_TxtDescripcion		NVARCHAR(max)
											,@_TxtToken			NVARCHAR(250)
										)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId					=	ISNULL(MAX(a.IdSubFactor),0)
	FROM	RRHH.TblSubFactores		AS	a
	
	--Se obtiene el ID del usuario
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	BEGIN TRY
		INSERT INTO RRHH.TblSubFactores(
											IdSubFactor
											,TxtSubFactor
											,TxtDescripcion
											,IdUsuario
											
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtSubFactor
											,@_TxtDescripcion
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 



/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO Modificar Empleado

CREATE PROC RRHH.SPActualizarSubFactor (
										@_IdRegistro  SMALLINT,
										@_TxtSubFactor	    NVARCHAR(200)
										,@_TxtDescripcion		NVARCHAR(max)
										
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblSubFactores
			SET		TxtSubFactor =			 @_TxtSubFactor,
					TxtDescripcion =	@_TxtDescripcion
		

					
					
			WHERE	IdSubFactor = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--SP PARA ELIMINAR Empleado
alter PROC RRHH.SPEliminarSubFactor (
										@_IdRegistro smallint
									)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblSubFactores
			SET		IntEstado = 0
					
			WHERE	IdSubFactor = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 01/10/20
*/
create proc RRHH.SPObtenerSubFactores
as
begin
	select
		a.IdSubFactor
		,a.TxtSubFactor
		,a.TxtDescripcion
		,CONCAT(b.TxtNombres, ' ', b.TxtApellidos) as TxtUsuario
		,a.FechaIngreso

	from 
		RRHH.TblSubFactores			as a
		left join	Sesion.TblUsuarios as b
		on b.IdUsuario		=  a.IdUsuario 
	where a.IntEstado > 0
end


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/
alter proc RRHH.SPObtenerDatosSubFactor(
		@_IdRegistro smallint
										)
as
begin
	select 
	a.TxtSubFactor,
	a.TxtDescripcion


	from RRHH.TblSubFactores as a
	where a.IdSubFactor = @_IdRegistro
end


-----------------------------------------------Escala de Calificacion----------------------------------------


/*
	AUTOR:		Joél Rodríguez
	FECHA:		21/10/2020
*/

--PROCEDIMIENTO PARA AGREGAR
CREATE PROC RRHH.SPAgregarEscalaDeCalificacion (
											@_TxtEscalaDeCalificacion	    NVARCHAR(250)
											,@_DbPunteo		decimal(5, 2)
											,@_TxtDescripcion		nvarchar(MAX)
											,@_TxtToken			NVARCHAR(250)
										)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId					=	ISNULL(MAX(a.IdEscalaDeCalificacion),0)
	FROM	RRHH.TblEscalasDeCalificacion		AS	a
	
	--Se obtiene el ID del usuario
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	BEGIN TRY
		INSERT INTO RRHH.TblEscalasDeCalificacion(
											IdEscalaDeCalificacion
											,TxtEscalaDeCalificacion
											,DbPunteo
											,TxtDescripcion
											,IdUsuario
											
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtEscalaDeCalificacion
											,@_DbPunteo
											,@_TxtDescripcion
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 



/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO Modificar Empleado

CREATE PROC RRHH.SPActualizarEscalaDeCalificacion (
										@_IdRegistro  tinyint,
										@_TxtEscalaDeCalificacion	    NVARCHAR(250)
										,@_DbPunteo		decimal(5, 2)
										,@_TxtDescripcion		nvarchar(MAX)
										
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblEscalasDeCalificacion
			SET		TxtEscalaDeCalificacion =			 @_TxtEscalaDeCalificacion,
					DbPunteo = @_DbPunteo,
					TxtDescripcion =	@_TxtDescripcion
		

					
					
			WHERE	IdEscalaDeCalificacion = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--SP PARA ELIMINAR Empleado
CREATE PROC RRHH.SPEliminarEscalaDeCalificacion (
										@_IdRegistro tinyint 
									)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblEscalasDeCalificacion
			SET		IntEstado = 0
					
			WHERE	IdEscalaDeCalificacion = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 01/10/20
*/
create proc RRHH.SPObtenerEscalasDeCalificacion
as
begin
	select
		a.IdEscalaDeCalificacion
		,a.TxtEscalaDeCalificacion
		,a.DbPunteo
		,a.TxtDescripcion
		,CONCAT(b.TxtNombres, ' ', b.TxtApellidos) as TxtUsuario
		,a.FechaIngreso

	from 
		RRHH.TblEscalasDeCalificacion			as a
		left join	Sesion.TblUsuarios as b
		on b.IdUsuario		=  a.IdUsuario 
	where a.IntEstado > 0
end


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/
create proc RRHH.SPObtenerDatosEscalaDeCalificacion(
		@_IdRegistro tinyint
										)
as
begin
	select 
	a.TxtEscalaDeCalificacion
	,a.DbPunteo
	,a.TxtDescripcion


	from RRHH.TblEscalasDeCalificacion as a
	where a.IdEscalaDeCalificacion = @_IdRegistro
end


----------------------------------------------------------------TiposDeEvaluaciones--------------------------------



/*
	AUTOR:		Joél Rodríguez
	FECHA:		21/10/2020
*/

--PROCEDIMIENTO PARA AGREGAR
CREATE PROC RRHH.SPAgregarTipoDeEvaluacion (
											@_TxtTipoDeEvaluacion	    NVARCHAR(150)					
											,@_TxtToken			NVARCHAR(250)
										)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId					=	ISNULL(MAX(a.IdTipoDeEvaluacion),0)
	FROM	RRHH.TblTiposDeEvaluaciones		AS	a
	
	--Se obtiene el ID del usuario
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	BEGIN TRY
		INSERT INTO RRHH.TblTiposDeEvaluaciones(
											IdTipoDeEvaluacion
											,TxtTipoDeEvaluacion										
											,IdUsuario
											
										)
		VALUES							(
											@_UltimoId + 1
											,@_TxtTipoDeEvaluacion
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 



/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO Modificar Empleado

CREATE PROC RRHH.SPActualizarTipoDeEvaluacion (
										@_IdRegistro  tinyint,
										@_TxtTipoDeEvaluacion	    NVARCHAR(250)										
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblTiposDeEvaluaciones
			SET		TxtTipoDeEvaluacion =			 @_TxtTipoDeEvaluacion
								
			WHERE	IdTipoDeEvaluacion = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--SP PARA ELIMINAR Empleado
CREATE PROC RRHH.SPEliminarTipoDeEvaluacion (
										@_IdRegistro tinyint 
									)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblTiposDeEvaluaciones
			SET		IntEstado = 0
					
			WHERE	IdTipoDeEvaluacion = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 01/10/20
*/
create proc RRHH.SPObtenerTiposDeEvaluaciones
as
begin
	select
		a.IdTipoDeEvaluacion
		,a.TxtTipoDeEvaluacion
		,CONCAT(b.TxtNombres, ' ', b.TxtApellidos) as TxtUsuario
		,a.FechaIngreso

	from 
		RRHH.TblTiposDeEvaluaciones			as a
		left join	Sesion.TblUsuarios as b
		on b.IdUsuario		=  a.IdUsuario 
	where a.IntEstado > 0
end


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/
create proc RRHH.SPObtenerDatosTipoDeEvaluacion(
		@_IdRegistro tinyint
										)
as
begin
	select 
	a.TxtTipoDeEvaluacion

	from RRHH.TblTiposDeEvaluaciones as a
	where a.IdTipoDeEvaluacion = @_IdRegistro
end

-----------------------------------------------------Evaluaciones Encabezado-------------------------------------------

/*
	AUTOR:		Joél Rodríguez
	FECHA:		21/10/2020
*/

--PROCEDIMIENTO PARA AGREGAR
CREATE PROC RRHH.SPAgregarEvaluacionEncabezado (
											@_IdTipoDeEvaluacion	    tinyint		
											,@_Anio						smallint
											,@_TxtToken					NVARCHAR(250)
										)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId					=	ISNULL(MAX(a.IdEvaluacionEncabezado),0)
	FROM	RRHH.TblEvaluacionesEncabezado	AS	a
	
	--Se obtiene el ID del usuario
	SELECT @_IdUsuario = Sesion.FnObtenerIdUsuario(@_TxtToken)
	BEGIN TRY
		INSERT INTO RRHH.TblEvaluacionesEncabezado(
											IdTipoDeEvaluacion
											,Anio									
											,IdUsuario
											
										)
		VALUES							(
											@_UltimoId + 1
											,@_IdTipoDeEvaluacion
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 



/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--PROCEDIMIENTO Modificar Empleado

CREATE PROC RRHH.SPActualizarEvaluacionEncabezado (
										@_IdRegistro  int,
										@_IdTipoDeEvaluacion	    tinyint
										,@_Anio			tinyint 
)

AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblEvaluacionesEncabezado
			SET		IdTipoDeEvaluacion =			 @_IdTipoDeEvaluacion,
					Anio =							@_Anio
								
			WHERE	IdEvaluacionEncabezado = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END

	SELECT Resultado  = @_Resultado
END


/*
	AUTOR:		Joél Rodríguez
	FECHA:		29/08/2020
*/
--SP PARA ELIMINAR Empleado
CREATE PROC RRHH.SPEliminarEvaluacionEncabezado (
										@_IdRegistro int
									)
AS
DECLARE 
	@_FilasAfectadas	TINYINT,
	@_Resultado			INT

BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE	RRHH.TblEvaluacionesEncabezado
			SET		IntEstado = 0
					
			WHERE	IdEvaluacionEncabezado = @_IdRegistro

			SET		@_FilasAfectadas = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET		@_FilasAfectadas = 0
		END CATCH

		IF(@_FilasAfectadas > 0)
			BEGIN
				SET @_Resultado = @_IdRegistro
				COMMIT
			END
		ELSE
			BEGIN
				SET @_Resultado = 0
			ROLLBACK
		END
	SELECT Resultado  = @_Resultado
END


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 01/10/20
*/
create proc RRHH.SPObtenerEvaluacionesEncabezado
as
begin
	select
		c.TxtTipoDeEvaluacion
		,a.Anio
		,CONCAT(b.TxtNombres, ' ', b.TxtApellidos) as TxtUsuario
		,a.FechaIngreso

	from 
		RRHH.TblEvaluacionesEncabezado			as a
		left join	Sesion.TblUsuarios as b
		on b.IdUsuario		=  a.IdUsuario 
		left join	RRHH.TblTiposDeEvaluaciones  as c
		on c.IdTipoDeEvaluacion = a.IdEvaluacionEncabezado
	where a.IntEstado > 0
end


/*
Autor: José Quixchán
Fehca: 19/08/20
modificado: 19/08/20
*/
create proc RRHH.SPObtenerDatosEvaluacionEncabezado(
		@_IdRegistro int
										)
as
begin
	select 
	a.IdTipoDeEvaluacion,
	a.Anio

	from RRHH.TblEvaluacionesEncabezado as a
	where a.IdEvaluacionEncabezado = @_IdRegistro
end




------------------------------ EVALUACIONES DETALLE ----------------------------------------


/*
	AUTOR:		Jose Quixchan
	FECHA:		23/10/2020
*/
--PROCEDIMIENTO PARA AGREGAR EVALUACION DETALLE

CREATE PROC RRHH.SPAgregarEvaluacionDetalle	(
												@_IdEvaluacionEncabezado		INT
												,@_IdFactor						SMALLINT
												,@_IdSubFactor					SMALLINT
												,@_TxtToken						NVARCHAR(250)
									)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId			=	ISNULL(MAX(a.IdEvaluacionDetalle),0)
	FROM	RRHH.TblEvaluacionesDetalle	AS	a
	
	--SE OBTIENE EL ID DEL USUARIO
	SELECT	@_IdUsuario			= Sesion.FnObtenerIdUsuario(@_TxtToken)	

	BEGIN TRY
		INSERT INTO RRHH.TblEvaluacionesDetalle(
											IdEvaluacionDetalle
											,IdEvaluacionEncabezado
											,IdFactor
											,IdSubFactor
											,IdUsuario
										)
		VALUES							(
											@_UltimoId + 1
											,@_IdEvaluacionEncabezado
											,@_IdFactor
											,@_IdSubFactor
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 




/*
AUTOR: Jose Quixchan
FECHA: 23/10/20
*/

--SP PARA MODIFICAR DATOS 

CREATE PROC RRHH.SPActualizarEvaluacionDetalle	(
													@_IdRegistro					INT
													,@_IdEvaluacionEncabezado		INT
													,@_IdFactor						SMALLINT
													,@_IdSubFactor					SMALLINT
										)
AS
DECLARE @_FilasAfectadas				TINYINT
		,@_Resultado					INT
BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE RRHH.TblEvaluacionesDetalle
			SET		
					IdEvaluacionEncabezado		=	@_IdEvaluacionEncabezado
					,IdFactor					=	@_IdFactor
					,IdSubFactor				=	@_IdSubFactor

			WHERE	IdEvaluacionDetalle		=	@_IdRegistro

			SET @_FilasAfectadas		=	@@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET	@_FilasAfectadas		=	0
		END CATCH

	IF(@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado				=	@_IdRegistro
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado				=	0
			ROLLBACK
		END

	SELECT Resultado					=	@_Resultado
END



/*
AUTOR: Jose Quixchan
FECHA: 23/10/20
*/

--SP PARA OBTENER REGISTROS 

CREATE PROC RRHH.SPObtenerEvaluacionesDetalle
AS
BEGIN
	SELECT
			a.IdEvaluacionDetalle
			,a.IdEvaluacionEncabezado
			,b.TxtFactor
			,c.TxtSubFactor
			,CONCAT(d.TxtNombres,' ',d.TxtApellidos)	AS	TxtUsuario
			,a.FechaIngreso

	FROM 
			RRHH.TblEvaluacionesDetalle					AS	a

			LEFT JOIN RRHH.TblFactores					AS	b
			ON b.IdFactor								=	a.IdFactor

			LEFT JOIN RRHH.TblSubFactores				AS	c
			ON c.IdSubFactor							=	a.IdSubFactor

			LEFT JOIN Sesion.TblUsuarios				AS	d
			ON d.IdUsuario								=	a.IdUsuario

	WHERE a.IntEstado									>  0
END


/*
AUTOR: JORGE CANEK
FECHA: 23/10/20
*/

--OBTENER DATOS 

CREATE PROC RRHH.SPObtenerDatosEvaluacionDetalle	(
											@_IdRegistro INT
										)

AS
BEGIN
	SELECT
			a.IdEvaluacionDetalle	
			,a.IdEvaluacionEncabezado
			,a.IdFactor
			,a.IdSubFactor


	FROM RRHH.TblEvaluacionesDetalle	AS a
	WHERE a.IdEvaluacionDetalle			=	@_IdRegistro
END


/*
AUTOR: Jose Quixchan
FECHA: 23/10/20
*/

--PROCEDIMIENTO PARA ELIMINAR REGISTRO

CREATE PROC RRHH.SPEliminarEvaluacionDetalle	(
											@_IdRegistro INT
												)
AS
DECLARE @_FilasAfectadas				TINYINT
		,@_Resultado					INT
BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE RRHH.TblEvaluacionesDetalle
			SET		IntEstado				=	0
			WHERE	IdEvaluacionDetalle		=	@_IdRegistro

			SET @_FilasAfectadas		=	@@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET	@_FilasAfectadas		=	0
		END CATCH

	IF(@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado		=	@_IdRegistro
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado		=	0
			ROLLBACK
		END

	SELECT Resultado			=	@_Resultado
END




-----------------------------EVALUACIONES APLICADAS DETALLE----------------------------------

/*
	AUTOR:		Jose Quixchan
	FECHA:		23/10/2020
*/
--PROCEDIMIENTO PARA AGREGAR EVALUACION APLICADA DETALLE

CREATE PROC RRHH.SPAgregarEvaluacionAplicadaDetalle	(
												@_IdEvaluacionAplicadaEncabezado		INT
												,@_IdEvaluacionDetalle					INT
												,@_IdEscalaDeCalificacion				TINYINT
												,@_TxtToken								NVARCHAR(250)
									)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId			=	ISNULL(MAX(a.IdEvaluacionAplicadaDetalle),0)
	FROM	RRHH.TblEvaluacionesAplicadasDetalle	AS	a
	
	--SE OBTIENE EL ID DEL USUARIO
	SELECT	@_IdUsuario			= Sesion.FnObtenerIdUsuario(@_TxtToken)	

	BEGIN TRY
		INSERT INTO RRHH.TblEvaluacionesAplicadasDetalle(
											IdEvaluacionAplicadaDetalle
											,IdEvaluacionAplicadaEncabezado
											,IdEvaluacionDetalle
											,IdEscalaDeCalificacion
											,IdUsuario
										)
		VALUES							(
											@_UltimoId + 1
											,@_IdEvaluacionAplicadaEncabezado
											,@_IdEvaluacionDetalle
											,@_IdEscalaDeCalificacion
											,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 




/*
AUTOR: Jose Quixchan
FECHA: 23/10/20
*/

--SP PARA MODIFICAR DATOS 

ALTER PROC RRHH.SPActualizarEvaluacionAplicadaDetalle	(
													@_IdRegistro							INT
													,@_IdEvaluacionAplicadaEncabezado		INT
													,@_IdEvaluacionDetalle					INT
													,@_IdEscalaDeCalificacion				TINYINT
										)
AS
DECLARE @_FilasAfectadas				TINYINT
		,@_Resultado					INT
BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE RRHH.TblEvaluacionesAplicadasDetalle
			SET		
					IdEvaluacionAplicadaEncabezado			=	@_IdEvaluacionAplicadaEncabezado
					,IdEvaluacionDetalle					=	@_IdEvaluacionDetalle
					,IdEscalaDeCalificacion					=	@_IdEscalaDeCalificacion

			WHERE	IdEvaluacionAplicadaDetalle		=	@_IdRegistro

			SET @_FilasAfectadas		=	@@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET	@_FilasAfectadas		=	0
		END CATCH

	IF(@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado				=	@_IdRegistro
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado				=	0
			ROLLBACK
		END

	SELECT Resultado					=	@_Resultado
END



/*
AUTOR: Jose Quixchan
FECHA: 23/10/20
*/

--SP PARA OBTENER REGISTROS  


CREATE PROC RRHH.SPObtenerEvaluacionesAplicadasDetalle
AS
BEGIN
	SELECT
			a.IdEvaluacionAplicadaDetalle
			,a.IdEvaluacionAplicadaEncabezado
			,a.IdEvaluacionDetalle
			,b.TxtEscalaDeCalificacion
			,CONCAT(c.TxtNombres,'',c.TxtApellidos)		AS	TxtUsuario
			,a.FechaIngreso

	FROM 
			RRHH.TblEvaluacionesAplicadasDetalle		AS	a

			LEFT JOIN RRHH.TblEscalasDeCalificacion		AS	b
			ON b.IdEscalaDeCalificacion					=	a.IdEscalaDeCalificacion

			LEFT JOIN Sesion.TblUsuarios				AS	c
			ON c.IdUsuario								=	a.IdUsuario

	WHERE a.IntEstado									>  0
END


/*
AUTOR: JORGE CANEK
FECHA: 23/10/20
*/

--OBTENER DATOS 

CREATE PROC RRHH.SPObtenerDatosEvaluacionAplicadasDetalle	(
																@_IdRegistro INT
															)

AS
BEGIN
	SELECT
			a.IdEvaluacionAplicadaDetalle	
			,a.IdEvaluacionAplicadaEncabezado
			,a.IdEvaluacionDetalle
			,a.IdEscalaDeCalificacion


	FROM RRHH.TblEvaluacionesAplicadasDetalle	AS a
	WHERE a.IdEvaluacionAplicadaDetalle			=	@_IdRegistro
END


/*
AUTOR: Jose Quixchan
FECHA: 23/10/20
*/

--PROCEDIMIENTO PARA ELIMINAR REGISTRO

CREATE PROC RRHH.SPEliminarEvaluacionAplicadaDetalle	(
															@_IdRegistro INT
														)
AS
DECLARE @_FilasAfectadas				TINYINT
		,@_Resultado					INT
BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE RRHH.TblEvaluacionesAplicadasDetalle
			SET		IntEstado						=	0
			WHERE	IdEvaluacionAplicadaDetalle		=	@_IdRegistro

			SET @_FilasAfectadas		=	@@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET	@_FilasAfectadas		=	0
		END CATCH

	IF(@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado		=	@_IdRegistro
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado		=	0
			ROLLBACK
		END

	SELECT Resultado			=	@_Resultado
END






---------------------EVALUACIONES APLICADAS ENCABEZADO---------------------------


/*
	AUTOR:		Jose Quixchan
	FECHA:		23/10/2020
*/
--PROCEDIMIENTO PARA AGREGAR EVALUACION APLICADA ENCABEZADO

CREATE PROC RRHH.SPAgregarEvaluacionAplicadaEncabezado	(
															@_IdInstitucion					SMALLINT
															,@_IdEvaluacionEncabezado		INT
															,@_IdEmpleado					INT
															,@_FechaDeAplicacion			DATE
															,@_FechaInicial					DATE
															,@_FechaFinal					DATE
															,@_DbPunteoTotal				DECIMAL(5,2)
															,@_TxtObservacionesDeJefe		NVARCHAR(MAX)
															,@_TxtObservacionesDeEmpleado	NVARCHAR(MAX)
															,@_IntNecesitaPlanDeMejora		TINYINT
															,@_TxtToken						NVARCHAR(250)
														)	
AS
DECLARE @_FilasAfectadas		TINYINT
		,@_Resultado			SMALLINT
		,@_UltimoId				SMALLINT
		,@_IdUsuario			INT
BEGIN
BEGIN TRAN
	--OBTENGO EL ULTIMO ID GUARDADO EN LA TABLA
	SELECT	@_UltimoId			=	ISNULL(MAX(a.IdEvaluacionAplicadaEncabezado),0)
	FROM	RRHH.TblEvaluacionesAplicadasEncabezado	AS	a
	
	--SE OBTIENE EL ID DEL USUARIO
	SELECT	@_IdUsuario			= Sesion.FnObtenerIdUsuario(@_TxtToken)	

	BEGIN TRY
		INSERT INTO RRHH.TblEvaluacionesAplicadasEncabezado(
																IdEvaluacionAplicadaEncabezado
																,IdInstitucion					
																,IdEvaluacionEncabezado		
																,IdEmpleado					
																,FechaDeAplicacion			
																,FechaInicial					
																,FechaFinal			
																,DbPunteoTotal				
																,TxtObservacionesDeJefe		
																,TxtObservacionesDeEmpleado	
																,IntNecesitaPlanDeMejora	
																,IdUsuario
															)
		VALUES												(
																@_UltimoId + 1
																,@_IdInstitucion					
																,@_IdEvaluacionEncabezado		
																,@_IdEmpleado					
																,@_FechaDeAplicacion			
																,@_FechaInicial					
																,@_FechaFinal					
																,@_DbPunteoTotal				
																,@_TxtObservacionesDeJefe		
																,@_TxtObservacionesDeEmpleado	
																,@_IntNecesitaPlanDeMejora	
																,@_IdUsuario
										)
		SET @_FilasAfectadas			=	@@ROWCOUNT
	END TRY
	BEGIN CATCH
		SET @_FilasAfectadas			=	0
	END CATCH		

--DETERMINAR SI SE REALIZO CORRECTAMENTE LA TRANSACCION ANTERIOR
IF (@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado			=	@_UltimoId + 1
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado			=	0
			ROLLBACK
		END
	--DEVOLVER RESULTADO: EL ULTIMO ID QUE UTILIZARÉ MÁS ADELANTE
	SELECT Resultado				=	@_Resultado
END --FIN 




/*
AUTOR: Jose Quixchan
FECHA: 23/10/20
*/

--SP PARA MODIFICAR DATOS 

CREATE PROC RRHH.SPActualizarEvaluacionAplicadaEncabezado	(
																@_IdRegistro					INT
																,@_IdInstitucion				SMALLINT
																,@_IdEvaluacionEncabezado		INT
																,@_IdEmpleado					INT
																,@_FechaDeAplicacion			DATE
																,@_FechaInicial					DATE
																,@_FechaFinal					DATE
																,@_DbPunteoTotal				DECIMAL(5,2)
																,@_TxtObservacionesDeJefe		NVARCHAR(MAX)
																,@_TxtObservacionesDeEmpleado	NVARCHAR(MAX)
																,@_IntNecesitaPlanDeMejora		TINYINT
															)
AS
DECLARE @_FilasAfectadas				TINYINT
		,@_Resultado					INT
BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE RRHH.TblEvaluacionesAplicadasEncabezado
			SET		
					IdInstitucion					=	@_IdInstitucion
					,IdEvaluacionEncabezado			=	@_IdEvaluacionEncabezado
					,IdEmpleado						=	@_IdEmpleado
					,FechaDeAplicacion				=	@_FechaDeAplicacion
					,FechaInicial					=	@_FechaInicial	
					,FechaFinal						=	@_FechaFinal
					,DbPunteoTotal					=	@_DbPunteoTotal
					,TxtObservacionesDeJefe			=	@_TxtObservacionesDeJefe
					,TxtObservacionesDeEmpleado		=	@_TxtObservacionesDeEmpleado
					,IntNecesitaPlanDeMejora		=	@_IntNecesitaPlanDeMejora

			WHERE	IdEvaluacionAplicadaEncabezado		=	@_IdRegistro

			SET @_FilasAfectadas		=	@@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET	@_FilasAfectadas		=	0
		END CATCH

	IF(@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado				=	@_IdRegistro
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado				=	0
			ROLLBACK
		END

	SELECT Resultado					=	@_Resultado
END



/*
AUTOR: Jose Quixchan
FECHA: 23/10/20
*/

--SP PARA OBTENER REGISTROS  

CREATE PROC RRHH.SPObtenerEvaluacionesAplicadasEncabezado
AS
BEGIN
	SELECT
			a.IdEvaluacionAplicadaEncabezado
			,b.TxtNombre								AS	TxtInstitucion
			,a.IdEvaluacionEncabezado
			,CONCAT(c.TxtNombres, ' ',c.TxtApellidos)	AS	TxtEmpleado
			,a.FechaDeAplicacion
			,a.FechaInicial
			,a.FechaFinal
			,a.DbPunteoTotal
			,a.TxtObservacionesDeJefe
			,a.TxtObservacionesDeEmpleado
			,a.IntNecesitaPlnaDeMejora
			,CONCAT(b.TxtNombres,' ',b.TxtApellidos)	AS	TxtUsuario
			,a.FechaIngreso

	FROM 
			RRHH.TblEvaluacionesAplicadasEncabezado		AS	a

			LEFT JOIN Sistema.TblInstituciones				AS	b
			ON b.IdInstitucion							=	a.IdInstitucion

			LEFT JOIN RRHH.TblEmpleados					AS	c
			ON c.IdEmpleado								=	a.IdEmpleado

			LEFT JOIN RRHH.TblUsuarios					AS	d
			ON d.IdUsuario								=	a.IdUsuario

	WHERE a.IntEstado									>  0
END


/*
AUTOR: Jose Quixchan
FECHA: 23/10/20
*/

--OBTENER DATOS 

CREATE PROC RRHH.SPObtenerDatosEvaluacionAplicadasEncabezado	(
																	@_IdRegistro INT
																)

AS
BEGIN
	SELECT
			a.IdEvaluacionAplicadaEncabezado
			,a.IdInstitucion					
			,a.IdEvaluacionEncabezado		
			,a.IdEmpleado					
			,a.FechaDeAplicacion			
			,a.FechaInicial					
			,a.FechaFinal			
			,a.DbPunteoTotal				
			,a.TxtObservacionesDeJefe		
			,a.TxtObservacionesDeEmpleado	
			,a.IntNecesitaPlanDeMejora


	FROM RRHH.TblEvaluacionesAplicadasEncabezado	AS a
	WHERE a.IdEvaluacionAplicadaEncabezado			=	@_IdRegistro
END


/*
AUTOR: Jose Quixchan
FECHA: 23/10/20
*/

--PROCEDIMIENTO PARA ELIMINAR REGISTRO

CREATE PROC RRHH.SPEliminarEvaluacionAplicadaEncabezado	(
															@_IdRegistro INT
														)
AS
DECLARE @_FilasAfectadas				TINYINT
		,@_Resultado					INT
BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE RRHH.TblEvaluacionesAplicadasEncabezado
			SET		IntEstado							=	0
			WHERE	IdEvaluacionAplicadaEncabezado		=	@_IdRegistro

			SET @_FilasAfectadas		=	@@ROWCOUNT
		END TRY
		BEGIN CATCH
			SET	@_FilasAfectadas		=	0
		END CATCH

	IF(@_FilasAfectadas > 0)
		BEGIN
			SET @_Resultado		=	@_IdRegistro
			COMMIT
		END
	ELSE
		BEGIN
			SET @_Resultado		=	0
			ROLLBACK
		END

	SELECT Resultado			=	@_Resultado
END