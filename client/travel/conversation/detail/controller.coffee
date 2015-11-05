_ = require "lodash"
class TravelConversationDetailController
  constructor: (@api, @$stateParams, $scope) ->
    @userStore = {}
    @api.request "conversation/detail",
      user: @$stateParams.user
      conversation: @$stateParams.conversation
    .then (res) =>
      @conversation = res.conversation
      for user in @conversation.user
        @userStore[user._id] = user
      @updateMessages()
    @message = ""

    $scope.$on "conversation/update", (event, data) =>
      if @conversation._id == data._id
        @conversation.message = @conversation.message.concat data.message
        @updateMessages()
        $scope.$digest()

  submit: ->
    if @message
      message = @message
      @message = ""
      @api.request "conversation/message/add",
        conversation: @conversation._id
        content: message

  updateMessages: ->
    messages = @conversation.message.sort (a,b) -> (new Date a.createdAt) - (new Date b.createdAt)
    @messageGroups = []
    for message in messages
      if @messageGroups.length == 0
        @messageGroups.push
          user: @userStore[message.user]
          messages: [message]
      else
        group = _.last @messageGroups
        if group.user._id == message.user
          group.messages.push message
        else
          @messageGroups.push
            user: @userStore[message.user]
            messages: [message]





module.exports = ["api", "$stateParams", "$scope", TravelConversationDetailController]
