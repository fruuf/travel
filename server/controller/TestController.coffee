module.exports = class TestController
  index: (data, answer, user) ->
    answer
      data: data
      user: user
      test: "huhu"
