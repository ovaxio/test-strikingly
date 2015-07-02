var gulp      = require('gulp'),
  GLOBVARS    = require('../vars'),
  plugins     = require('gulp-load-plugins')(),
  nib         = require('nib');

gulp.task('stylus:dev', function () {
  gulp.src(GLOBVARS.src.stylus)
  .pipe(plugins.plumber({errorHandler: plugins.notify.onError(GLOBVARS.onError)}))
  .pipe(plugins.stylus({
    use: nib(),
    compress: false
  }))
  .pipe(plugins.concat('styles.css'))
  .pipe(plugins.size({showFiles: true}))
  .pipe(gulp.dest(GLOBVARS.prod.css));
  return
});
