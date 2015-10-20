
module.exports = () ->
  template: require "./item-template"
  restrict: "E"
  scope:
    item: "="
  link: (scope, element, attribute) ->
    # Update user on websocket
    if scope.item.type == "user"
      user = scope.item.user

      scope.$on "user.update", (event, data) ->
        if data._id == user._id
          scope.item.user = _.merge user, data
          scope.$digest()

      console.log scope.item
      description = []
      description.push user.country if user.country
      description.push user.profession if user.profession
      description.push scope.item.distance.formatted if scope.item.distance

      scope.description = description.join ", "

    # if scope.item.type == "location"
