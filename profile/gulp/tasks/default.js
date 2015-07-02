var gulp = require('gulp');

gulp.task('default', ["stylus:dev", "jade:dev", "assets", "watch", "webserver"]);