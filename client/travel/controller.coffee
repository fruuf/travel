_ = require "lodash"

class TravelController
  constructor: (@$state, @api, $scope) ->
    @api.request "profile"
    .then (res) =>
      @profile = res.profile
      if @profile.name == "New Profile"
        @$state.go "travel.profile"

    $scope.$on "conversation.update", (event, conversation) =>
      message = conversation.message[0]
      if not (@api.login == message.user) and not (@$state.current.name == "travel.conversation")
        toastr.info "New Message"


  logout: ->
    @api.token()
    toastr.success "Logout successful"
    yes

  go: (state) ->
    $('.navmenu').offcanvas "hide"
    @$state.go state

module.exports = ["$state", "api", "$scope", TravelController]
