express = require('express')
path = require('path')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
routes = require('./routes/index')
http = require 'http'
https = require "https"
socketIo = require 'socket.io'
requireAll = require "require-all"
mongoose = require "mongoose"
forceSSL = require 'express-force-ssl'
fs = require "fs"
global.Q = require "q"
_ = require "lodash"
global.Server = new (require "events").EventEmitter
global.ObjectId = mongoose.Types.ObjectId

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
  portOptions =
    http: 3000
    https: 3443

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
io = socketIo(server)
# io = socketIo(serverSecure)
server.listen portOptions.http
#serverSecure.listen portOptions.https
console.log "listen to", portOptions
# Load
controllers = requireAll
  dirname: __dirname + '/server/controller'
  filter: /(.+Controller)\.coffee$/

models = requireAll
  dirname: __dirname + '/server/model'
  filter: /(.+)\.coffee$/



userStore = {}

userStoreRemove = (socket) ->
  if socket.user
    index = userStore[socket.user].indexOf socket
    if not (index == -1)
      userStore[socket.user].splice index, 1
      if userStore[socket.user].length == 0
        Server.emit "user.offline",
          user: socket.user
      socket.user = no
      yes
  no

userStoreAdd = (socket, user) ->
  if not userStore[user]
    userStore[user] = []

  socket.user = user
  index = userStore[socket.user].indexOf socket
  if index == -1
    if userStore[user].length == 0
      Server.emit "user.online",
        user: user
    userStore[user].push socket
    if userStore[socket.user].length == 0
      userStore[socket.user]
    yes
  no


global.Server.send  = (type, users, data = {}) ->
  if not _.isArray users
    users = [users]

  for user in users
    if user._id
      user = user._id

    sockets = userStore[user] or []
    for socket in sockets
      socket.emit "server",
        type: type
        data: data

console.log "controllers", Object.keys controllers
console.log "models", Object.keys models

for name, model of models
  global[name] = model

for name, controller of controllers
  global[name] = new controller()


io.on 'connection', (socket) ->
  socket.user = no

  socket.on "disconnect", ->
    userStoreRemove socket

  socket.on "location", (req) ->
    Server.emit "user.location",
      user: socket.user
      coords: req

  socket.on 'request', (req) ->
    targetArray = req.target.split "/"
    controller = "#{targetArray[0][0].toUpperCase() + targetArray[0].slice(1)}Controller"
    action = targetArray[1] or "index"
    user = socket.user
    response = (data = {}) ->
      socket.emit "response",
        id: req.id
        data: data
    global[controller][action] req.data, response, user

  socket.on "token", (req) ->
    User.findOne
      "token.value": req.token
    .exec()
    .then (user) ->
      if user
        userStoreAdd socket, user.id
        console.log "valid token", user.id, req.token
        #user.admin = yes
        #user.save()
        socket.emit "token",
          user: user.id
      else
        userStoreRemove socket
        socket.emit "token",
          err:"err_token"

      if req.oldToken
        User.update
            "token.value": req.oldToken
          ,
            $pull:
              'token':
                value: req.oldToken
        .exec()
        .then (res) ->
          console.log "rem_token", req.oldToken
