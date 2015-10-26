module.exports = angular.module "travelConversationDetail", [

]

.controller "TravelConversationDetailController", require "./controller"
.config ["$stateProvider", ($stateProvider) ->
  $stateProvider
  .state "travel.conversation.detail",
    url: "/:conversation"
    params:
      conversation: ""
      user: []
    views:
      "content@travel.conversation":
        template: require "./template"
        controller: "TravelConversationDetailController as DetailCtrl"
]
