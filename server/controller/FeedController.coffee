distance = require "../includes/distance"

module.exports = class FeedController
  index: (data, send, user) ->
    if not user
      send err: "auth"
      return

    # auth
    feed = []
    # console.log "feed"
    User.findOne _id: user
    .exec()
    .then (activeUser) ->
      User.find
        _id:
          $ne: activeUser._id
      .exec()
      .then (users) ->
        for user in users
          feed.push
            type: "user"
            user: user
            distance: distance.calculate activeUser.coords, user.coords
          # console.log feed
        send
          feed: feed
    .then undefined, (err) ->
      send
        err: err
