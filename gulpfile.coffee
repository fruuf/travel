gulp = require "gulp"
browserify = require "gulp-browserify"
less = require "gulp-less"
ngAnnotate = require "gulp-ng-annotate"
sourcemaps = require "gulp-sourcemaps"
jade = require "gulp-jade"
uglify = require "gulp-uglify"
nodemon = require "gulp-nodemon"
watch = require "gulp-watch"
plumber = require "gulp-plumber"
rename = require "gulp-rename"

gulp.task "watch", (cb) ->
  watch "./client/**/*.(jade|coffee|js)", -> gulp.start "scripts"
  watch "./client/**/*.less", -> gulp.start "styles"
  # watch "./templates/**/*.jade", -> gulp.start "templates"
  cb()

gulp.task "scripts", ->
  gulp.src "./client/*.coffee",
    read: off
  .pipe plumber()
  .pipe browserify
    debug: on
    transform: [
      "coffeeify"
      "jadeify"
    ]
    extensions: [
      ".coffee"
      ".jade"
    ]
  .pipe rename (path) ->
    path.extname = ".js"
  .pipe gulp.dest "./public/client"
  .pipe rename (path) ->
    path.extname = ".min.js"
 # .pipe ngAnnotate()
 # .pipe uglify()
 # .pipe gulp.dest "./.tmp/public/client"

gulp.task "styles", ->
  gulp.src "./client/*.less"
  .pipe plumber()
  .pipe sourcemaps.init()
  .pipe less()
  .pipe sourcemaps.write()
  .pipe gulp.dest "./public/client"


gulp.task "default",["styles", "scripts", "watch"], ->
  nodemon
    script: "./app.coffee"
    ignore: [
      "node_modules/**"
      "client/**"
      "views/**"
    ]
    ext: "js coffee"
