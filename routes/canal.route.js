const express = require('express')
var router = express.Router()
const canal = require('../model/canal.model')
const service = require('../services/service')
const auth = require('./auth')

router.route('/api/v1/canal')
    .post( auth, (req, res) => {
        canal.agregar(req.body, function(results){
            if (Object.keys(results).length){
                res.json(results)
            } else {
                res.json({estado: false})
            }
        })
    }
)

router.route('/api/v1/canal/:id')
    .delete( auth, (req, res) => {
        canal.eliminar(req.params.id, function(results){
            res.json({mensaje: 'canal eliminado'})
        })
    })

    .put( auth, (req, res) => {
        req.body.idCanal = req.params.id
        canal.modificar(req.body, function(results){
            res.json({mensaje: 'Modificado correctamente'})
        })
    })

    .get( auth, (req, res) => {
        canal.obetener(req.params.id, function(results){
            res.json(results)
        })
    })

module.exports = router;