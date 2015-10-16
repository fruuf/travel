module.exports =
  create: (req, res) ->
    storeConversation = no
    Conversation.findOne req.param "conversation"
    .populate "user"
    .then (conversation) ->
      storeConversation = conversation
      Message.create
        user: req.session.user
        conversation: conversation.id
        content: req.param "content"
    .then (message) ->
      ConnectionService.update 2, "test", message
      for user in storeConversation.user
        console.log User.subscribers user
        ConnectionService.update user.id, "message", message
      yes
    .then ->
      res.ok()
