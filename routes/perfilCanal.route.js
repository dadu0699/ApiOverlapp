const express = require('express')
var router = express.Router()
const perfilCanal = require('../model/perfilCanal.route')
const service = require('../services/service')
const auth = require('./auth')

router.route('/api/v1/perfilCanal')
    .post( auth, (req, res) => {
        perfilCanal.agregar(req.body, function(results){
            if (Object.keys(results).length){
                res.json(results)
            } else {
                res.json({estado: false})
            }
        })
    }
)

router.route('/api/v1/perfilCanal/:id')
    .delete( auth, (req, res) => {
        perfilCanal.eliminar(req.params.id, function(results){
            res.json({mensaje: 'perfilCanal eliminado'})
        })
    })

module.exports = router;