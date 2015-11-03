api = new Api "admin"
_ = require "lodash"

api.action "auth", (data, auth) ->
  if auth?.admin
    auth: auth.id
  else
    auth: no


api.action "location", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.findAll
    include: [Tag, Image]
  .then (locations) ->
    locations: locations

api.action "location/add", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.create
    name: data.name
  .then (location) ->
    location: location


api.action "location/detail", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.findById data.location,
    include: [Tag, Image]
  .then (location) ->
    Tag.findAll()
    .then (tags) ->
      location: location
      tags: tags

api.action "location/image/add", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.findById data.location
  .then (location) ->
    Image.create()
    .then (image) ->
      image.setFile data.file
    .then (image) ->
      location.addImage image

api.action "location/image/destroy", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.findById data.location
  .then (location) ->
    Image.findById data.image
    .then (image) ->
      location.removeImage image

api.action "location/image/primary", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.findById data.location,
    include: [Image]
  .then (location) ->
    for image in location.Image
      image.primary = no
      image.save()
    Image.findById data.image
    .then (image) ->
      image.primary = yes
      image.save()

api.action "location/update", (data, auth) ->
  throw new Error "auth" if not auth?.admin
  Location.findById data.id
  .then (location) ->
    location.update data
  .then (location) ->
    if data.file
      Image.create()
      .then (image) ->
        image.setFile data.file
      .then (image) ->
        location.addImage location
    else
      no
  .then ->
    Location.findById data.id,
      include: [Image, Tag]
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
