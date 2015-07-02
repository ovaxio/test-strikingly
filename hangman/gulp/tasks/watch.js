var gulp = require('gulp'),
  GLOBVARS = require('../vars');

gulp.task("watch", function () {
  gulp.watch(GLOBVARS.watch.coffee, ['coffee:dev']);
  gulp.watch(GLOBVARS.watch.jade, ['jade:dev']);
  gulp.watch(GLOBVARS.watch.assets, ['assets']);
});