module VirtualDOM
  ( PatchObject()
  , createElement
  , diff
  , patch
  ) where

import Control.Monad.Eff
import Data.Function
import DOM
import VirtualDOM.VTree

-- PatchObject represents an Array<VPatch>, where each VPatch is a patch 
-- operation.  See virtual-dom/docs.jsig for details.                             
foreign import data PatchObject :: *

foreign import showPatchObjectImpl
  "var showPatchObjectImpl = JSON.stringify;" :: PatchObject -> String

instance showPatchObject :: Show PatchObject where
  show = showPatchObjectImpl

foreign import createElement
  "var createElement = require('virtual-dom/create-element');" :: VTree -> Node

foreign import diff'
  "var diff$prime = require('virtual-dom/diff');" :: Fn2 VTree VTree PatchObject

diff :: VTree -> VTree -> PatchObject
diff = runFn2 diff'

foreign import patch'
  "var patch$prime = require('virtual-dom/patch');" :: Fn2 Node PatchObject Node

patch :: forall e. PatchObject -> Node -> Eff (dom :: DOM | e) Node
patch p n = mkEff \_ -> runFn2 patch' n p

foreign import mkEff """
  function mkEff(action) {
    return action;
  }
  """ :: forall eff a. (Unit -> a) -> Eff eff a
