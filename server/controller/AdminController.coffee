

module.exports = class AdminController
  constructor: ->
    @_adminCache = {}

  _isAdmin: (user) ->
    deferred = Q.defer()
    if not user
      deferred.reject "auth"
    else
      User.findOne _id: user
      .exec()
      .then (user) ->
        if user and user.admin == true
          deferred.resolve user
        else
          deferred.reject "admin_auth"
      .then undefined, (err) ->
        deferred.reject "mongo"
    deferred.promise

  location: (data, send, user) ->
    @_isAdmin user
    .then ->
      Location.find {}
      .exec()
      .then (locations) ->
        Tag.find {}
        .then (tags) ->
          send
            location: locations
            tag: tags
    .then undefined, (err) ->
      send
        err: err

  locationAdd: (data, send, user) ->
    @_isAdmin user
    .then ->
      Location.create
        name: data.name
      .then (location) ->
        send
          location: location
    .then undefined, (err) ->
      send
        err: err

  locationEditLoad: (data, send, user) ->
    @_isAdmin user
    .then ->
      Location.findOne
        _id: data.location
      .then (location) ->
        Tag.find
          "location.ref":
            $ne: location._id
        .then (tagDisabled) ->
          Tag.find
            "location.ref": location._id
          .then (tagEnabled) ->
            send
              location: location
              tagEnabled: tagEnabled
              tagDisabled: tagDisabled

    .then undefined, (err) ->
      send
        err: err

  locationEditSave: (data, send, user) ->
    @_isAdmin user
    .then ->
      Location.update
        _id: data._id
      , data
      .then (res) ->
        send()

    .then undefined, (err) ->
      send
        err: err

  locationAddTag: (data, send, user) ->
    @_isAdmin user
    .then ->
      # console.log "tag", data
      if not data.name
        throw new Exception "no name"

      Tag.findOne
        name: data.name
      .then (tag) ->
        if not tag
          Tag.create
            name: data.name
          .then (tag) ->
            send
              tag: tag
        else
          send
            err: "exists"

    .then undefined, (err) ->
      send
        err: err

  locationSetTag: (data, send, user) ->
    @_isAdmin user
    .then ->
      Location.findOne _id: data.location
      .then (location) ->
        if not location
          send
            err: "location"
        else if data.status
          Tag.update _id: data.tag,
            $push:
              location:
                ref: location._id
                # coords: location.coords
                multiplier: 1
          .then ->
            send()
        else
          Tag.update _id: data.tag,
            $pull:
              location:
                ref: location._id
          .then ->
            send()

    .then undefined, (err) ->
      console.log err
      send
        err: err
