class TravelConversationDetailController
  constructor: (@api, @$stateParams, $scope) ->
    @userStore = {}
    @api.request "conversation/detail",
      user: @$stateParams.user
      conversation: @$stateParams.conversation
    .then (res) =>
      console.log "conv", res.conversation
      @conversation = res.conversation
      for user in @conversation.user
        @userStore[user._id] = user
    @message = ""

    $scope.$on "conversation.update", (event, data) =>
      if @conversation._id == data._id
        @conversation.message = @conversation.message.concat data.message
        $scope.$digest()

  submit: ->
    if @message
      message = @message
      @message = ""
      @api.request "conversation/addMessage",
        conversation: @conversation._id
        content: message

module.exports = ["api", "$stateParams", "$scope", TravelConversationDetailController]
