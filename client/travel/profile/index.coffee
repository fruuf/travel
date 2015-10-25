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
.run ["api", "$q", (api, $q) ->
  api.action "profile/location", (req) ->
    deferred = $q.defer()
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition deferred.resolve, deferred.reject
    else
      deferred.reject new Error "geolocation api not found"
    deferred.promise
    .then (pos) ->
      coords: [pos.coords.longitude, pos.coords.latitude]

]
