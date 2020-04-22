const express = require('express')
var router = express.Router()
const chat = require('../model/chat.model')
const service = require('../services/service')
const auth = require('./auth')

router.route('/api/v1/chat')
    .post( auth, (req, res) => {
        chat.agregar(req.body, function(results){
            if (Object.keys(results).length){
                res.json(results)
            } else {
                res.json({estado: false})
            }
        })
    }
)

router.route('/api/v1/chat/:id')
    .delete( auth, (req, res) => {
        chat.eliminar(req.params.id, function(results){
            res.json({mensaje: 'chat eliminado'})
        })
    }
)

module.exports = router;