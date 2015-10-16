bcrypt = require "bcrypt"
Q = require "q"

module.exports =
  autoSubscribe: no
  attributes:
    email:
      type: 'string'
      required: yes
      unique: yes
    password:
      type: 'string'
      required: yes

    country:
      type: "string"

    name:
      type: 'string'

    profession:
      type: 'string'

    about:
      type: 'string'

    online:
      type: "boolean"
      defaultsTo: no

    conversation:
      collection: "conversation"
      via: "user"

    toJSON: ->
      obj = @toObject()
      delete obj.password;
      obj

  beforeCreate: (user, cb) ->
    genSalt = Q.nfbind bcrypt.genSalt
    hash = Q.nfbind bcrypt.hash

    genSalt 10
    .then (salt) ->
      hash user.password, salt
    .then (hash) ->
      user.password = hash
      cb null, user
      yes
    .catch cb

  status: (id, status = no) ->
    User.update id,
      online: status
    .then ->
      User.find {}
    .then (users) ->
      for user in users
        ConnectionService.update user.id, "user",
          id: id
          online: status
