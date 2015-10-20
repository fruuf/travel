_ = require "lodash"

module.exports = () ->
  template: require "./location-template"
  restrict: "E"
  scope:
    location: "="

  link: (scope, element, attribute) ->
    console.log scope.location
