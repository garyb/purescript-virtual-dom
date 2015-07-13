module VirtualDOM
  ( Patch()
  , createElement
  , diff
  , patch
  ) where

import Prelude
import Control.Monad.Eff (Eff())
import DOM (DOM(), Node())
import VirtualDOM.VTree (VTree())

data Patch

foreign import showPatchImpl :: Patch -> String

instance showPatchObject :: Show Patch where
  show = showPatchImpl

foreign import createElement :: forall eff. VTree -> Eff (dom :: DOM | eff) Node

foreign import diff :: VTree -> VTree -> Patch

foreign import patch :: forall eff. Patch -> Node -> Eff (dom :: DOM | eff) Node
