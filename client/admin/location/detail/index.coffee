module.exports = angular.module "adminLocationDetail", [

]
.controller "AdminLocationDetailController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "admin.location.detail",
    url: "/:location"
    views:
      "content@admin":
        template: require "./template"
        controller: "AdminLocationDetailController as DetailCtrl"
]
