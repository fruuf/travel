module.exports = class FeedController
  index: (data, send, user) ->
    if not user
      send err: "auth"
      return

    # auth
    feed = []
    User.find {}
    .exec (err, users) ->

      for user in users
        feed.push
          type: "user"
          user: user
          lat: user.lat
          lng: user.lng
      send
        feed: feed
