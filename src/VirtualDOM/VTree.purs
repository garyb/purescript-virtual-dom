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

import Prelude
import Data.Function
import Data.Maybe

foreign import data VTree :: *

foreign import showVTreeImpl :: VTree -> String

instance showVTree :: Show VTree where
  show = showVTreeImpl

type TagName = String

foreign import vnode_ :: forall props. Fn3 TagName { | props} (Array VTree) VTree

vnode :: forall props. TagName -> { | props} -> Array VTree -> VTree
vnode name props children = runFn3 vnode_ name props children

foreign import vtext :: String -> VTree

foreign import widget :: forall props. { | props} -> VTree

foreign import thunk_ :: Fn3  (Maybe VTree -> VTree) 
                              (Maybe VTree) 
                              (VTree -> Maybe VTree) 
                              VTree

-- Render a VTree using custom logic function.  The logic can examine the 
-- previous VTree before returning the new (or same) one.  The result of the 
-- render function must be a vnode, vtext, or widget.  This constraint is not
-- enforced by the types.
thunk :: (Maybe VTree -> VTree) -> VTree
thunk render = runFn3 thunk_ render Nothing Just

foreign import data VHook :: *

foreign import vhook  :: forall props. { | props } -> VHook

foreign import showVHookImpl :: VHook -> String

instance showVHook :: Show VHook where
  show = showVHookImpl


