_ = require "lodash"

module.exports = () ->
  template: require "./user-template"
  restrict: "E"
  scope:
    item: "="
  controller: ($scope, api, $state) ->
    $scope.user = $scope.item.user
    # Update user on websocket
    $scope.$on "user.update", (event, data) ->
      # console.log "data", data
      if data._id == $scope.user._id
        $scope.user = _.merge $scope.user, data
        $scope.$digest()

    item = $scope.item
    user = item.user

    description = []
    if user.country
      description.push user.country
    if user.profession
      description.push user.profession
    if item.distance
      description.push item.distance.formatted

    $scope.description = description.join ", "
    $scope.startConversation = ->
      # console.log "statt", $scope.user
      $state.go "travel.conversation",
        user: [$scope.user._id]


  link: (scope, element, attribute) ->
