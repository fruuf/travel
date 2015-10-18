module.exports = class TravelMessageController
  constructor: (@api, $scope) ->
    @userStore = {}
    @conversations = []
    @api.request "conversation"
    .then (res) =>
      for conversation in res.conversation
        for user in conversation.user
          if not @userStore[user._id]
            @userStore[user._id] = user

      @conversations = res.conversation

    $scope.$on "conversation", (conversation) ->
      @conversations.push conversation
