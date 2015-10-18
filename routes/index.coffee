express = require('express')
router = express.Router()
geoipLite = require "geoip-lite"
### GET home page. ###

router.get '/', (req, res, next) ->
  coords= []
  geo = geoipLite.lookup req.ip
  if geo
    coords = [geo.ll[1], geo.ll[0]]

  res.render 'index',
    coords: coords
  return
module.exports = router
