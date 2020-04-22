var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Overlapp' });
});

router.get('/usuario', function(req, res, next) {
  res.render('usuario', {title: "API Usuario"});
});

router.get('/start', function(req, res, next) {
  res.render('start', {title: "API Usuario"});
});

router.get('/equipo', function(req, res, next) {
  res.render('equipo', {title: "API Usuario"});
});

router.get('/canal', function(req, res, next) {
  res.render('canal', {title: "API Usuario"});
});

router.get('/perfilcanal', function(req, res, next) {
  res.render('perfilCanal', {title: "API Usuario"});
});

router.get('/publicacion', function(req, res, next) {
  res.render('publicacion', {title: "API Usuario"});
});

router.get('/comentario', function(req, res, next) {
  res.render('comentario', {title: "API Usuario"});
});


module.exports = router;
