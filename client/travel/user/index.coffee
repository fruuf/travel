module.exports = angular.module "travelUser", [
  (require "./detail").name
  (require "./directive").name
]

.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "travel.user",
    url: "/user"
]
