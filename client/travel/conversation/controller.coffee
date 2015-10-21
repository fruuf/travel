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

    $scope.$on "conversation", (conversation) ->
      @conversations.push conversation

module.exports = ["api", "$scope", TravelConversationController]
