var db = require('../bin/database.config')

var usuario = {
    login: function(data, callback) {
        if (db){
            db.query('CALL sp_login(?,?)', [data.correo, data.contrasena], function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    agregar: function(data, callback) {
        var query = 'CALL sp_agregarUsuario(?, ?, ?, ?, ?, ?)'
        var values = [data.nombreEquipo, data.correo, data.contrasena, data.nombre, data.apellido, data.telefono]
        if (db) {
            db.query(query, values, function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    registrar: function(data, callback) {
        var query = 'CALL sp_registrarUsuario(?, ?, ?, ?, ?, ?)'
        var values = [data.nombreEquipo, data.correo, data.contrasena, data.nombre, data.apellido, data.telefono]
        if (db) {
            db.query(query, values, function(err, results){
                if (err) throw err
                callback(results)
            })
        }
    },

    eliminar: function(id, callback) {
        if (db) {
            db.query('CALL sp_eliminarUsuario(?)', [id], function(err, results){
                if (err) throw err
                callback(results)
            })
        }
    },

    modificar: function(data, callback) {
        if (db) {
            var values = [data.id, data.correo, data.contrasena, data.nombre, data.apellido, data.telefono]
            db.query('CALL sp_modificarUsuario( ?, ?, ?, ?, ?, ?)', values, function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    }
}

module.exports = usuario