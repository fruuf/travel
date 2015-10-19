_ = require "lodash"
module.exports = class LocationEditController
  constructor: (@api, @$state, $stateParams, @$scope) ->
    @tagStore = {}

    @geocoder = new google.maps.Geocoder()
    @api.request "admin/locationEditLoad",
      location: $stateParams.location
    .then (res) =>
      console.log res
      @location = res.location
      @tagEnabled = res.tagEnabled
      @tagDisabled = res.tagDisabled


  lookup: (address) ->
    @geocoder.geocode
      'address': address
    , (results, status) =>
      if status == google.maps.GeocoderStatus.OK and results.length
        res = results[0]
        console.log res
        @location.address = res.formatted_address
        location = res?.geometry?.location
        #console.log location
        if location
          @location.coords = [location.lng(), location.lat()]

        @$scope.$digest()
      else
        toastr.error status

  save: ->
    @api.request "admin/locationEditSave", @location
    .then (res) =>
      toastr.success "location saved"

  addTag: (name) ->
    if name
      console.log name
      @api.request "admin/locationAddTag",
        name: name
      .then (res) =>
        # console.log res
        @tagDisabled.push res.tag
        # @tagStore[res.tag._id] = res.tag
      , (err) =>
        toastr.error "Tag does exist"

  setTag: (tag, status) ->
    console.log "setTag", tag, status

    if status
      index = @tagDisabled.indexOf tag
      @tagDisabled.splice index, 1
      @tagEnabled.push tag

    else
      index = @tagEnabled.indexOf tag
      @tagEnabled.splice index, 1
      @tagDisabled.push tag

    @api.request "admin/locationSetTag",
      tag: tag._id
      location: @location._id
      status: status
    
