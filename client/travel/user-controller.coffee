module.exports = class TravelUserController
  constructor: ( @api, @$scope )->
    @api.request "user"
    .then (res) =>
      @data = res.user

  update: ->
    console.log @$scope
    @api.request "user/update", @data
    .then (res) =>
      toastr.success "Update successful"

  upload: (file) ->
    @api.sendFile file
