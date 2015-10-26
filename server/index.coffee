config = require "../config"
mongoose = require "mongoose"

# Connect DB
mongoose.connect config.db
global.ObjectId = mongoose.Types.ObjectId
global.toObject = (obj) ->
  obj.map (item) -> item.toObject()

# Models
global.Conversation = require "./models/Conversation"
global.Location = require "./models/Location"
global.Tag = require "./models/Tag"
global.User = require "./models/User"

# Controllers
require "./controllers/AdminController"
require "./controllers/ConversationController"
require "./controllers/FeedController"
require "./controllers/LocationController"
require "./controllers/ProfileController"
require "./controllers/UserController"

# Conversions
Api.tokenAuth = (token) ->
  User.findOne "token.value": token
Api.authID = (auth) ->
  if auth._id
    auth._id
  else
    auth
