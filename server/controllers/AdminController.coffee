imageModule = require "../modules/image"
api = new Api "admin"

api.action "auth", (data, auth) ->
  if auth?.admin
    auth: auth._id
  else
    auth: no

api.action "location", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.find {}
  .then (locations) ->
    Tag.find {}
    .then (tags) ->
      locations: locations
      tags: tags

api.action "location/add", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.create
    name: data.name
  .then (location) ->
    location: location

api.action "location/detail", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.findOne
    _id: data.location
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


api.action "location/update", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  delete data.image
  Location.findOne _id: data._id
  .then (location) ->
    console.log data
    if data.file
      if location.image
        imageModule.remove location.image
      imageModule.save data.file
    else
      no
  .then (image) ->
    if image
      data.image = image
    Location.update
      _id: data._id
    , data
  .then (res) ->
    Location.findOne _id: data._id
  .then (location) ->
    location: location



api.action "tag/add", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  throw new Error "tag name missing" if not data.name

  Tag.findOne
    name: data.name
  .then (tag) ->
    throw new Error "tag exists" if tag
    Tag.create
      name: data.name
    .then (tag) ->
      tag: tag

api.action "tag/location", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.findOne _id: data.location
  .then (location) ->
    throw new Error "location not found" if not location
    if data.status
      Tag.update _id: data.tag,
        $push:
          location: location._id
      .then ->
        yes
    else
      Tag.update _id: data.tag,
        $pull:
          location: location._id
      .then ->
        yes
