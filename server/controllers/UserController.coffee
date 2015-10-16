passport = require 'passport'
module.exports =
  login: (req, res) ->
    authLocal = passport.authenticate 'local', (err, user, info) ->
      if err or not user
        res.send
          err: err
          msg: info
          code: "err_passport"
      else
        req.session.user = user.id
        res.send
          user: user
          code: "ok_login"
    authLocal req, res

  register: (req, res) ->
    user = req.params.all()
    User.create
      email: user.email
      password: user.password
    .then (user) ->
      req.session.user = user.id
      res.send
        code: "ok_register"
        user: user
    .catch (err) ->
      res.send
        err: err
        code: "err_register"

  disconnect:  (req,res) ->
    User.status req.session.user, no
    User.unsubscribe req, [req.session.user]
    req.session.user = null
    res.send
      code: 'ok_disconnect'

  connect: (req, res) ->
    User.status req.session.user, yes
    User.subscribe req, [req.session.user], ["message"]
    res.send
      code: "ok_connect"

  update: (req, res) ->
    res.send "update"
