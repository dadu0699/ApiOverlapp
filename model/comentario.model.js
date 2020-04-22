var db = require('../bin/database.config')

var comentario = {
    agregar: function(data, callback) {
        var query = 'CALL sp_agregarComentario(?, ?, ?)'
        var values = [data.idPublicacion, data.idPerfil, data.contenido]
        if (db) {
            db.query(query, values, function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    eliminar: function(id, callback) {
        if (db) {
            db.query('CALL sp_eliminarComentario(?)', [id], function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    modificar: function(data, callback) {
        if (db) {
            var values = [data.idComentario, data.contenido]
            db.query('CALL sp_modificarComentario(? , ?)', values, function(err, results){
                if (err) throw err
                callback(results)
            })
        }
    },

    obetener: function(id, callback){
        if (db) {
            db.query('call sp_comentarioPublicacion(?)', [id], function(err, results){
                if (err) throw err
                callback(results)
            })
        }
    }
}

module.exports = comentario