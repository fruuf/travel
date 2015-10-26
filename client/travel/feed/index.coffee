module.exports = angular.module "travelFeed", [
  # (require "./item").name
]

.controller "TravelFeedController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "travel.feed",
    url: "/feed"
    views:
      "content@travel":
        template: require "./template"
        controller: "TravelFeedController as FeedCtrl"
]
