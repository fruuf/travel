express = require('express')
path = require('path')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
routes = require('./routes/index')
http = require 'http'
https = require "https"
requireAll = require "require-all"
mongoose = require "mongoose"
forceSSL = require 'express-force-ssl'
fs = require "fs"
global.Q = require "q"
_ = require "lodash"
delivery = require "delivery"

global.ObjectId = mongoose.Types.ObjectId
global.toObject = (obj) ->
  obj.map (item) -> item.toObject()

# SSL
###
sslOptions =
  key: fs.readFileSync "./ssl-key.pem"
  cert: fs.readFileSync "./ssl-cert.pem"
###
portOptions =
  http: 80
  https: 443

# db
mongoose.connect "mongodb://localhost/travel3"


# app
app = express()
# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
# app.use logger('dev')
# app.use bodyParser.json()
# app.use bodyParser.urlencoded(extended: false)
# app.use cookieParser()
# app.use forceSSL
app.use express.static(path.join(__dirname, 'public'))
app.use '/', routes
# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
  return


if app.get('env') == 'development'
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
      message: err.message
      error: err
    return
# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: {}
  return



app.set 'forceSSLOptions',
  # enable301Redirects: true
  # trustXFPHeader: false
  httpsPort: portOptions.https
  # sslRequiredMessage: 'SSL Required.


server = http.createServer app
#serverSecure = https.createServer sslOptions, app
global.Api = (require "api") server
# io = socketIo(serverSecure)
server.listen portOptions.http
#serverSecure.listen portOptions.https
console.log "listen to", portOptions


models = requireAll
  dirname: __dirname + '/server/models'
  filter: /(.+)\.coffee$/

for name, model of models
  global[name] = model

require "./server"

###
  fileUpload = delivery.listen socket
  fileUpload.on "receive.success", (file) ->
    # console.log "upload", file
    if socket.user
      Server.emit "user.upload",
        file: file
        user: socket.user
###
