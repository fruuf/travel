_ = require "lodash"
api = new Api "conversation"

api.action "", (data, auth) ->
  throw new Error "auth" if not auth

  Conversation.find
    user: auth._id
  .populate "user"
  .then (conversations) ->
    conversations: conversations
###
api.filter "",
  conversations:
    user:
      id: yes
      name: yes
###
api.action "detail", (data, auth) ->
  throw new Error "auth" if not auth

  if (not data.conversation) and data.user
    users = data.user.concat (String auth._id)
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

  else if data.conversation
    Conversation.findOne _id: data.conversation
    .populate "user"
    .then (conversation) ->
      conversation: conversation

  else
    throw new Error "conversation without params"
###
api.filter "detail",
  conversation:
    user:
      id: yes
      name: yes
###
api.action "message/add", (data, auth) ->
  throw new Error "auth" if not auth

  Conversation.findOne _id: data.conversation
  .then (conversation) ->
    conversation.message.push
      user: ObjectId auth._id
      content: data.content
    conversation.updatedAt = Date.now()
    conversation.save()
  .then (conversation) ->
    for user in conversation.user
      api.notify user, "update",
        _id: conversation._id
        message: [
          user: auth._id
          content: data.content
          createdAt: Date.now()
        ]
    yes
