# gulp-reduce [![NPM version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url] [![Coverage Status][coveralls-image]][coveralls-url] [![Dependency Status][depstat-image]][depstat-url] [![devDependency Status][devdepstat-image]][devdepstat-url]


> Reduce plugin for [gulp](http://gulpjs.com/) 3.

## Usage

First, install `gulp-reduce` as a development dependency:

```shell
npm install --save-dev gulp-reduce
```

Then, add it to your `gulpfile.js`:

```javascript
var gulp = require('gulp');
var reduce = require('gulp-reduce');

gulp.task('default', function () {
    gulp.src('./src/*.ext')
        .pipe(reduce({msg: 'More Coffee!'}))
        .pipe(gulp.dest("./dist"));
});
```

## Options `reduce(opt)`

## opt.msg
Type: `String`
Default: `More Coffee!`

The message you wish to attach to file.


## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License) © [Martin Broder](martinbroder.com)

[npm-url]: https://npmjs.org/package/gulp-reduce
[npm-image]: https://badge.fury.io/js/gulp-reduce.png

[travis-url]: http://travis-ci.org/mrtnbroder/gulp-reduce
[travis-image]: https://secure.travis-ci.org/mrtnbroder/gulp-reduce.png?branch=master

[coveralls-url]: https://coveralls.io/r/mrtnbroder/gulp-reduce
[coveralls-image]: https://coveralls.io/repos/mrtnbroder/gulp-reduce/badge.png

[depstat-url]: https://david-dm.org/mrtnbroder/gulp-reduce
[depstat-image]: https://david-dm.org/mrtnbroder/gulp-reduce.png

[devdepstat-url]: https://david-dm.org/mrtnbroder/gulp-reduce#info=devDependencies
[devdepstat-image]: https://david-dm.org/mrtnbroder/gulp-reduce/dev-status.png
