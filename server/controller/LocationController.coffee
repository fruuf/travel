_ = require "lodash"

module.exports =
  detail: (req) ->
    throw new Error "auth" if not req.user
    Location.findOne _id: req.data.location
    .then (location) ->
      User.find
        location: location._id
        _id:
          $ne: req.user._id
      .then (users) ->
        index = req.user.location.indexOf location._id
        users: users
        location: location
        status: not (index == -1)

  index: (req) ->
    throw new Error "auth" if not req.user
    Location.find
      _id:
        $in: req.user.location
    .then (locations) ->
      locations: locations

  setStatus: (req) ->
    throw new Error "auth" if not req.user
    Location.findOne _id:req.data.location
    .then (location) ->
      if req.data.status
        Tag.update
          location: location._id
          user:
            $ne: req.user._id
        ,
          $push:
            user: req.user._id
        .then ->
          User.update
            _id: req.user._id
            location:
              $ne: location._id
          ,
            $push:
              location: location._id
        .then ->
          yes

      else
        User.update _id: req.user._id,
          $pull:
            location: location._id
        .then ->
          yes
