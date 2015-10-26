module.exports = ->
  template: require "./template"
  restrict: "E"
  scope:
    user: "="
  link: (scope, element, attribute) ->
    # Update user on websocket
    user = scope.user
    scope.$on "user/update", (event, data) ->
      if data._id == user._id
        scope.user.online = data.online
        scope.$digest()

    description = []
    description.push user.country if user.country
    description.push user.profession if user.profession
    description.push scope.distance.formatted if scope.distance

    scope.description = description.join ", "
