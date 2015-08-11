"use strict";

// module VirtualDOM

exports.showPatchObjectImpl = JSON.stringify;

exports.createElement = require('virtual-dom/create-element');

exports.diff_ = require('virtual-dom/diff');

exports.patch_ = require('virtual-dom/patch');

exports.mkEff = function (action) {
    return action;
};

