module VirtualDOM
  ( PatchObject()
  , DOMNode()
  , DOM()
  , createElement
  , diff
  , patch
  ) where

import Control.Monad.Eff
import Data.Function
import VirtualDOM.VTree

-- TODO: there should probably be a real library for this
foreign import data DOMNode :: *
foreign import data DOM :: !

foreign import data PatchObject :: *

foreign import showPatchObjectImpl
  "var showPatchObjectImpl = JSON.stringify;" :: PatchObject -> String

instance showPatchObject :: Show PatchObject where
  show = showPatchObjectImpl

foreign import createElement
  "var createElement = require('virtual-dom/create-element');" :: VTree -> DOMNode

foreign import diff'
  "var diff$prime = require('virtual-dom/diff');" :: Fn2 VTree VTree PatchObject

diff :: VTree -> VTree -> PatchObject
diff = runFn2 diff'

foreign import patch'
  "var patch$prime = require('virtual-dom/patch');" :: Fn2 DOMNode PatchObject DOMNode

patch :: forall e. PatchObject -> DOMNode -> Eff (dom :: DOM | e) DOMNode
patch p n = return $ runFn2 patch' n p
