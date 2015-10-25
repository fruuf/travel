require "./controllers/AdminController"
require "./controllers/ConversationController"
require "./controllers/FeedController"
require "./controllers/LocationController"
require "./controllers/ProfileController"
require "./controllers/UserController"

Api.tokenAuth = (token) ->
  User.findOne "token.value": token
Api.authID = (auth) ->
  console.log auth
  if auth._id
    auth._id
  else
    auth
