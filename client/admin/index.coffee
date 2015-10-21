module.exports = angular.module "admin", [
  (require "./location").name
]
.controller "AdminController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "admin",
    url: "/admin"
    views:
      "main@":
        template: require "./template"
        controller: "AdminController as AdminCtrl"
]
