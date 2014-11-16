module VirtualDOM.VTree
  ( VTree()
  , TagName()
  , Key()
  , Namespace()
  , vnode
  , vtext
  ) where

import Data.Function
import Data.Maybe

foreign import data VTree :: *

foreign import showVTreeImpl
  "var showVTreeImpl = JSON.stringify;" :: VTree -> String

instance showVTree :: Show VTree where
  show = showVTreeImpl

type TagName = String
type Key = String
type Namespace = String

foreign import unsafeNull
  "var unsafeNull = null;" :: forall a. a

foreign import vnode' """
  var vnode$prime = (function() {
    var VNode = require('vtree/vnode');
    return function (name, props, children, key, ns) {
      return new VNode(name, props, children, key, ns);
    };
  }());
  """ :: forall props. Fn5 TagName { | props } [VTree] Key Namespace VTree

vnode :: forall props. TagName -> { | props } -> [VTree] -> Maybe Key -> Maybe Namespace -> VTree
vnode name props children key ns =
  runFn5 vnode' name props children (fromMaybe unsafeNull key) (fromMaybe unsafeNull ns)

foreign import vtext """
  var vtext = (function() {
    var VText = require('vtree/vtext');
    return function (text) {
      return new VText(text);
    };
  }());
  """ :: String -> VTree
