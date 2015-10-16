_ = require "lodash"

module.exports =
  create: (req, res) ->
    userList = req.param "user"
    userList.push req.session.user
    userList = _.unique userList
    Conversation.create
      user: userList
    .then (conversation) ->
      Conversation.findOne conversation.id
      .populate "user"
    .then (conversation) ->
      for user in userList
        if not (req.session.user == user)
          ConnectionService.update user, "conversation", conversation
      res.send conversation

  find: (req, res) ->
    User.findOne req.session.user
    .populate "conversation"
    .then (user) ->
      conversations = _.pluck user.conversation, "id"
      Conversation.find conversations
      .sort
        updatedAt: "desc"
      .populate "user"
      .populate "message"
      .limit 10
    .then (conversations) ->
      res.send conversations
