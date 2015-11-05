randToken = require "rand-token"
bcrypt = require "bcrypt"
path = require "path"
api = new Api "profile"
q = require "q"
imageModule = require "../modules/image"
geoipLite = require "geoip-lite"





api.action "", (data, auth) ->
  throw new Error "auth" if not auth
  User.findOne
    _id: auth._id
  .then (user) ->
    api.request user, "location"
    .then (data) ->
      User.update _id: user._id,
        coords: data.coords
      .then ->
        console.log "coords updated to", data.coords
    profile: user

api.action "auth", (data, auth) ->
  if auth
    email: auth.email
    auth: auth._id
  else if data.email
    User.findOne email: data.email.toLowerCase()
    .then (user) ->
      if user
        auth: no
        email: user.email
      else
        auth: no
        email: no
  else
    auth: no
    email: no




api.action "update", (data, auth) ->
  throw new Error "auth" if not auth

  image = no
  if data.file
    if auth.image
      imageModule.remove auth.image
    image = imageModule.save data.file

  q image
  .then (image) ->
    Api.filter data, ["name", "country", "profession", "about"]
    if image
      data.image = image
    User.update _id: auth._id, data
  .then (res) ->
    User.findOne _id: auth._id
  .then (profile) ->
    profile: profile

api.action "register", (data, auth, handshake) ->
  if not data.name or not data.file or not data.password or not data.email
    throw new Error "information missing"
  salt = bcrypt.genSaltSync(10)
  hash = bcrypt.hashSync(data.password, salt)
  token = Api.generateToken()

  imageModule.save data.file
  .then (image) ->
    coords= []
    geo = geoipLite.lookup handshake.address
    console.log "geo", geo, handshake
    if geo
      coords = [geo.ll[1], geo.ll[0]]
      console.log "geoCoords", coords
    User.create
      email: data.email.toLowerCase()
      password: hash
      name: data.name
      image: image
      location: coords

  .then (user) ->
    user.token.push
      value: token
    user.save()
  .then ->
    token: token

api.action "login", (data) ->
  User.findOne
    email: data.email.toLowerCase()
  .then (user) ->
    if not user or not bcrypt.compareSync(data.password, user.password)
      throw new Error "invalid login"

    token = Api.generateToken()
    User.update _id: user._id,
      $push:
        token:
          value: token
    .then ->
      User.findOne _id: user._id
      .then (user) ->
        console.log token, user
    .then ->
      token: token
