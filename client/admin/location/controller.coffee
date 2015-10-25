class AdminLocationController
  constructor: (@api, @$state) ->
    @locationStore = {}
    @tagStore = {}
    @api.request "admin/location"
    .then (res) =>
      console.log res

      @locations = res.locations
      @tags = res.tags
      for location in res.locations
        @locationStore[location._id] = location
      for tag in res.tags
        @tagStore[tag._id] = tag


  add: (name)->
    if name
      console.log "firee"
      @api.request "admin/location/add",
        name: name
      .then (res) =>
        @$state.go ".detail",
          location: res.location._id
        toastr.success "location created"
    else
      toastr.error "specify name"

module.exports = ["api", "$state", AdminLocationController]
