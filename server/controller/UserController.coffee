randToken = require "rand-token"
bcrypt = require "bcrypt"

module.exports = class UserController
  constructor: ->
    Server.on "user.online", (user) ->
      User.update _id: user,
        online: yes
      .exec (err, res) ->
        User.find {}
        .exec (err, users) ->
          Server.send "user.update", users,
            _id: user
            online: yes


    Server.on "user.offline", (user) ->
      User.update _id: user,
        online: no
      .exec (err, res) ->
        User.find {}
        .exec (err, users) ->
          Server.send "user.update", users,
            _id: user
            online: no

  index: (data, send, user) ->
    if not user
      send err: "auth"
      return

    # access
    User.findOne
      _id: user
    .then (user) ->
      if user
        send
          user: user
      else
        send
          err: "notFound"

  findOne: (data, send, user) ->
    if not user
      send err: "auth"
      return

    # access
    User.findOne
      _id: data._id
    .then (user) ->
      if user
        send
          user: user
      else
        send
          err: "notFound"

  update: (data, send, user) ->
    if not user
      send err: "auth"
      return
    console.log "user", data
    # access
    User.update
      _id: user
    , data
    .exec()
    .then (res) ->
      send()

  login: (data, send) ->
    console.log data
    token = no
    User.findOne
      email: data.email
    .exec()
    .then (user) ->
      console.log user
      if user and bcrypt.compareSync(data.password, user.password)
        token = randToken.generate 50
        user.token.push
          value: token
        user.save (err, res) ->
          console.log err, res
          send
            token: token
      else
        send
          err: "login"


  register: (data, send) ->
    salt = bcrypt.genSaltSync(10);
    hash = bcrypt.hashSync(data.password, salt);
    User.create
      email: data.email
      password: hash
    , (err, user) ->
      if err
        send
          err: err
      else
        send
          user: user
