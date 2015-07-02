var gulp = require('gulp');

gulp.task('default', ["coffee:dev", "jade:dev", "assets", "watch", "webserver"]);