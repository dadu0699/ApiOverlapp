const express = require('express')
var router = express.Router()
const equipo = require('../model/equipo.model')
const service = require('../services/service')
const auth = require('./auth')

router.route('/api/v1/equipo')
    .post( auth, (req, res) => {
        equipo.agregar(req.body, function(results){
            if (Object.keys(results).length){
                res.json(results)
            } else {
                res.json({estado: false})
            }
        })
    }
)

router.route('/api/v1/equipo/:id')
    .delete( auth, (req, res) => {
        equipo.eliminar(req.params.id, function(results){
            res.json({mensaje: 'equipo eliminado'})
        })
    })

    .put( auth, (req, res) => {
        req.body.id = req.params.id
        equipo.modificar(req.body, function(results){
            res.json({mensaje: 'Modificado correctamente'})
        })
    }
)

module.exports = router;