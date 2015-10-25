_ = require "lodash"
class AdminLocationDetailController
  constructor: (@api, @$state, $stateParams, @$scope) ->
    @tagStore = {}
    @geocoder = new google.maps.Geocoder()
    @api.request "admin/location/detail",
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
    @api.request "admin/location/update", @location
    .then (res) =>
      toastr.success "location saved"

  addTag: (name) ->
    if name
      @api.request "admin/tag/add",
        name: name
      .then (res) =>
        # console.log res
        @tagDisabled.push res.tag
        # @tagStore[res.tag._id] = res.tag


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

    @api.request "admin/tag/location",
      tag: tag._id
      location: @location._id
      status: status

module.exports = ["api", "$state", "$stateParams", "$scope", AdminLocationDetailController]
