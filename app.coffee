express = require('express')
path = require('path')
routes = require('./routes/index')
http = require 'http'
https = require "https"
forceSSL = require 'express-force-ssl'
fs = require "fs"
_ = require "lodash"
config = require "./config"


app = express()
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
if config.ports.https
  app.use forceSSL
app.use express.static(path.join(__dirname, 'public'))
app.use '/', routes
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message: err.message

app.set 'forceSSLOptions',
  httpsPort: config.ports.https

server = http.createServer app
server.listen config.ports.http

if config.ports.https
  sslOptions =
    key: fs.readFileSync config.sslOptions.key
    cert: fs.readFileSync config.sslOptions.cert

  serverSecure = https.createServer sslOptions, app
  serverSecure.listen config.ports.https
  global.Api = (require "api") serverSecure
  console.log "listen to http at port #{config.ports.http} and https at port #{config.ports.https}"
else
  global.Api = (require "api") server
  console.log "listen to http at port #{config.ports.http}"

require "./server"
