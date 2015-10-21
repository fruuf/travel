module.exports = angular.module "userLogin", [

]
.controller "UserLoginController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "user.login",
    url: "/login"
    params:
      email: ""
    views:
      "main@":
        template: require "./template"
        controller: "UserLoginController as LoginCtrl"
]
