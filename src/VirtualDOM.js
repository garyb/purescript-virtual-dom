/* global exports, require */
"use strict";

// module VirtualDOM

exports.showPatchImpl = JSON.stringify;

exports.createElement = function () {
  var createElement = require("virtual-dom/create-element");
  return function (vtree) {
    return function () {
      return createElement(vtree);
    };
  };
}();

exports.diff = function () {
  var diff = require("virtual-dom/diff");
  return function (vtree1) {
    return function (vtree2) {
      return diff(vtree1, vtree2);
    };
  };
}();

exports.patch = function () {
  var patch = require("virtual-dom/patch");
  return function (patches) {
    return function (node) {
      return function () {
        return patch(node, patches);
      };
    };
  };
}();
