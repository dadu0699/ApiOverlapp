DROP DATABASE IF EXISTS Overlapp;
CREATE DATABASE Overlapp;
USE Overlapp;

CREATE TABLE Equipo(
	idEquipo INT NOT NULL AUTO_INCREMENT,
  nombreEquipo VARCHAR(255) NOT NULL,
  PRIMARY KEY (idEquipo)
);

CREATE TABLE Canal(
	idCanal INT NOT NULL AUTO_INCREMENT,
	idEquipo INT NOT NULL,
  nombreCanal VARCHAR(255) NOT NULL,
	descripcion VARCHAR(255),
  PRIMARY KEY (idCanal),
	FOREIGN KEY (idEquipo) REFERENCES Equipo(idEquipo) ON DELETE CASCADE
);

CREATE TABLE Usuario(
	idUsuario INT NOT NULL AUTO_INCREMENT,
	correo VARCHAR(255) NOT NULL,
	contrasena VARCHAR(255) NOT NULL,
	PRIMARY KEY (idUsuario)
);

CREATE TABLE Perfil (
	idPerfil INT NOT NULL AUTO_INCREMENT,
	idUsuario INT NOT NULL,
	nombre VARCHAR(255) NOT NULL,
	apellido VARCHAR(255) NOT NULL,
	telefono VARCHAR(255) NOT NULL,
	PRIMARY KEY (idPerfil),
	FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario) ON DELETE CASCADE
);

CREATE TABLE PerfilCanal (
	idPerfilCanal INT NOT NULL AUTO_INCREMENT,
	idPerfil INT NOT NULL,
	idCanal INT NOT NULL,
	PRIMARY KEY (idPerfilCanal),
	FOREIGN KEY (idPerfil) REFERENCES Perfil(idPerfil) ON DELETE CASCADE,
	FOREIGN KEY (idCanal) REFERENCES Canal(idCanal) ON DELETE CASCADE
);

CREATE TABLE Publicacion (
	idPublicacion INT NOT NULL AUTO_INCREMENT,
	idPerfilCanal INT NOT NULL,
	fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
	contenido TEXT NOT NULL,
	archivo TEXT NULL,
	PRIMARY KEY (idPublicacion),
	FOREIGN KEY (idPerfilCanal) REFERENCES PerfilCanal(idPerfilCanal) ON DELETE CASCADE
);

CREATE TABLE Comentario (
	idComentario INT NOT NULL AUTO_INCREMENT,
	idPublicacion INT NOT NULL,
	idPerfil INT NOT NULL,
	fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
	contenido TEXT NOT NULL,
	PRIMARY KEY (idComentario),
	FOREIGN KEY (idPublicacion) REFERENCES Publicacion(idPublicacion) ON DELETE CASCADE,
	FOREIGN KEY (idPerfil) REFERENCES Perfil(idPerfil) ON DELETE CASCADE
);

CREATE TABLE Chat (
	idChat INT NOT NULL AUTO_INCREMENT,
	idEmisor INT NOT NULL,
	idReceptor INT NOT NULL,
	PRIMARY KEY (idChat),
	FOREIGN KEY (idEmisor) REFERENCES Perfil(idPerfil) ON DELETE CASCADE,
	FOREIGN KEY (idReceptor) REFERENCES Perfil(idPerfil) ON DELETE CASCADE
);

CREATE TABLE Mensaje (
	idMensaje INT NOT NULL AUTO_INCREMENT,
	idChat INT NOT NULl,
	fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
	contenido TEXT NOT NULL,
	PRIMARY KEY (idMensaje),
	FOREIGN KEY (idChat) REFERENCES Chat(idChat) ON DELETE CASCADE
);

/* PROCEDIMIENTOS ALMACENADOS */
-- AGREGAR EQUIPO
DROP PROCEDURE IF EXISTS sp_agregarEquipo;
DELIMITER $$
CREATE PROCEDURE sp_agregarEquipo (
	IN _nombreEquipo VARCHAR(255)
	)
