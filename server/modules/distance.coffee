Number.prototype.toRadians = ->
  @ * Math.PI / 180

module.exports = (obj, auth) ->
  if obj.toObject
    obj = obj.toObject()

  result = no
  # console.log "distance", coordsA, coordsB
  if obj.coords[0] and obj.coords[1] and auth.coords[0] and auth.coords[1]
    lat1 = auth.coords[1]
    lon1 = auth.coords[0]

    lat2 = obj.coords[1]
    lon2 = obj.coords[0]

    R = 6371000
    φ1 = lat1.toRadians()
    φ2 = lat2.toRadians()
    Δφ = (lat2-lat1).toRadians()
    Δλ = (lon2-lon1).toRadians()

    a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
      Math.cos(φ1) * Math.cos(φ2) *
      Math.sin(Δλ/2) * Math.sin(Δλ/2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    obj.distance = Math.round (R * c)
  else
    obj.distane = 0
  console.log obj
  delete obj.coords

  obj
