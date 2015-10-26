express = require "express"
router = express.Router()

config = require "../config"
### GET home page. ###

router.get '/', (req, res, next) ->
  template = if config.development then "index" else "production"
  res.render template

router.get "/admin", (req, res, next) ->
  res.render "admin"

module.exports = router
