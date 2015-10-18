randToken = require "rand-token"
bcrypt = require "bcrypt"

module.exports = class UserController
  constructor: ->
    Server.on "user.online", (data) ->
      User.update _id: data.user,
        online: yes
      .exec()
      .then ->
        User.find {}
        .exec()
      .then (users) ->
        Server.send "user.update", users,
          _id: data.user
          online: yes


    Server.on "user.offline", (data) ->
      User.update _id: data.user,
        online: no
      .exec()
      .then ->
        User.find {}
        .exec()
      .then (users) ->
        Server.send "user.update", users,
          _id: data.user
          online: no

    Server.on "user.location", (data) ->
      User.update _id: data.user,
        coords: data.coords
      .exec()

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
    match = data.email.match /^(.+)@/
    name = data.email
    if match
      name = match[1].replace /[\._-]/g, " "
        .replace /\s+/g, " "
        .split " "
        .map (word) ->
          word = word.toLowerCase()
          "#{word.charAt(0).toUpperCase()}#{word.slice 1}"
        .join " "

    User.create
      email: data.email
      password: hash
      name: name
    , (err, user) ->
      if err
        send
          err: err
      else
        send
          user: user
