config = require "../config"
mongoose = require "mongoose"


# Connect DB
mongoose.connect config.db
global.ObjectId = mongoose.Types.ObjectId
global.toObject = (obj) ->
  obj.map (item) -> item.toObject()

require "./models"


# Controllers
require "./controllers/AdminController"
require "./controllers/ConversationController"
require "./controllers/FeedController"
require "./controllers/LocationController"
require "./controllers/ProfileController"
require "./controllers/UserController"

# Conversions
Api.debug = yes
Api.tokenAuth = (token) ->
  if not token
    return null
  Token.findOne
    where:
      value: token
    include: [User]
  .then (token) ->
    token?.User or null

Api.authID = (auth) ->
  auth.id
