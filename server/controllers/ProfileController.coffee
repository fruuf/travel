path = require "path"
api = new Api "profile"
q = require "q"
geoipLite = require "geoip-lite"

###

###





api.action "", (data, auth, handshake) ->
  throw new Error "auth" if not auth
  console.log auth
  User.findById auth.id
  .then (user) ->
    api.request user, "location", 2000
    .then (data) ->
      user.position =
        type: "point"
        coordinates: data.coords
      console.log data.coords
      user.save()
    , (err) ->

      coords= []
      geo = geoipLite.lookup handshake.address
      if geo
        coords = [geo.ll[1], geo.ll[0]]
        console.log "geoipLite", coords
        user.position =
          type: "point"
          coordinates: coords
        user.save()
    .then (user) ->
      console.log "coords updated to #{user.position}"
    profile: user

api.action "auth", (data, auth) ->
  if auth
    email: auth.email
    auth: auth.id
  else if data.email
    User.findOne
      where:
        email: data.email
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

  auth.getImage()
  .then (image) ->
    if image and data.file
      image.destroy()
    if data.file
      auth.createImage()
      .then (image) ->
        image.setFile data.file
    else
      yes
  .then ->
    auth.update data
  .then (profile) ->
    profile: profile

api.action "register", (data) ->
  if not data.name or not data.file or not data.password or not data.email
    throw new Error "information missing"


  User.create
    email: data.email
    name: data.name
  .then (user) ->
    user.setPassword data.password
  .then (user) ->
    Image.create
      primary: yes
    .then (image) ->
      image.setFile data.file
    .then (image) ->
      user.addImage image
    .then ->
      user

  .then (user) ->
    Token.create()
    .then (token) ->
      token.setUser user
    .then (token) ->
      token: token.value


api.action "login", (data) ->
  User.findOne
    where:
      email: data.email
  .then (user) ->
    if not user or not data.password or not user.verifiyPassword data.password
      throw new Error "invalid login"

    Token.create()
    .then (token) ->
      token.setUser user
    .then (token) ->
      token: token.value
