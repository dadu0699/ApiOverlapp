const express = require('express')
var router = express.Router()
const publicacion = require('../model/publicacion.model')
const service = require('../services/service')
const auth = require('./auth')

router.route('/api/v1/publicacion')
    .post( auth, (req, res) => {
        publicacion.agregar(req.body, function(results){
            if (Object.keys(results).length){
                res.json(results)
            } else {
                res.json({estado: false})
            }
        })
    }
)

router.route('/api/v1/publicacion/:id')
    .delete( auth, (req, res) => {
        publicacion.eliminar(req.params.id, function(results){
            res.json({mensaje: 'publicacion eliminado'})
        })
    })

    .put( auth, (req, res) => {
        req.body.id = req.params.id
        publicacion.modificar(req.body, function(results){
            res.json({mensaje: 'Modificado correctamente'})
        })
    })

    .get(auth, (req, res) => {
        publicacion.obetener(req.params.id, function(results){
            res.json(results)
        })
    })

router.route('/api/v1/publicacion/usuario/:id')
    .get( auth, (req, res) => {
        publicacion.usuarioPublicacion(req.params.id, function(results){
            res.json(results)
        })
    })

module.exports = router;