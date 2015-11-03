mongoose = require "mongoose"
Schema = mongoose.Schema
conversationSchema = Schema

  user: [
    type: Schema.Types.ObjectId
    ref: "User"
    index: yes
  ]
  createdAt:
    type: Date
    default: Date.now
  message: [
    user:
      type: Schema.Types.ObjectId
      ref: "User"
    createdAt:
      type: Date
      default: Date.now
    content:
      type: String
      required: yes
  ]
  updatedAt:
    type: Date
    default: Date.now

conversationSchema.methods.toJSON = ->
  obj = this.toObject()
  # delete obj.password
  # delete obj.token
  obj


module.exports = mongoose.model "Conversation", conversationSchema
