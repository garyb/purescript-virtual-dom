/* jshint node: true */
"use strict";

var gulp = require("gulp");
var jshint = require("gulp-jshint");
var jscs = require("gulp-jscs");
var purescript = require("gulp-purescript");

var sources = [
  "src/**/*.purs",
  "bower_components/purescript-*/src/**/*.purs",
  "test/**/*.purs"
];

var foreigns = [
  "src/**/*.js",
  "bower_components/purescript-*/src/**/*.js",
  "test/**/*.js"
];

gulp.task("lint", function() {
  return gulp.src("src/**/*.js")
    .pipe(jshint())
    .pipe(jshint.reporter())
    .pipe(jscs());
});

gulp.task("make", ["lint"], function() {
  return purescript.psc({ src: sources, ffi: foreigns });
});

gulp.task("docs", function() {
  return purescript.pscDocs({
    src: sources,
    docgen: {
      "VirtualDOM": "docs/VirtualDOM.md",
      "VirtualDOM.VTree": "docs/VirtualDOM/VTree.md",
    }
  });
});

// gulp.task("bundle", ["make"], function() {
//   return purescript.pscBundle({
//     src: "output/**/*.js",
//     output: "tmp/test.js",
//     main: "Test.Main"
//   });
// });

gulp.task("dotpsci", function () {
  return purescript.psci({ src: sources, ffi: foreigns })
    .pipe(gulp.dest("."));
});

gulp.task("default", ["make", "docs", "dotpsci"]);
