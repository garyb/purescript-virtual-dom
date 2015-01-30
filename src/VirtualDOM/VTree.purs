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
import Data.Maybe

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

foreign import thunk'  """
  var thunk$prime  = (function() { 
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
  }());
  """ :: Fn3  (Maybe VTree -> VTree) 
              (Maybe VTree) 
              (VTree -> Maybe VTree) 
              VTree

-- Render a VTree using custom logic function.  The logic can examine the 
-- previous VTree before returning the new (or same) one.  The result of the 
-- render function must be a vnode, vtext, or widget.  This constraint is not
-- enforced by the types.
thunk :: (Maybe VTree -> VTree) -> VTree
thunk render = runFn3 thunk' render Nothing Just

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


