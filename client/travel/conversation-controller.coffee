module.exports = class TravelConversationController
  constructor: (@api, @$stateParams, $scope) ->
    console.log @$stateParams
    @conversationUser = {}
    @api.request "conversation/get",
      user: @$stateParams.user
      conversation: @$stateParams.conversation
    .then (res) =>
      console.log res.conversation
      @conversation = res.conversation
      for user in @conversation.user
        @conversationUser[user._id] = user
    @message = ""

    $scope.$on "conversation.update", (event, data) =>
      if @conversation._id == data._id
        @conversation.message = @conversation.message.concat data.message
        $scope.$digest()

  submit: ->
    if @message
      message = @message
      @message = ""
      @api.request "conversation/post",
        conversation: @conversation._id
        content: message
