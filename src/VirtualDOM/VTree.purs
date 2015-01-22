module VirtualDOM.VTree
  ( VTree()
  , VNodeOpts()
  , WidgetOpts()
  , VHook()
  , VHookOpts()
  , TagName()
  , vnode
  , vtext
  , widget
  , thunk
  , vhook
  ) where

import Data.Function
import DOM
import Data.Foreign.Options
import Data.Maybe
import Control.Monad.Eff


foreign import data VTree :: *

foreign import showVTreeImpl
  "var showVTreeImpl = JSON.stringify;" :: VTree -> String

instance showVTree :: Show VTree where
  show = showVTreeImpl


-- * VNode

type TagName = String

type VNodeOpts att sty cust = 
  { key         :: Maybe String
  , namespace   :: Maybe String
  , attributes  :: Maybe {|att}
  , style       :: Maybe {|sty}
  | cust
  }

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
  """ :: forall att sty cust. Fn3 TagName (Options (VNodeOpts att sty cust)) [VTree] VTree

vnode :: forall att sty cust. TagName -> VNodeOpts att sty cust -> [VTree] -> VTree
vnode name props children = runFn3 vnode' name (toOptions props) children


-- * VText

foreign import vtext """
  var vtext = (function() {
    var VText = require('virtual-dom/vnode/vtext');
    return function (text) {
      return new VText(text);
    };
  }());
  """ :: String -> VTree


-- * Widget

type WidgetOpts a b c = 
  { init    :: Unit -> Eff (|a) Node
  , update  :: VTree -> Node -> Eff (|b) Unit
  , destroy :: Node -> Eff (|c) Unit
  }

foreign import widget' """
  var widget$prime = (function() { 
    return function (props) {
      var rWidget = { type: 'Widget'};
       
      if(props.init)    { rWidget.init    = props.init };
      if(props.update)  { rWidget.update  = props.update }; 
      if(props.destroy) { rWidget.destroy = props.destroy };

      return rWidget;
    };
  }());
  """ :: forall a b c. Options (WidgetOpts a b c) -> VTree

widget :: forall a b c. WidgetOpts a b c -> VTree
widget = toOptions >>> widget'


-- * Thunk

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


-- * VHook

foreign import data VHookObject :: *
type VHook = Opaque VHookObject

type VHookOpts a b = 
  { hook    :: Node -> String -> Eff (|a) Unit
  , unhook  :: Node -> String -> Eff (|b) Unit
  }

foreign import vhook'  """
  var vhook$prime = (function() { 
    return function (props) {
      var rVHook  = function () { };
      if(props.hook)   { rVHook.prototype.hook    = props.hook };
      if(props.unhook) { rVHook.prototype.unhook  = props.unhook }; 
      return new rVHook();
    };
  }());
  """ :: forall a b. Options (VHookOpts a b) -> VHookObject

vhook :: forall a b. VHookOpts a b -> VHook
vhook = toOptions >>> vhook' >>> Opaque 
-- make opaque so toOptions never converts it to an object literal.  If
-- converted, the hooks in the prototype are lost.

foreign import showVHookImpl
  "var showVHookImpl = JSON.stringify;" :: VHookObject -> String

instance showVHook :: Show (Opaque VHookObject) where
  show (Opaque v) = showVHookImpl v


