randToken = require "rand-token"
bcrypt = require "bcrypt"
fs  = require "fs"
path = require "path"

Server.on "user.upload", (data) ->
  filename = path.join process.cwd(), "public/files", "#{data.user}.jpg"
  fs.writeFile filename, data.file.buffer, ->

Server.on "user.location", (data) ->
  User.update _id: data.user,
    coords: data.coords
  .exec()

module.exports =
  index: (req) ->
    throw new Error "auth" if not req.user
    User.findOne
      _id: req.user._id
    .then (user) ->
      # console.log "user", user
      profile: user

  update: (req) ->
    throw new Error "auth" if not req.user
    User.update _id: req.user._id, req.data
    .then (res) ->
      yes

  register: (req) ->
    salt = bcrypt.genSaltSync(10);
    hash = bcrypt.hashSync(req.data.password, salt)
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
      email: req.data.email
      password: hash
      name: name
    .then (user) ->
      profile: user

  login: (req) ->
    token = no
    User.findOne
      email: req.data.email
    .then (user) ->
      if not user or not bcrypt.compareSync(req.data.password, user.password)
        throw new Error "invalid login"

      token = randToken.generate 50
      User.update _id: user._id,
        $push:
          token:
            value: token
      .then ->
        token: token
