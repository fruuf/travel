_ = require "lodash"

module.exports = () ->
  template: require "./user-template"
  restrict: "E"
  scope:
    user: "="
  controller: ($scope, api, $state) ->
    # Update user on websocket
    $scope.$on "user.update", (event, data) ->
      console.log "data", data
      if data._id == $scope.user._id
        $scope.user = _.merge $scope.user, data
        $scope.$digest()

    $scope.startConversation = ->
      console.log "statt", $scope.user
      $state.go "travel.conversation",
        user: [$scope.user._id]


  link: (scope, element, attribute) ->
