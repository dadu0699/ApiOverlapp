var db = require('../bin/database.config')

var equipo = {
    agregar: function(data, callback) {
        var query = 'CALL sp_agregarEquipo(?)'
        var values = [data.nombreEquipo]
        if (db) {
            db.query(query, values, function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    eliminar: function(id, callback) {
        if (db) {
            db.query('CALL sp_eliminarEquipo(?)', [id], function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    modificar: function(data, callback) {
        if (db) {
            var values = [data.idEquipo, data.nombreEquipo]
            db.query('CALL sp_modificarEquipo(? , ?)', values, function(err, results){
                if (err) throw err
                callback(results)
            })
        }
    }
}

module.exports = equipo