module.exports = class TravelUserController
  constructor: ( @api )->
    @api.request "user"
    .then (res) =>
      @data = res.user

  update: ->
    @api.request "user/update", @data
    .then (res) =>
      toastr.success "Update successful"
