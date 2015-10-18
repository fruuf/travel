module.exports = class LocationController
  constructor: (@api, @$state) ->
    @locationStore = {}
    @tagStore = {}
    @api.request "admin/location"
    .then (res) =>
      console.log res
      
      @locationList = res.location
      @tagList = res.tag
      for location in res.location
        @locationStore[location._id] = location
      for tag in res.tag
        @locationStore[tag._id] = tag


  add: (name)->
    if name
      console.log "firee"
      @api.request "admin/locationAdd",
        name: name
      .then (res) =>
        @$state.go ".edit",
          location: res.location._id
        toastr.success "location created"
      .then undefined, (err) ->
        console.error err

    else
      toastr.error "specify name"
