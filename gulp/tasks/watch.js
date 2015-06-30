var gulp = require('gulp'),
  GLOBVARS = require('../vars');

gulp.task("watch", function () {
  gulp.watch(GLOBVARS.watch.coffee, ['coffee:dev']);
  gulp.watch(GLOBVARS.watch.bootstrap, ['bootstrap:dev']);
  gulp.watch(GLOBVARS.watch.jade, ['jade:dev']);
});