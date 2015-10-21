_ = require "lodash"

module.exports =
  index: (req) ->
    throw new Error "auth" if not req.user

    Conversation.find
      user: req.user._id
    .populate "user"
    .then (conversations) ->
      conversations: conversations

  detail: (req) ->
    throw new Error "auth" if not req.user

    if (not req.data.conversation) and req.data.user
      users = req.data.user.concat (String req.user._id)
      users = _.unique users
        .map (id) ->
          ObjectId id

      throw new Error "conversation empty" if users.length == 1

      Conversation.findOne
        user:
          $all: users
          $size: users.length

      .populate "user"
      .then (conversation) ->
        if conversation
          conversation: conversation
        else
          Conversation.create
            user: users
          .then (conversation) ->
            Conversation.findOne _id: conversation._id
            .populate "user"
          .then (conversation) ->
            conversation: conversation

    else if req.data.conversation
      Conversation.findOne _id: req.data.conversation
      .populate "user"
      .then (conversation) ->
        conversation: conversation

    else
      throw new Error "conversation without params"

  addMessage: (req) ->
    throw new Error "auth" if not req.user

    Conversation.findOne _id: req.data.conversation
    .then (conversation) ->
      conversation.message.push
        user: ObjectId req.user._id
        content: req.data.content
      conversation.updatedAt = Date.now()
      conversation.save()
    .then (conversation) ->
      Server.send "conversation.update", conversation.user,
        _id: conversation._id
        message: [
          user: ObjectId req.user._id
          content: req.data.content
          createdAt: Date.now()
        ]
      yes
