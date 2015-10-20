module.exports = class TravelUserController
  constructor: ( @api )->
    @api.request "user"
    .then (res) =>
      @data = res.user

  update: ->
    console.log @profilePicture
    @api.request "user/update", @data
    .then (res) =>
      toastr.success "Update successful"
