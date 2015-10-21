module.exports = angular.module "travelUserDetail", []

.controller "TravelUserDetailController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "travel.user.detail",
    url: "/:user"
    views:
      "content@travel":
        template: require "./template"
        controller: "TravelUserDetailController as DetailCtrl"
]
