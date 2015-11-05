module.exports = angular.module "appResSrc", [

]
.directive "resSrc", ->
  restrict: "A"
  scope:
    resSrc: "="
  link: (scope, element, attribute) ->
    scope.$watch "resSrc", ->
      width = element.innerWidth()
      src = "/images/none.jpeg"
      if scope.resSrc
        src = scope.resSrc.small
        src = scope.resSrc.medium if width > 100
        src = scope.resSrc.large if width > 200

      element.attr "src", src
