var gulp = require('gulp');

gulp.task('default', ["bootstrap:dev", "coffee:dev", "jade:dev", "assets", "watch", "webserver"]);