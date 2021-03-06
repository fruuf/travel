mongoose = require "mongoose"
Schema = mongoose.Schema
locationSchema = Schema
  createdAt:
    type: Date
    default: Date.now
  coords:
    type: [Number]
    index: "2d"
    default: []
  halfDistance:
    type: Number
    default: 10
  name: String
  address: String
  description: String
  image:
    small: String
    medium: String
    large: String

locationSchema.methods.toJSON = ->
  obj = this.toObject()
  # delete obj.password
  # delete obj.token
  obj


module.exports = mongoose.model "Location", locationSchema
