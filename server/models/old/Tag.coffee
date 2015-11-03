mongoose = require "mongoose"
Schema = mongoose.Schema
tagSchema = Schema
  name: String
  user: [
    type: Schema.Types.ObjectId
    ref: "User"
    unique: yes
  ]
  location: [
    type: Schema.Types.ObjectId
    ref: "Location"
    unique: yes
  ]
  createdAt:
    type: Date
    default: Date.now


tagSchema.methods.toJSON = ->
  obj = this.toObject()
  # delete obj.user
  # delete obj.token
  obj


module.exports = mongoose.model "Tag", tagSchema
