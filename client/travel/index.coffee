module.exports = angular.module "travel", [
  (require "./location").name
  (require "./feed").name
  (require "./conversation").name
  (require "./profile").name
  (require "./user").name
]
.controller "TravelController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "travel",
    url: "/travel"
    views:
      "main@":
        template: require "./template"
        controller: "TravelController as TravelCtrl"
]
