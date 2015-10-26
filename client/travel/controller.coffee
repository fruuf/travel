_ = require "lodash"
Api = require "api"

class TravelController
  constructor: (@$state, @api, $scope) ->
    @api.request "profile"
    .then (res) =>
      @profile = res.profile

    $scope.$on "conversation/update", (event, conversation) =>
      message = conversation.message[0]
      if not (@profile._id == message.user) and not (@$state.current.name == "travel.conversation")
        toastr.info "New Message"


  logout: ->
    Api.setToken()
    @$state.go "user"
    toastr.success "Logout successful"
    yes

  go: (state) ->
    $('.navmenu').offcanvas "hide"
    @$state.go state

module.exports = ["$state", "api", "$scope", TravelController]
