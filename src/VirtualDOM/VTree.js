/* global exports, require */
"use strict";

// module VirtualDOM.VTree

exports.showVTreeImpl = JSON.stringify;

exports.vnodeImpl = function () {
  var VNode = require("virtual-dom/vnode/vnode");
  return function (ns) {
    return function (name) {
      return function (key) {
        return function (props) {
          return function (children) {
            return new VNode(name, props, children, key, ns);
          };
        };
      };
    };
  };
}();

exports.vtext = function () {
  var VText = require("virtual-dom/vnode/vtext");
  return function (text) {
    return new VText(text);
  };
}();

exports.widget = function () {
  return function (init) {
    return function (update) {
      return function (destroy) {
        var Widget = function () {};
        Widget.protoype.type = "Widget";
        if (init) {
          Widget.prototype.init = init;
        }
        if (update) {
          // jshint maxparams: 2
          Widget.prototype.update = function (previous, domNode) {
            return update(previous)(domNode)();
          };
        }
        if (destroy) {
          Widget.prototype.destroy = function (domNode) {
            return destroy(domNode)();
          };
        }
        return function () {
          return new Widget();
        };
      };
    };
  };
}();
