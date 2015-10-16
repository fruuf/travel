module.exports =
  feed: (req, res) ->
    feed = []

    users = []
    maxUpdated = new Date()
    maxUpdated.setDate maxUpdated.getDate() - 5
    User.find
      or: [
        online: yes
      ,
        updatedAt:
          '>': maxUpdated
      ]
    .then (users) ->
      for user in users
        feed.push
          type: "user"
          user: user
      yes
    .then ->
      res.send
        code: "ok_feed"
        feed: feed
