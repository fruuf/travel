_ = require "lodash"
api = new Api "location"


api.action "detail", (data, auth) ->
  throw new Error "auth" if not auth

  Location.findOne _id: data.location
  .then (location) ->
    console.log location
    User.find
      location: location._id
      _id:
        $ne: auth._id
    .then (users) ->
      console.log "user prototype", typeof users
      index = auth.location.indexOf location._id
      users: users
      location: location
      status: not (index == -1)
  .then (res) ->
    console.log res
    res

api.action "", (data, auth) ->
  throw new Error "auth" if not auth
  Location.find
    _id:
      $in: auth.location
  .then (locations) ->
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
