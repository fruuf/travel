module.exports = angular.module "user", [
  (require "./login").name
  (require "./register").name
]
.config ["$stateProvider", "$urlRouterProvider", ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise "/user/login"
  $stateProvider
  .state "user",
    url: "/user"
]
