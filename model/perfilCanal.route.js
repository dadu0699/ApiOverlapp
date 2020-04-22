var db = require('../bin/database.config')

var perfilCanal = {
    agregar: function(data, callback) {
        var query = 'CALL sp_agregarPerfilCanal(?, ?)'
        var values = [data.idPefil, data.idCanal]
        if (db) {
            db.query(query, values, function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    eliminar: function(id, callback) {
        if (db) {
            db.query('CALL sp_eliminarPerfilCanal(?)', [id], function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    }
}

module.exports = perfilCanal