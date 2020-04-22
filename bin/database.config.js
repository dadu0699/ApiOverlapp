var mysql = require('mysql')
var params = {
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'overlapp'
}

var conn = mysql.createConnection(params)

module.exports = conn