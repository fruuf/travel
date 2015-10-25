randToken = require "rand-token"
bcrypt = require "bcrypt"
fs  = require "fs"
path = require "path"
api = new Api "profile"
sharp = require 'sharp'


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
    auth: auth._id
  else
    auth: no


api.action "update", (data, auth) ->
  throw new Error "auth" if not auth

  if data.file
    imagePath = path.join process.cwd(), "public"
    nameSmall = "/files/#{auth._id}_small.jpeg"
    nameMedium = "/files/#{auth._id}_medium.jpeg"
    nameLarge = "/files/#{auth._id}_large.jpeg"

    data.image =
      small: nameSmall
      medium: nameMedium
      large: nameLarge

    image = sharp data.file
    .jpeg()
    .quality 90

    image
    .resize 200, 200
    .toFile "#{imagePath}#{nameSmall}"

    image
    .resize 400, 400
    .toFile "#{imagePath}#{nameMedium}"

    image
    .resize 600, 600
    .toFile "#{imagePath}#{nameLarge}"

  User.update _id: auth._id, data
  .then (res) ->
    User.findOne _id: auth._id
  .then (profile) ->
    profile: profile

api.action "register", (data, auth) ->
  salt = bcrypt.genSaltSync(10)
  hash = bcrypt.hashSync(data.password, salt)
  ###
  match = req.data.email.match /^(.+)@/
  name = req.data.email
  if match
    name = match[1].replace /[\._-]/g, " "
      .replace /\s+/g, " "
      .split " "
      .map (word) ->
        word = word.toLowerCase()
        "#{word.charAt(0).toUpperCase()}#{word.slice 1}"
      .join " "
  ###

  name = "New Profile"
  User.create
    email: data.email
    password: hash
    name: name
  .then (user) ->
    profile: user

api.action "login", (data) ->
  User.findOne
    email: data.email
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
