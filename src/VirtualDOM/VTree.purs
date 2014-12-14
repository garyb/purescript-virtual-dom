module VirtualDOM.VTree
  ( VTree()
  , TagName()
  , vnode
  , vtext
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
    var VNode = require('vtree/vnode');
   
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
    var VText = require('vtree/vtext');
    return function (text) {
      return new VText(text);
    };
  }());
  """ :: String -> VTree
