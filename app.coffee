express = require('express')
path = require('path')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
routes = require('./routes/index')
http = require 'http'
socketIo = require 'socket.io'
requireAll = require "require-all"
mongoose = require "mongoose"
global.Q = require "q"
_ = require "lodash"
global.Server = new (require "events").EventEmitter
global.ObjectId = mongoose.Types.ObjectId
# db
mongoose.connect "mongodb://localhost/travel3"

# app
app = express()
# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use express.static(path.join(__dirname, 'public'))
app.use '/', routes
# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
  return
# error handlers
# development error handler
# will print stacktrace
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

server = http.createServer app
io = socketIo(server)
server.listen 3000

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
        Server.emit "user.offline", socket.user
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
      Server.emit "user.online", user
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
