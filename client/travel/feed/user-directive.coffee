_ = require "lodash"

module.exports = () ->
  template: require "./user-template"
  restrict: "E"
  scope:
    user: "="
  controller: ($scope, api, $state) ->



  link: (scope, element, attribute) ->
    # Update user on websocket
    scope.$on "user.update", (event, data) ->
      if data._id == scope.user._id
        scope.user = _.merge scope.user, data
        scope.$digest()


    description = []
    description.push scope.user.country if scope.user.country
    description.push scope.user.profession if scope.user.profession
    description.push scope.user.distance.formatted if scope.user.distance

    scope.description = description.join ", "
    ###
    scope.startConversation = ->
      # console.log "statt", $scope.user
      $state.go "travel.conversation",
        user: [$scope.user._id]
    ###