BEGIN
	IF NOT EXISTS (SELECT * FROM Equipo WHERE nombreEquipo = _nombreEquipo) THEN
		INSERT INTO Equipo (nombreEquipo) VALUES (_nombreEquipo);
        SET @idEquipo = (SELECT idEquipo FROM Equipo WHERE nombreEquipo = _nombreEquipo);
		INSERT INTO Canal (idEquipo, nombreCanal, descripcion) VALUES (@idEquipo, 'General', CONCAT('General ', _nombreEquipo));
	END IF;
END$$
DELIMITER ;

-- MODIFICAR EQUIPO
DROP PROCEDURE IF EXISTS sp_modificarEquipo;
DELIMITER $$
CREATE PROCEDURE sp_modificarEquipo (
	IN _idEquipo INT,
    IN _nombreEquipo VARCHAR(255)
    )
BEGIN
	IF NOT EXISTS (SELECT * FROM Equipo WHERE nombreEquipo = _nombreEquipo AND idEquipo != _idEquipo) THEN
		UPDATE Equipo SET nombreEquipo=_nombreEquipo WHERE idEquipo=_idEquipo;
	END IF;
END$$
DELIMITER ;

-- ELIMINAR EQUIPO
DROP PROCEDURE IF EXISTS sp_eliminarEquipo;
DELIMITER $$
CREATE PROCEDURE sp_eliminarEquipo (
	IN _idEquipo INT
    )
BEGIN
	DELETE FROM Equipo WHERE idEquipo=_idEquipo;
END$$
DELIMITER ;

-- AGREGAR CANAL
DROP PROCEDURE IF EXISTS sp_agregarCanal;
DELIMITER $$
CREATE PROCEDURE sp_agregarCanal (
	IN _idEquipo INT,
    IN _nombreCanal VARCHAR(255),
    IN _descripcion VARCHAR(255)
	)
BEGIN
	IF NOT EXISTS (SELECT * FROM Canal WHERE idEquipo = _idEquipo AND nombreCanal = _nombreCanal) THEN
		INSERT INTO Canal (idEquipo, nombreCanal, descripcion)
			VALUES (_idEquipo, _nombreCanal, _descripcion);
	END IF;
END$$
DELIMITER ;

-- MODIFICAR CANAL
DROP PROCEDURE IF EXISTS sp_modificarCanal;
DELIMITER $$
CREATE PROCEDURE sp_modificarCanal (
	IN _idCanal INT,
    IN _idEquipo INT,
    IN _nombreCanal VARCHAR(255),
    IN _descripcion VARCHAR(255)
	)
BEGIN
	SET @idCanal = (SELECT idCanal FROM Canal WHERE idEquipo=_idEquipo AND nombreCanal = 'General');

	IF _idCanal != @idCanal THEN
		IF NOT EXISTS (SELECT * FROM Canal WHERE idEquipo=_idEquipo AND nombreCanal = _nombreCanal AND idCanal!=_idCanal) THEN
			UPDATE Canal SET nombreCanal=_nombreCanal, descripcion=_descripcion WHERE idCanal=_idCanal;
		END IF;
	END IF;
END$$
DELIMITER ;

-- ELIMINAR CANAL
DROP PROCEDURE IF EXISTS sp_eliminarCanal;
DELIMITER $$
CREATE PROCEDURE sp_eliminarCanal (
	IN _idCanal INT
    )
BEGIN
	IF NOT EXISTS (SELECT idCanal FROM Canal WHERE idCanal=_idCanal AND nombreCanal = 'General') THEN
		DELETE FROM Canal WHERE idCanal=_idCanal;
	END IF;
END$$
DELIMITER ;

-- AGREGAR USUARIO Y PERFIL
DROP PROCEDURE IF EXISTS sp_agregarUsuario;
DELIMITER $$
CREATE PROCEDURE sp_agregarUsuario (
	IN _nombreEquipo VARCHAR(255),
	IN _correo VARCHAR(255),
    IN _contrasena VARCHAR(255),
    IN _nombre VARCHAR(255),
    IN _apellido VARCHAR(255),
    IN _telefono VARCHAR(255)
	)
