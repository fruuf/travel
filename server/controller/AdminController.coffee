

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
          "location.ref": ObjectId location._id
        .exec()
        .then (tag) ->
          send
            location: location
            tag: tag

    .then undefined, (err) ->
      send
        err: err

  locationEditSave: (data, send, user) ->
    @_isAdmin user
    .then ->
      Location.update
        _id: data._id
      , data
      .exec()
      .then (res) ->
        send()
    .then undefined, (err) ->
      send
        err: err
