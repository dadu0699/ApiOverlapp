const express = require('express')
var router = express.Router()
const mensaje = require('../model/mensaje.model')
const service = require('../services/service')
const auth = require('./auth')

router.route('/api/v1/mensaje')
    .post( auth, (req, res) => {
        mensaje.agregar(req.body, function(results){
            if (Object.keys(results).length){
                res.json(results)
            } else {
                res.json({estado: false})
            }
        })
    }
)

router.route('/api/v1/mensaje/:id')
    .delete( auth, (req, res) => {
        mensaje.eliminar(req.params.id, function(results){
            res.json({mensaje: 'mensaje eliminado'})
        })
    }
)

module.exports = router;