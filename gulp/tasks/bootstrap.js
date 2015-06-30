var gulp      = require('gulp'),
  GLOBVARS    = require('../vars'),
  plugins     = require('gulp-load-plugins')(),
  amdOptimize = require('amd-optimize'),
  del         = require('del'),
  rjsConf     = GLOBVARS.src.js + "/rjs-build.js";

  gulp.task('bootstrap:dev', function () {
  gulp.src(GLOBVARS.src.bootstrap)
  .pipe(plugins.plumber({errorHandler: plugins.notify.onError(GLOBVARS.onError)}))
  .pipe(plugins.coffeelint({max_line_length: {
    value: 90,
    level: 'warn'
  }}))
  .pipe(plugins.coffeelint.reporter())
  .pipe(plugins.coffeelint.reporter('fail'))
  .pipe(plugins.sourcemaps.init())
  .pipe(plugins.coffee())
  .pipe(amdOptimize('bootstrap', {
    configFile : rjsConf
  }))
  .pipe(plugins.concat('bootstrap.js'))
  .pipe(plugins.size({showFiles: true}))
  .pipe(plugins.sourcemaps.write('maps'))
  .pipe(gulp.dest(GLOBVARS.prod.js));
  return
});

gulp.task('bootstrap:build', function () {
  del([GLOBVARS.prod.js + '/maps'], function() {
     gulp.src(GLOBVARS.src.bootstrap)
    .pipe(plugins.plumber({errorHandler: plugins.notify.onError(GLOBVARS.onError)}))
    .pipe(plugins.coffee())
    .pipe(amdOptimize('bootstrap', {
      configFile : rjsConf
    }))
    .pipe(plugins.concat('bootstrap.js'))
    .pipe(plugins.uglify({
      compress:{
        global_defs: {
          _DEBUG_LOG_: false
        }
      }
    }))
    .pipe(plugins.size({showFiles: true}))
    .pipe(gulp.dest(GLOBVARS.prod.js));
    return;
  });
  return;
});