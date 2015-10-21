module.exports = angular.module "travelProfile", [

]
.controller "TravelProfileController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "travel.profile",
    url: "/profile"
    views:
      "content@travel":
        template: require "./template"
        controller: "TravelProfileController as ProfileCtrl"
]
