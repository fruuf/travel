module.exports = angular.module "user", [
  (require "./login").name
  (require "./register").name
]
.controller "UserController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "user",
    url: "/user"
    views:
      "main@":
        template: require "./template"
        controller: "UserController as UserCtrl"
]
