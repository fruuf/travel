module.exports =
  autoSubscribe: no
  attributes:
    user:
      model: "user"

    conversation:
      model: "conversation"
      via: "message"

    content:
      type: "string"
      required: yes
