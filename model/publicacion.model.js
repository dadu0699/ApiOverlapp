var db = require('../bin/database.config')

var publicacion = {
    agregar: function(data, callback) {
        var query = 'CALL sp_agregarPublicacion(?, ?, ?)'
        var values = [data.idUsuario, data.idCanal, data.contenido]
        if (db) {
            db.query(query, values, function(err, results){
                if (err) throw err
                callback(results)
            })
        }
    },

    eliminar: function(id, callback) {
        if (db) {
            db.query('CALL sp_eliminarPublicacion(?)', [id], function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    modificar: function(data, callback) {
        if (db) {
            var values = [data.idPublicacion, data.contenido]
            db.query('CALL sp_modificarPublicacion(? , ?)', values, function(err, results){
                if (err) throw err
                callback(results)
            })
        }
    },

    obetener: function(id, callback){
        if (db) {
            db.query('call sp_canalPublicacion(?)', [id], function(err, results){
                if (err) throw err
                callback(results)
            })
        }
    },

    usuarioPublicacion : function(id, callback) {
        if (db) {
            db.query('call sp_usuarioPublicacion(?)', [id], function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    }
}

module.exports = publicacion