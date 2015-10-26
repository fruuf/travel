module.exports = ->
  template: require "./template"
  restrict: "E"
  scope:
    location: "="
  link: (scope, element, attribute) ->
