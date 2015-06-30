var gulp      = require('gulp'),
  GLOBVARS    = require('../vars'),
  plugins     = require('gulp-load-plugins')({
    rename: {
      'gulp-server-livereload' : 'server'
    }
  });

gulp.task('webserver', function() {
  gulp.src('.')
    .pipe(plugins.server({
      livereload: true,
      directoryListing: true,
      open: true,
      port: 1234
    }));
});