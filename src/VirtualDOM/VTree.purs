module VirtualDOM.VTree where
  -- ( VTree()
  -- , VHook()
  -- , TagName()
  -- , vnode
  -- , vtext
  -- , widget
  -- , thunk
  -- , vhook
  -- ) where

import Prelude

-- import Data.Function
import Data.Maybe
import Data.Nullable

data VTree

foreign import showVTreeImpl :: VTree -> String

instance showVTree :: Show VTree where
  show = showVTreeImpl

newtype TagName = TagName String

instance eqTagName :: Eq TagName where
  eq (TagName x) (TagName y) = x == y

instance ordTagName :: Ord TagName where
  compare (TagName x) (TagName y) = compare x y

instance showTagName :: Show TagName where
  show (TagName s) = "TagName " ++ s

newtype Namespace = Namespace String

instance eqNamespace :: Eq Namespace where
  eq (Namespace x) (Namespace y) = x == y

instance ordNamespace :: Ord Namespace where
  compare (Namespace x) (Namespace y) = compare x y

instance showNamespace :: Show Namespace where
  show (Namespace s) = "Namespace " ++ s

newtype Key = Key String

instance eqKey :: Eq Key where
  eq (Key x) (Key y) = x == y

instance ordKey :: Ord Key where
  compare (Key x) (Key y) = compare x y

instance showKey :: Show Key where
  show (Key s) = "Key " ++ s

vnode :: forall props. TagName -> { | props} -> Array VTree -> VTree
vnode tag props children = vnodeImpl (toNullable Nothing) tag (toNullable Nothing) props children

vnode' :: forall props. Namespace -> TagName -> Key -> { | props} -> Array VTree -> VTree
vnode' ns tag key props children = vnodeImpl (toNullable $ Just ns) tag (toNullable $ Just key) props children

foreign import vnodeImpl :: forall props. Nullable Namespace -> TagName -> Nullable Key -> { | props} -> Array VTree -> VTree

foreign import vtext :: String -> VTree
