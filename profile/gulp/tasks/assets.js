var gulp      = require('gulp'),
  GLOBVARS    = require('../vars'),
  plugins     = require('gulp-load-plugins')();

  gulp.task('assets', function () {
  gulp.src(GLOBVARS.src.assets)
  .pipe(plugins.plumber({errorHandler: plugins.notify.onError(GLOBVARS.onError)}))
  .pipe(gulp.dest(GLOBVARS.prod.assets));
  return
});