module.exports = angular.module "travelUser", [
  (require "./detail").name

]

.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "travel.user",
    url: "/user"
]
