_ = require "lodash"

module.exports = class TravelController
  constructor: (@$state, @api, $scope, $stateParams) ->
    @api.request "user"
    .then (res) =>
      if res.user
        $scope.user = res.user
    .catch (err) ->
      console.error err

    $scope.$on "conversation.update", (event, conversation) =>
      message = conversation.message[0]
      if not (@api.login == message.user) and not (@$state.current.name == "travel.conversation")
        toastr.info "New Message"


    @$state.go "travel.feed"

  logout: ->
    @api.token()
    toastr.success "Logout successful"
    yes
