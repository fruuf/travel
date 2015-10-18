express = require('express')
router = express.Router()
geoipLite = require "geoip-lite"
### GET home page. ###

router.get '/', (req, res, next) ->
  coords= no
  geo = geoipLite.lookup req.ip
  if geo
    coords =
      lat: geo.ll[0]
      lon: geo.ll[1]

  res.render 'index',
    coords: coords
  return
module.exports = router
