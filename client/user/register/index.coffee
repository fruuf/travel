module.exports = angular.module "userRegister", [

]
.controller "UserRegisterController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "user.register",
    url: "/register"
    views:
      "main@":
        template: require "./template"
        controller: "UserRegisterController as RegisterCtrl"
]
