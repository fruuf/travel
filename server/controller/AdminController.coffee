

module.exports =
  location: (req) ->
    throw new Error "auth" if not req.user?.admin
    Location.find {}
    .then (locations) ->
      Tag.find {}
      .then (tags) ->
        locations: locations
        tags: tags

  locationAdd: (req) ->
    throw new Error "auth" if not req.user?.admin
    Location.create
      name: req.data.name
    .then (location) ->
      location: location

  locationDetail: (req) ->
    throw new Error "auth" if not req.user?.admin
    Location.findOne
      _id: req.data.location
    .then (location) ->
      Tag.find
        location:
          $ne: location._id
      .then (tagDisabled) ->
        Tag.find
          location: location._id
        .then (tagEnabled) ->
          location: location
          tagEnabled: tagEnabled
          tagDisabled: tagDisabled


  locationUpdate: (req) ->
    Location.update
      _id: req.data._id
    , req.data
    .then (res) ->
      yes

  locationAddTag: (req) ->
    throw new Error "auth" if not req.user?.admin
    throw new Error "no name" if not req.data.name

    Tag.findOne
      name: req.data.name
    .then (tag) ->
      throw new Error "exists" if tag
      Tag.create
        name: req.data.name
      .then (tag) ->
        tag: tag

  locationSetTag: (req) ->
    throw new Error "auth" if not req.user?.admin
    Location.findOne _id: req.data.location
    .then (location) ->
      throw new Error "location not found" if not location
      if req.data.status
        Tag.update _id: req.data.tag,
          $push:
            location: location._id
        .then ->
          yes
      else
        Tag.update _id: req.data.tag,
          $pull:
            location: location._id
        .then ->
          yes
