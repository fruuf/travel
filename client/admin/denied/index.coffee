module.exports = angular.module "adminDenied", [
]
.controller "AdminDeniedController", require "./controller"

.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "admin.denied",
    url: "/denied"
    views:
      "main@":
        template: require "./template"
        controller: "AdminDeniedController as DeniedCtrl"
]