BEGIN
	IF NOT EXISTS (SELECT * FROM Usuario WHERE correo = _correo) THEN
		IF EXISTS (SELECT * FROM Equipo WHERE nombreEquipo = _nombreEquipo)	THEN
			INSERT INTO Usuario (correo, contrasena) VALUES (_correo, _contrasena);

			SET @idUsuario = (SELECT idUsuario FROM Usuario WHERE correo = _correo LIMIT 1);
			INSERT INTO Perfil (idUsuario, nombre, apellido, telefono) VALUES (@idUsuario, _nombre, _apellido, _telefono);

			SET @idPerfil = (SELECT idPerfil FROM Perfil WHERE idUsuario = @idUsuario LIMIT 1);
			SET @idEquipo = (SELECT idEquipo FROM Equipo WHERE nombreEquipo = _nombreEquipo LIMIT 1);
			SET @idCanal = (SELECT idCanal FROM Canal WHERE idEquipo = @idEquipo LIMIT 1);

			INSERT INTO PerfilCanal (idPerfil, idCanal) VALUES (@idPerfil, @idCanal);

            CALL sp_login(_correo, _contrasena);
		END IF;
	END IF;
END$$
DELIMITER ;

-- MODIFICAR USUARIO Y PERFIL
DROP PROCEDURE IF EXISTS sp_modificarUsuario;
DELIMITER $$
CREATE PROCEDURE sp_modificarUsuario (
	IN _idUsuario INT,
	IN _correo VARCHAR(255),
    IN _contrasena VARCHAR(255),
    IN _nombre VARCHAR(255),
    IN _apellido VARCHAR(255),
    IN _telefono VARCHAR(255)
	)
BEGIN
	IF NOT EXISTS (SELECT * FROM Usuario WHERE correo=_correo AND idUsuario!=_idUsuario) THEN
		UPDATE Usuario SET correo=_correo, contrasena=_contrasena WHERE idUsuario=_idUsuario;
		UPDATE Perfil SET nombre=_nombre, apellido=_apellido, telefono=_telefono WHERE idUsuario=_idUsuario;

			SELECT usuario.idUsuario, perfil.idPerfil, usuario.correo, usuario.contrasena,
				perfil.nombre, perfil.apellido, perfil.telefono, PerfilCanal.idCanal as 'idCanal'
			FROM usuario
			INNER JOIN perfil ON usuario.idUsuario = perfil.idUsuario
			INNER JOIN PerfilCanal ON perfil.idPerfil = PerfilCanal.idPerfil
			WHERE usuario.correo = _correo AND usuario.contrasena = _contrasena
			ORDER BY idCanal ASC LIMIT 1;
	END IF;
END$$
DELIMITER ;

-- ELIMINAR USUARIO
DROP PROCEDURE IF EXISTS sp_eliminarUsuario;
DELIMITER $$
CREATE PROCEDURE sp_eliminarUsuario (
	IN _idUsuario INT
    )
BEGIN
	DELETE FROM Usuario WHERE idUsuario=_idUsuario;
END$$
DELIMITER ;

-- AGREGAR PERFIL CANAL
DROP PROCEDURE IF EXISTS sp_agregarPerfilCanal;
DELIMITER $$
CREATE PROCEDURE sp_agregarPerfilCanal (
	IN _idPerfil INT,
	IN _idCanal INT
	)
BEGIN
	INSERT INTO PerfilCanal (idPerfil, idCanal) VALUES (_idPerfil, _idCanal);
END$$
DELIMITER ;

-- ELIMINAR PERFIL CANAL
DROP PROCEDURE IF EXISTS sp_eliminarPerfilCanal;
DELIMITER $$
CREATE PROCEDURE sp_eliminarPerfilCanal (
	IN _idPerfilCanal INT
    )
