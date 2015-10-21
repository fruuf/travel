module.exports = angular.module "travelLocationDetail", [

]
.controller "TravelLocationDetailController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "travel.location.detail",
    url: "/:location"
    views:
      "content@travel":
        template: require "./template"
        controller: "TravelLocationDetailController as DetailCtrl"
]
