user = angular.module "user", ["app", "ui.router"]
module.exports = user.name

user.controller "UserController", require "./user-controller"

user.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise "/user/signin"

  $stateProvider
  .state "user",
    url: "/user"


  .state "user.login",
    url: "/login"
    views:
      "main@":
        template: require "./login-template"
        controller: "UserController as UserCtrl"

  .state "user.register",
    url: "/register"
    views:
      "main@":
        template: require "./register-template"
        controller: "UserController as UserCtrl"
