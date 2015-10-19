distance = require "../includes/distance"
_ = require "lodash"

module.exports = class FeedController
  index: (data, send, user) ->
    if not user
      send err: "auth"
      return

    # auth
    feed = []


    # console.log "feed"
    User.findOne _id: user
    .then (activeUser) ->
      console.log "activeUser", activeUser

      locationStore = {}
      userStore = {}
      getLocationEntry = (id) ->
        if not locationStore[id]
          locationStore[id] =
            userCount: 0
            tagCount: 0
            self: no
            coords: no

      getUserEntry = (id) ->
        if not userStore[id]
          userStore[id] =
            locationCount: 0
            locationSum: 0
            online: no
            coords: no

      for location in activeUser.location
        entry = getLocationEntry location
        entry.self = yes

      User.find
        coords:
          $near : activeUser.coords
          $maxDistance : 5 / 6400
        #_id:
        #  $ne: activeUser._id
        #online: yes
      .limit 5
      #.exec()
      .then (res) ->
        console.log res
        res
      , (err) ->
        console.log err
      .then (userNear) ->
        console.log "userNear", userNear
        for user in userNear
          userEntry = getUserEntry user._id
          userEntry.online = yes
          userEntry.coords = user.coords


        User.find
          location:
            $in: activeUser.location
      .then (userLocation) ->
        for user in userLocation
          entryUser = getUserEntry user._id
          entryUser.locationSum = user.location.length
          for location in user.location
            entryLocation = getLocationEntry location
            if entryLocation.self
              entryUser.locationCount = entryUser.locationCount + 1
            else
              entryLocation.userCount = entryLocation.userCount + 1
              # entryLocation.userSum = entryLocation.userSum + user.location.length

        Tag.find
          "user.ref": activeUser._id
      .then (userTags) ->
        for tag in userTags
          tagCount = 0
          tagCountSum = 0
          for user in tag.user
            tagCountSum = tagCountSum + user.count
            if user.ref == activeUser._id
              tagCount = user.count
          for location in tag.location
            entryLocation = getLocationEntry location.ref
            entryLocation.tagCount = entryLocation.tagCount + (location.multiplier * tagCount / tag.location.length)

        Location.find
          coords:
            $nearSphere : activeUser.coords
            # $maxDistance : 0.1
          _id:
            $nin: activeUser.location
          # online: yes
          $limit: 5
      .then (LocationNear) ->
        for location in LocationNear
          entryLocation = getLocationEntry location._id
          entryLocation.coords = location.coords
        yes
      .then ->
        send
          user: userStore
          location: locationStore

    .then undefined, (err) ->
      send
        err: err
