module VirtualDOM.VTree
  ( VTree()
  , VHook()
  , TagName()
  , vnode
  , vtext
  , widget
  , thunk
  , vhook
  ) where

import Data.Function

foreign import data VTree :: *

foreign import showVTreeImpl
  "var showVTreeImpl = JSON.stringify;" :: VTree -> String

instance showVTree :: Show VTree where
  show = showVTreeImpl

type TagName = String

foreign import vnode' """
  var vnode$prime = (function() {
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
  }());
  """ :: forall props. Fn3 TagName { | props} [VTree] VTree

vnode :: forall props. TagName -> { | props} -> [VTree] -> VTree
vnode name props children = runFn3 vnode' name props children

foreign import vtext """
  var vtext = (function() {
    var VText = require('virtual-dom/vnode/vtext');
    return function (text) {
      return new VText(text);
    };
  }());
  """ :: String -> VTree

foreign import widget """
  var widget = (function() { 
    return function (props) {
      var rWidget = { type: 'Widget'};
       
      if(props.init)    { rWidget.init    = props.init };
      if(props.update)  { rWidget.update  = props.update }; 
      if(props.destroy) { rWidget.destroy = props.destroy };

      return rWidget;
    };
  }());
  """ :: forall props. { | props} -> VTree

foreign import thunk  """
  var thunk  = (function() { 
    return function (props) {
      var rThunk  = { type: 'Thunk'};
       
      if(props.vnode)   { rThunk.vnode  = props.vnode };
      if(props.render)  { rThunk.render = props.render }; 

      return rThunk;
    };
  }());
  """ :: forall props. { | props} -> VTree

foreign import data VHook :: *

foreign import vhook  """
  var vhook  = (function() { 
    return function (props) {
      var rVHook  = function () { };
      if(props.hook)   { rVHook.prototype.hook    = props.hook };
      if(props.unhook) { rVHook.prototype.unhook  = props.unhook }; 
      return new rVHook;
    };
  }());
  """ :: forall props. { | props } -> VHook

foreign import showVHookImpl
  "var showVHookImpl = JSON.stringify;" :: VHook -> String

instance showVHook :: Show VHook where
  show = showVHookImpl


