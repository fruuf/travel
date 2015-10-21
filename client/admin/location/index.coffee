module.exports = angular.module "adminLocation", [
  (require "./detail").name
]
.controller "AdminLocationController", require "./controller"

.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "admin.location",
    url: "/location"
    views:
      "content@admin":
        template: require "./template"
        controller: "AdminLocationController as LocationCtrl"
]
