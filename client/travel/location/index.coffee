module.exports = angular.module "travelLocation", [
  (require "./detail").name
  (require "./directive").name
]

.controller "TravelLocationController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "travel.location",
    url: "/location"
    views:
      "content@travel":
        template: require "./template"
        controller: "TravelLocationController as LocationCtrl"
]
