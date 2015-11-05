_ = require "lodash"
api = new Api "location"
distanceModule = require "../modules/distance"

api.action "detail", (data, auth) ->
  throw new Error "auth" if not auth

  Location.findOne _id: data.location
  .then (location) ->
    location = distanceModule location, auth
    User.find
      location: location._id
      _id:
        $ne: auth._id
    .then (users) ->
      users = users.map (user) -> distanceModule user, auth
      index = auth.location.indexOf location._id
      users: users
      location: location
      status: not (index == -1)

api.action "", (data, auth) ->
  throw new Error "auth" if not auth
  Location.find
    _id:
      $in: auth.location
  .then (locations) ->
    console.log locations
    locations = locations.map (location) -> distanceModule location, auth
    console.log locations
    locations: locations

api.action "status", (data, auth) ->
  throw new Error "auth" if not auth


  Location.findOne _id:data.location
  .then (location) ->
    if data.status
      Tag.update
        location: location._id
        user:
          $ne: auth._id
      ,
        $push:
          user: auth._id
      .then ->
        User.update
          _id: auth._id
          location:
            $ne: location._id
        ,
          $push:
            location: location._id
      .then ->
        yes

    else
      User.update _id: auth._id,
        $pull:
          location: location._id
      .then ->
        yes
