_ = require "lodash"

class TravelConversationController
  constructor: (@api, $scope) ->
    @userStore = {}
    @conversations = []
    @api.request "conversation"
    .then (res) =>
      for conversation in res.conversations
        for user in conversation.user
          if not @userStore[user._id]
            @userStore[user._id] = user
      @conversations = res.conversations

    $scope.$on "conversation/create", (event, conversation) =>
      @conversations.push conversation
    $scope.$on "conversation/update", (event, conversation) =>
      _.find @conversations,
        _id: conversation._id
      .message.push (_.last conversation.message)


module.exports = ["api", "$scope", TravelConversationController]
