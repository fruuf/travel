
module.exports = () ->
  template: require "./item-template"
  restrict: "E"
  scope:
    item: "="
