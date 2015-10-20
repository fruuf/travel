_ = require "lodash"

module.exports = class LocationController
  index: (data, send, user) ->
    if not user
      send:
        err: "auth"
      return
    else
      User.findOne _id: user
      .then (user) ->
        Location.findOne _id: data.location
        .then (location) ->
          User.find
            location: location._id
          .then (users) ->
            status = no
            index = user.location.indexOf location._id
            if not (index == -1)
              status = yes
            send
              user: users
              location: location
              status: status

      .then undefined, (err) ->
        send
          err: err

  setStatus: (data, send, user) ->
    if not user
      send:
        err: "auth"
      return
    else
      console.log data
      Location.findOne _id:data.location
      .then (location) ->
        User.findOne _id: user
        .then (user) ->
          if data.status
            Tag.update
              location: location._id
              user:
                $ne: user._id
            ,
              $push:
                user: user._id
            .then ->
              User.update
                _id: user._id
                location:
                  $ne: location._id
              ,
                $push:
                  location: location._id
            .then ->
              send()
          else
            console.log "status:false"
            User.update _id: user._id,
              $pull:
                location: location._id
            .then (res) ->
              console.log res
              send()
