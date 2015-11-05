shortid = require "shortid"
fs  = require "fs"
path = require "path"
sharp = require 'sharp'
q = require "q"

imagePath = path.join process.cwd(), "public"

module.exports =
  save: (file) ->
    image =
      small: "/files/#{shortid.generate()}.jpeg"
      medium: "/files/#{shortid.generate()}.jpeg"
      large: "/files/#{shortid.generate()}.jpeg"

    q()
    .then ->
      sharp file
      .jpeg()
      .quality 80
      .resize 100, 100
      .toFile "#{imagePath}#{image.small}"
    .then ->
      sharp file
      .jpeg()
      .quality 80
      .resize 250, 250
      .toFile "#{imagePath}#{image.medium}"
    .then ->
      sharp file
      .jpeg()
      .quality 80
      .resize 500, 500
      .toFile "#{imagePath}#{image.large}"
    .then ->
      image

  remove: (image) ->
    q()
    .then ->
      fs.unlink (path.join imagePath, image.small)
      fs.unlink (path.join imagePath, image.medium)
      fs.unlink (path.join imagePath, image.large)
