const express = require('express')
var router = express.Router()
const comentario = require('../model/comentario.model')
const service = require('../services/service')
const auth = require('./auth')

router.route('/api/v1/comentario')
    .post( auth, (req, res) => {
        comentario.agregar(req.body, function(results){
            if (Object.keys(results).length){
                res.json(results)
            } else {
                res.json({estado: false})
            }
        })
    }
)

router.route('/api/v1/comentario/:id')
    .delete( auth, (req, res) => {
        comentario.eliminar(req.params.id, function(results){
            res.json({mensaje: 'comentario eliminado'})
        })
    })

    .put( auth, (req, res) => {
        req.body.id = req.params.id
        comentario.modificar(req.body, function(results){
            res.json({mensaje: 'Modificado correctamente'})
        })
    })

    .get( auth, (req, res) => {
        comentario.obetener(req.params.id, function(results){
            res.json(results)
        })
    })

module.exports = router;