gulp = require 'gulp'
coffee = require 'gulp-coffee'
clean = require 'gulp-clean'
{spawn} = require 'child_process'

# compile `index.coffee`
gulp.task 'coffee', ->
    gulp.src('index.coffee')
        .pipe(coffee bare: true)
        .pipe(gulp.dest './')

# remove `index.js` and `coverage` dir
gulp.task 'clean', ->
    gulp.src(['index.js', 'coverage'], read: false)
        .pipe(clean())

# run tests
gulp.task 'test', ['coffee'], ->
    spawn 'npm', ['test'], stdio: 'inherit'

# run `gulp-reduce` for testing purposes
gulp.task 'gulp-reduce', ->
    reduce = require './index.coffee'
    gulp.src('./{,test/,test/fixtures/}*.coffee')
        .pipe(reduce())

# start workflow
gulp.task 'default', ['coffee'], ->
    gulp.watch ['./{,test/,test/fixtures/}*.coffee'], ['test']

# Generated on 2014-02-03 using generator-gulpplugin-coffee 0.1.0
