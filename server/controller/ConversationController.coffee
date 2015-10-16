_ = require "lodash"

module.exports = class ConversationController
  index: (data, send, user) ->
    if not user
      send err:"auth"
      return

    Conversation.find
      user: user
    .populate "user"
    .exec()
    .then (conversations) ->
      send
        conversation: conversations

  get: (data, send, user) ->
    if not user
      send err:"auth"
      return

    if (not data.conversation) and data.user
      data.user.push user
      users = _.unique data.user
        .map (id) ->
          ObjectId id
      if users.length == 1
        send err: "conversationSelf"
      else
        Conversation.findOne
          user:
            $all: users
            $size: users.length
          # "user.length": users.length
        .populate "user"
        .exec (err, conversation) ->
          if conversation
            send
              conversation: conversation
          else
            Conversation.create
              user: users
            , (err, conversation) ->
              Conversation.findOne _id: conversation._id
              .populate "user"
              .exec (err, conversation) ->
                send
                  conversation: conversation
                  err: err

    else if data.conversation
      Conversation.findOne _id: data.conversation
      .populate "user"
      .exec (err, conversation) ->
        send
          conversation: conversation
          err: err

  post: (data, send, user) ->
    if not user
      send err: "auth"
      return

    Conversation.findOne _id: data.conversation
    .exec (err, conversation) ->
      conversation.message.push
        user: ObjectId user
        content: data.content
      conversation.updatedAt = Date.now()
      conversation.save (err, conversation) ->
        Server.send "conversation.update", conversation.user,
          _id: conversation._id
          message: [
            user: ObjectId user
            content: data.content
            createdAt: Date.now()
          ]

        send()
