distance = require "../includes/distance"
_ = require "lodash"
api = new Api "feed"

getDistanceRating = (distance, halfDistance = 10) ->
   base = Math.pow 0.5, (1 / halfDistance)
   dist = distance / 1000
   Math.pow base, dist

api.action "", (data, auth) ->
  throw new Error "auth" if not auth

  # auth
  feed = []
  feedUser = []
  feedLocation = []

  ratingStoreUser =
    online:
      max:1
      rating:1
    distance:
      max:1
      rating: 1
    location:
      max:0
      rating: 3

  ratingStoreLocation =
    tag:
      max:0
      rating: 1
    user:
      max: 0
      rating: 1
    distance:
      max:1
      rating: 1



  locationStore = {}
  userStore = {}
  getLocationEntry = (id) ->
    if not locationStore[id]
      locationStore[id] =
        user: 0
        tag: 0
        self: no
    locationStore[id]


  getUserEntry = (id) ->
    if not userStore[id]
      userStore[id] =
        location: 0
        online: 0
    userStore[id]



  for location in auth.location
    entry = getLocationEntry location
    entry.self = yes

  # Needs rework
  tagDna = {}
  Tag.find user: auth._id
  .then (tags) ->
    for tag in tags
      tagDna[tag._id] = 1 / tags.length

    # nearby online users
    if auth.coords and auth.coords.length
      User.find
        coords:
          $nearSphere : auth.coords
          # $maxDistance : 5 / 6400
        _id:
          $ne: auth._id
        # online: yes
      .limit 5
    else
      []
  .then (userNearList) ->
    # console.log "userNear", userNearList
    for user in userNearList
      userEntry = getUserEntry user._id
      if user.online
        userEntry.online = 1

    # User who like same location
    User.find
      location:
        $in: auth.location
  .then (userLocations) ->
    # console.log "userLocations", userLocations
    for user in userLocations
      # console.log "user", user
      entryUser = getUserEntry user._id
      #entryUser.locationSum = user.location.length
      #entryUser.coords = user.coords
      if user.online
        entryUser.online = 1

      for location in user.location
        # console.log "location", location
        entryLocation = getLocationEntry location
        # if users like same location push user ratio
        if entryLocation.self
          entryUser.location = entryUser.location + 1
        else
          entryLocation.user = entryLocation.user + 1

    #console.log "finished"
    # Find users Tags and rate locations based on DNA
    Tag.find
      "user": auth._id
  .then (userTags) ->
    # console.log "userTags", userTags
    for tag in userTags
      for location in tag.location
        entryLocation = getLocationEntry location
        entryLocation.tag = entryLocation.tag + (tagDna[tag._id] / tag.location.length)

    # Find nearby locations that havent been checked
    if auth.coords and auth.coords.length
      Location.find
        coords:
          $nearSphere : auth.coords
        _id:
          $nin: auth.location
      .limit 5
    else
      []
  .then (locationNear) ->
    # console.log "locationNear", locationNear
    for location in locationNear
      entryLocation = getLocationEntry location._id


    # Fill the ids with documents
    userIdList = Object.keys userStore
    # _.difference (), [String ]
    # console.log "userIdList", userIdList, [auth._id]
    User.find
      _id:
        $in: userIdList
        $nin: [auth._id]
  .then (userList) ->
    for user in userList
      reason = getUserEntry user._id
      dist = distance.calculate auth.coords, user.coords
      if dist
        reason.distance = getDistanceRating dist.distance
      else
        reason.distance = 0


      if ratingStoreUser.location.max < reason.location
        ratingStoreUser.location.max = reason.location

      feedUser.push
        user: user
        reason: reason
        distance: dist

    # locationIdList = _.difference (), auth.location

    Location.find
      _id:
        $in: Object.keys locationStore
        $nin: auth.location

  .then (locationList) ->
    for location in locationList
      reason = getLocationEntry location._id
      dist = distance.calculate auth.coords, location.coords
      # console.log location.distance
      #console.log location.distance
      if dist
        reason.distance = getDistanceRating dist.distance, location.halfDistance
      else
        reason.distance = 0

      if ratingStoreLocation.tag.max < reason.tag
        ratingStoreLocation.tag.max = reason.tag

      if ratingStoreLocation.user.max < reason.user
        ratingStoreLocation.user.max = reason.user



      feedLocation.push
        location: location
        reason: reason
        distance: dist




    for item in feedUser
      item.rating = item.reason.distance * ratingStoreUser.distance.rating
      + item.reason.online * ratingStoreUser.online.rating
      + item.reason.location / ratingStoreUser.location.max * ratingStoreUser.location.rating

    feedUser = feedUser.sort (a,b) ->
      b.rating - a.rating

    for item in feedLocation
      item.rating = item.reason.distance  * ratingStoreLocation.distance.rating
      + item.reason.tag / ratingStoreLocation.tag.max * ratingStoreLocation.tag.rating
      + item.reason.user / ratingStoreLocation.user.max * ratingStoreLocation.user.rating

    feedLocation = feedLocation.sort (a,b) ->
      b.rating - a.rating

    # console.log feedLocation
    #console.log "location", (_.pluck feedLocation, "rating")
    #console.log "user", (_.pluck feedUser, "rating")

    for item in feedUser.splice 0, 6
      feed.push
        type: "user"
        user: item.user
        reason: item.reason
        distance: item.distance

    for item in feedLocation.splice 0, 6
      feed.push
        type: "location"
        location: item.location
        reason: item.reason
        distance: item.distance

    feed = _.shuffle feed
    feed: feed
