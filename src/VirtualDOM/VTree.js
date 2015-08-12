"use strict";

// module VirtualDOM.VTree

exports.showVTreeImpl = JSON.stringify;

exports.vnode_ = function() {
    var VNode = require('virtual-dom/vnode/vnode');
   
    return function (name, props, children) {
      var key = undefined;
      var ns = undefined;

      if(props.namespace) {
        ns = props.namespace;
        props.namespace = undefined;
      }

      if(props.key) {
        key = props.key;
        props.key = undefined;
      }

      return new VNode(name, props, children, key, ns);
    };
}();

exports.vtext = function() {
    var VText = require('virtual-dom/vnode/vtext');
    return function (text) {
      return new VText(text);
    };
}();

exports.widget = function() { 
    return function (props) {
      var rWidget = { type: 'Widget'};
       
      if(props.init)    { rWidget.init    = props.init };
      if(props.update)  { rWidget.update  = props.update }; 
      if(props.destroy) { rWidget.destroy = props.destroy };

      return rWidget;
    };
}();

exports.thunk_ = function() { 
    return function (renderFn, nothing, just) {
      var rThunk  = { type: 'Thunk'
                    , render: function(prevNode) { 
                                if (prevNode === null)
                                  return renderFn(nothing);
                                else
                                  return renderFn(just(prevNode));
                              }
                    };
      // No need for vnode here.  It is used internally by virtual-dom to cache
      // the result of render.
      return rThunk;
    };
}();

exports.vhook = function() { 
    return function (props) {
      var rVHook  = function () { };
      if(props.hook)   { rVHook.prototype.hook    = props.hook };
      if(props.unhook) { rVHook.prototype.unhook  = props.unhook }; 
      return new rVHook;
    };
}();

exports.showVHookImpl = JSON.stringify;
