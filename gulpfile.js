'use strict';

var gulp = require('gulp');
var sourcemaps = require("gulp-sourcemaps");
var babel = require("gulp-babel");
var concat = require("gulp-concat");

const SRC_DIR = "./src";
const BUILD_DIR = "./build";
const TESTS_DIR = "./tests";
const ASSETS_DIR = "./assets";

// Clean build directory
gulp.task('clean', function() {
	return gulp.src(BUILD_DIR + '/*', {read: false})
	.pipe(clean());
});

// Copy static content to build directory
gulp.task('copy', function() {
	gulp.src(ASSETS_DIR + '/**')
	.pipe(gulp.dest(BUILD_DIR));

	return gulp.src('src/manifest.json')
	.pipe(gulp.dest(BUILD_DIR));
});

//copy and compress HTML files
gulp.task('html', function() {
	return gulp.src('src/*.html')
	.pipe(gulp.dest('build'));
});

gulp.task("js", function () {
	return gulp.src("src/**/*.js")
	.pipe(sourcemaps.init())
	.pipe(babel())
	.pipe(concat("all.js"))
	.pipe(sourcemaps.write("."))
	.pipe(gulp.dest("dist"));
});

//minify styles
gulp.task('styles', function() {
	// 	return gulp.src('src/styles/**/*.css')
	// 		.pipe(minifycss({root: 'src/styles', keepSpecialComments: 0}))
	// 		.pipe(gulp.dest('build/styles'));
	return gulp.src('src/styles/**')
	.pipe(gulp.dest('build/styles'));
});

//build ditributable and sourcemaps after other tasks completed
gulp.task('zip', ['html', 'scripts', 'styles', 'copy'], function() {
	var manifest = require('./src/manifest'),
	distFileName = manifest.name + ' v' + manifest.version + '.zip',
	mapFileName = manifest.name + ' v' + manifest.version + '-maps.zip';
	//collect all source maps
	gulp.src('build/scripts/**/*.map')
	.pipe(zip(mapFileName))
	.pipe(gulp.dest('dist'));
	//build distributable extension
	return gulp.src(['build/**', '!build/scripts/**/*.map'])
	.pipe(zip(distFileName))
	.pipe(gulp.dest('dist'));
});

//run all tasks after build directory has been cleaned
gulp.task('default', ['clean'], function() {
	gulp.start('zip');
});