BEGIN
	SET @idCanal = (SELECT idCanal FROM PerfilCanal WHERE idPerfilCanal=_idPerfilCanal);
	IF NOT EXISTS (SELECT idCanal FROM Canal WHERE idCanal=@idCanal AND nombreCanal = 'General') THEN
		DELETE FROM PerfilCanal WHERE idPerfilCanal=_idPerfilCanal;
	END IF;
END$$
DELIMITER ;

-- AGREGAR PUBLICACION
DROP PROCEDURE IF EXISTS sp_agregarPublicacion;
DELIMITER $$
CREATE PROCEDURE sp_agregarPublicacion (
	IN _idUsuario INT,
	IN _idCanal INT,
	IN _contenido TEXT
	)
BEGIN
	SET @idPerfil= (SELECT idPerfil FROM Perfil WHERE idUsuario=_idUsuario);
	SET @idPerfilCanal = (SELECT idPerfilCanal FROM PerfilCanal WHERE idPerfil=@idPerfil AND idCanal=_idCanal);
	INSERT INTO Publicacion (idPerfilCanal, contenido) VALUES (@idPerfilCanal, _contenido);
END$$
DELIMITER ;

-- MODIFICAR PUBLICACION
DROP PROCEDURE IF EXISTS sp_modificarPublicacion;
DELIMITER $$
CREATE PROCEDURE sp_modificarPublicacion (
	IN _idPublicacion INT,
	IN _contenido TEXT
	)
BEGIN
	UPDATE Publicacion SET contenido=_contenido WHERE idPublicacion=_idPublicacion;
END $$
DELIMITER ;

-- ELIMINAR PUBLICACION
DROP PROCEDURE IF EXISTS sp_eliminarPublicacion;
DELIMITER $$
CREATE PROCEDURE sp_eliminarPublicacion (
	IN _idPublicacion INT
	)
BEGIN
	DELETE FROM Publicacion WHERE idPublicacion=_idPublicacion;
END $$
DELIMITER ;

-- AGREGAR COMENTARIO
DROP PROCEDURE IF EXISTS sp_agregarComentario;
DELIMITER $$
CREATE PROCEDURE sp_agregarComentario (
	IN _idPublicacion INT,
	IN _idPerfil INT,
	IN _contenido TEXT
	)
BEGIN
	INSERT INTO Comentario (idPublicacion, idPerfil, contenido) VALUES (_idPublicacion ,_idPerfil, _contenido);
END$$
DELIMITER ;

-- MODIFICAR COMENTARIO
DROP PROCEDURE IF EXISTS sp_modificarComentario;
DELIMITER $$
CREATE PROCEDURE sp_modificarComentario (
	IN _idComentario INT,
	IN _contenido TEXT
	)
BEGIN
	UPDATE Comentario SET contenido=_contenido WHERE idComentario=_idComentario;
END $$
DELIMITER ;

-- ELIMINAR COMENTARIO
DROP PROCEDURE IF EXISTS sp_eliminarComentario;
DELIMITER $$
CREATE PROCEDURE sp_eliminarComentario (
	IN _idComentario INT
	)
BEGIN
	DELETE FROM Comentario WHERE idComentario=_idComentario;
END $$
DELIMITER ;

-- AGREGAR CHAT
DROP PROCEDURE IF EXISTS sp_agregarChat;
DELIMITER $$
CREATE PROCEDURE sp_agregarChat (
	IN _idEmisor INT,
	IN _idReceptor INT
	)
BEGIN
	INSERT INTO Chat (idEmisor, idReceptor) VALUES (_idEmisor ,_idReceptor);
END$$
DELIMITER ;

-- ELIMINAR CHAT
DROP PROCEDURE IF EXISTS sp_eliminarChat;
DELIMITER $$
CREATE PROCEDURE sp_eliminarChat (
	IN _idChat INT
	)
BEGIN
	DELETE FROM Chat WHERE idChat=_idChat;
END $$
DELIMITER ;

-- AGREGAR MENSAJE
DROP PROCEDURE IF EXISTS sp_agregarMensaje;
DELIMITER $$
CREATE PROCEDURE sp_agregarMensaje (
	IN _idChat INT,
	IN _contenido TEXT
	)
