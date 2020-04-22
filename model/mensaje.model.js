var db = require('../bin/database.config')

var mensaje = {
    agregar: function(data, callback) {
        var query = 'CALL sp_agregarMensaje(?, ?)'
        var values = [data.idChat, data.contenido]
        if (db) {
            db.query(query, values, function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    eliminar: function(id, callback) {
        if (db) {
            db.query('CALL sp_eliminarMensaje(?)', [id], function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    }
}

module.exports = mensaje