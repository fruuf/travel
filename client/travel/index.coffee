travel = angular.module "travel", ["app", "ui.router"]
module.exports = travel.name

travel.controller "TravelController", require "./travel-controller"
travel.controller "TravelUserController", require "./user-controller"
travel.controller "TravelMessageController", require "./message-controller"
travel.controller "TravelConversationController", require "./conversation-controller"
travel.controller "TravelFeedController", require "./feed/feed-controller"
travel.controller "TravelFeedUserController", require "./feed/item/user-controller"
travel.controller "TravelFeedLocationController", require "./feed/item/location-controller"
#travel.directive "feedUser", require "./feed/user-directive"
#travel.directive "feedLocation", require "./feed/location-directive"

travel.directive "feedItem", require "./feed/item-directive"


travel.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
  .state "travel",
    url: "/travel"
    views:
      "main@":
        template: require "./travel-template"
        controller: "TravelController as TravelCtrl"

  .state "travel.feed",
    url: "/feed"
    views:
      "content@travel":
        template: require "./feed/feed-template"
        controller: "TravelFeedController as FeedCtrl"

  .state "travel.feed.location",
    url: "/location/:location"
    views:
      "content@travel":
        template: require "./feed/item/location-template"
        controller: "TravelFeedLocationController as LocationCtrl"

  .state "travel.feed.user",
    url: "/user/:user"
    views:
      "content@travel":
        template: require "./feed/item/user-template"
        controller: "TravelFeedUserController as UserCtrl"

  .state "travel.message",
    url: "/message"
    views:
      "content@travel":
        template: require "./message-template"
        controller: "TravelMessageController as MessageCtrl"

  .state "travel.conversation",
    url: "/conversation/:conversation"
    params:
      conversation: ""
      user: []
    views:
      "content@travel":
        template: require "./conversation-template"
        controller: "TravelConversationController as ConversationCtrl"

  .state "travel.user",
    url: "/user"
    views:
      "content@travel":
        template: require "./user-template"
        controller: "TravelUserController as UserCtrl"