BEGIN
	INSERT INTO Mensaje (idChat, contenido) VALUES (_idChat ,_contenido);
END$$
DELIMITER ;

-- ELIMINAR MENSAJE
DROP PROCEDURE IF EXISTS sp_eliminarMensaje;
DELIMITER $$
CREATE PROCEDURE sp_eliminarMensaje (
	IN _idMensaje INT
	)
BEGIN
	DELETE FROM Mensaje WHERE idMensaje=_idMensaje;
END $$
DELIMITER ;

-- LOGIN
DROP PROCEDURE IF EXISTS sp_login;
DELIMITER $$
CREATE PROCEDURE sp_login (
	IN _correo VARCHAR(255),
	IN _contrasena VARCHAR(255)
	)
BEGIN
	SELECT usuario.idUsuario, perfil.idPerfil, usuario.correo, usuario.contrasena,
		perfil.nombre, perfil.apellido, perfil.telefono, PerfilCanal.idCanal as 'idCanal'
    FROM usuario
    INNER JOIN perfil ON usuario.idUsuario = perfil.idUsuario
    INNER JOIN PerfilCanal ON perfil.idPerfil = PerfilCanal.idPerfil
    WHERE usuario.correo = _correo AND usuario.contrasena = _contrasena
    ORDER BY idCanal ASC LIMIT 1;
END $$
DELIMITER ;

-- CANALES DEL USUARIO
DROP PROCEDURE IF EXISTS sp_usuarioGrupo;
DELIMITER $$
CREATE PROCEDURE sp_usuarioGrupo (
	IN _idPerfil INT)
BEGIN
	SELECT canal.descripcion
	FROM PerfilCanal
	INNER JOIN canal ON PerfilCanal.idCanal= canal.idCanal
	WHERE PerfilCanal.idPerfil = _idPerfil;
END $$
DELIMITER ;

-- PUBLICACIONES DEL CANAL
DROP PROCEDURE IF EXISTS sp_canalPublicacion;
DELIMITER $$
CREATE PROCEDURE sp_canalPublicacion (
	IN _idCanal INT)
BEGIN
	SELECT publicacion.idPublicacion, publicacion.contenido, perfil.nombre, publicacion.fecha
	FROM PerfilCanal
	INNER JOIN publicacion ON PerfilCanal.idPerfilCanal = publicacion.idPerfilCanal
	INNER JOIN perfil ON PerfilCanal.idPerfil = perfil.idPerfil
	WHERE PerfilCanal.idCanal = _idCanal
	ORDER BY publicacion.idPublicacion DESC;
END $$
DELIMITER ;

-- COMENTARIO PUBLICACION
DROP PROCEDURE IF EXISTS sp_comentarioPublicacion;
DELIMITER $$
CREATE PROCEDURE sp_comentarioPublicacion (
	IN _idPublicacion INT)
BEGIN
	SELECT comentario.idComentario, comentario.contenido, comentario.fecha,
		perfil.nombre, perfil.apellido
	FROM comentario
	INNER JOIN perfil ON comentario.idPerfil = perfil.idPerfil
	WHERE idPublicacion = _idPublicacion ;
END $$
DELIMITER ;

-- USUARIO PUBLICACION
DROP PROCEDURE IF EXISTS sp_usuarioPublicacion;
DELIMITER $$
CREATE PROCEDURE sp_usuarioPublicacion (
	IN _idPerfil INT)
BEGIN
	SELECT publicacion.idPublicacion, publicacion.fecha, publicacion.contenido,
		canal.descripcion
	FROM perfilcanal
	INNER JOIN publicacion ON perfilcanal.idPerfilCanal = publicacion.idPerfilCanal
	INNER JOIN  canal ON perfilcanal.idCanal = canal.idCanal
	WHERE perfilcanal.idPerfil = _idPerfil
    ORDER BY publicacion.idPublicacion DESC;
END $$
DELIMITER ;
