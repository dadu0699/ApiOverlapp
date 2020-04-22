var db = require('../bin/database.config')

var canal = {
    agregar: function(data, callback) {
        var query = 'CALL sp_agregarCanal(?, ?, ?)'
        var values = [data.idEquipo, data.nombreCanal, data.descripcion]
        if (db) {
            db.query(query, values, function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    eliminar: function(id, callback) {
        if (db) {
            db.query('CALL sp_eliminarCanal(?)', [id], function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    },

    modificar: function(data, callback) {
        if (db) {
            var values = [data.idCanal, data.idEquipo, data.nombreCanal, data.descripcion]
            db.query('CALL sp_modificarCanal(?, ?, ?, ?)', values, function(err, results){
                if (err) throw err
                callback(results)
            })
        }
    },

    obetener: function(id, callback){
        if (db) {
            db.query('call sp_usuarioGrupo(?)', [id], function(err, results){
                if (err) throw err
                callback(results[0])
            })
        }
    }
}

module.exports = canal
