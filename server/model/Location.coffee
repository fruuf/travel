mongoose = require "mongoose"
Schema = mongoose.Schema
locationSchema = Schema

  Tag: [
    type: Schema.Types.ObjectId
    ref: "Tag"
    index: yes
  ]
  createdAt:
    type: Date
    default: Date.now
  coords:
    type: [Number,Number]
    index: "2d"

locationSchema.methods.toJSON = ->
  obj = this.toObject()
  # delete obj.password
  # delete obj.token
  obj


module.exports = mongoose.model "Location", locationSchema
