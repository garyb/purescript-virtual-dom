"use strict";

// module VirtualDOM

exports.showPatchObjectImpl = JSON.stringify;

exports.createElement = require('virtual-dom/create-element');

exports.diff_ = require('virtual-dom/diff');

exports.patch_ = function (n, p) {
    var patch = require('virtual-dom/patch');
    return function () {
        return patch(n, p);
    };
};
