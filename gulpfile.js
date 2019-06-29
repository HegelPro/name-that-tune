const gulp = require('gulp');
const shell = require('gulp-shell')
const { watch } = require('gulp')

gulp.task('rebuild', shell.task([
  // 'node server',
  'elm make src/Main.elm --output elm.js --debug',
]))

gulp.task('default', () => {
  const watcher = watch([
    'src/*.elm',
    'src/Components/*.elm',
    'src/Models/*.elm',
    "src/Utils/*.elm",
  ])

  watcher.on('change', gulp.task('rebuild'))

  watcher.on('add', gulp.task('rebuild'))

  watcher.on('unlink', gulp.task('rebuild'))
})