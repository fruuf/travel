module.exports = class TravelMessageController
  constructor: (@api, $scope) ->
    @conversations = []
    @api.request "conversation"
    .then (res) =>
      @conversations = res.conversation
    $scope.$on "conversation", (conversation) ->
      @conversations.push conversation
