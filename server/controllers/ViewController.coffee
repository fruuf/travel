module.exports =
  index: (req, res) ->
    data =
      user: {}
    if req.session.user
      User.findOne req.session.user
      .then (user) ->
        data.user = user
        res.view "index", data
    else
      res.view "index", data

  connection: (req, res) ->
    ConnectionService.delegate(req,res)
