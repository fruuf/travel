randToken = require "rand-token"
bcrypt = require "bcrypt"
fs  = require 'fs'
path = require "path"
_ = require "lodash"
distanceModule = require "../modules/distance"
api = new Api "user"


Api.on "online", (auth) ->
  User.update _id: auth._id,
    online: yes
  .then ->
    User.find {}
  .then (users) ->
    for user in users
      api.notify user, "update",
        _id: auth._id
        online: yes

Api.on "offline", (auth) ->
  User.update _id: auth._id,
    online: no
  .then ->
    User.find {}
  .then (users) ->
    for user in users
      api.notify user, "update",
        _id: auth._id
        online: no

api.action "detail", (data, auth) ->
  throw new Error "auth" if not auth
  User.findOne
    _id: data.user
  .then (user) ->
    authLocations = auth.location.map (item) -> String item
    userLocations = user.location.map (item) -> String item
    intersection = _.intersection authLocations, userLocations
    Location.find
      _id:
        $in: intersection
    .then (locations) ->
      user = distanceModule user, auth
      locations = locations.map (location) -> distanceModule location, auth
      user: user
      locations: locations

api.filter "detail",
  user: ["name", "_id", "profession", "about", "online", "image", "country", "distance"]
  locations: yes
