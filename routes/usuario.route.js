const express = require('express')
var router = express.Router()
const usuario = require('../model/usuario.model')
const service = require('../services/service')
const auth = require('./auth')

router.route('/api/v1/usuario')
    .post( (req, res) => {
        usuario.agregar(req.body, function(results){
            if (Object.keys(results).length){
                res.status(200).send({
                    mensaje: 'te has logeado correctamente',
                    token: `Bearer ${service.createToken(results)}`,
                    usuario: results,
                    estado: true
                })
            } else {
                res.json({estado: false})
            }
        })
    }
)

router.route('/api/v1/registrar')
    .post( (req, res) => {
        usuario.registrar(req.body, function(results){
            if (Object.keys(results).length){
                res.status(200).send({
                    mensaje: 'te has logeado correctamente',
                    token: `Bearer ${service.createToken(results)}`,
                    usuario: results,
                    estado: true
                })
            } else {
                res.json({estado: false})
            }
        })
    }
)

router.route('/api/v1/usuario/:id')
    .delete( auth, (req, res) => {
        usuario.eliminar(req.params.id, function(results){
            res.json({mensaje: 'usuario eliminado'})
        })
    })
    .put( auth, (req, res) => {
        req.body.id = req.params.id
        usuario.modificar(req.body, function(results){
            res.json(results)
        })
    }
)

router.route('/auth')
    .post( (req, res) => {
        usuario.login(req.body, function(results){
            if (results.length){
                res.status(200).send({
                    mensaje: 'te has logeado correctamente',
                    token: `Bearer ${service.createToken(results)}`,
                    usuario: results,
                    estado: true
                })
            } else {
                res.json({estado: false})
            }
        })
    }
)

module.exports = router;