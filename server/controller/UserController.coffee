randToken = require "rand-token"
bcrypt = require "bcrypt"
fs  = require 'fs'
path = require "path"
_ = require "lodash"
distance = require "../includes/distance"

Server.on "user.online", (data) ->
  User.update _id: data.user,
    online: yes
  .then ->
    User.find {}
  .then (users) ->
    Server.send "user.update", users,
      _id: data.user
      online: yes

Server.on "user.offline", (data) ->
  User.update _id: data.user,
    online: no
  .then ->
    User.find {}
  .then (users) ->
    Server.send "user.update", users,
      _id: data.user
      online: no

module.exports =
  detail: (req) ->
    throw new Error "auth" if not req.user
    User.findOne
      _id: req.data.user
    .then (user) ->
      intersection = _.intersection req.user.location, user.location
      Location.find
        _id:
          $in: intersection
      .then (locations) ->
        user: user
        locations: locations
        distance: distance.calculate req.user.coords, user.coords
