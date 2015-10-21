module.exports = angular.module "travelConversation", [
  (require "./detail").name
]

.controller "TravelConversationController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "travel.conversation",
    url: "/conversation"
    views:
      "content@travel":
        template: require "./template"
        controller: "TravelConversationController as ConversationCtrl"
]
