var db = require('../bin/database.config')

var chat = {
    agregar: function(data, callback) {
        var query = 'CALL sp_agregarChat(?, ?, ?)'
        var values = [data.idEmisor, data.idReceptor]
        if (db) {
            db.query(query, values, function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    eliminar: function(id, callback) {
        if (db) {
            db.query('CALL sp_eliminarChat(?)', [id], function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    }
}

module.exports = chat