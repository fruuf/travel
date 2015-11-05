module.exports = angular.module "appScrollBottom", [

]
.directive "scrollBottom", ["$timeout", ($timeout) ->
  restrict: "A"
  scope: false
  link: (scope, element, attribute) ->
    scope.$watchCollection attribute.scrollBottom, ->
      scope.$evalAsync ->
        $timeout ->
          element[0].scrollTop = element[0].scrollHeight if element[0].scrollHeight
        , 10
]
