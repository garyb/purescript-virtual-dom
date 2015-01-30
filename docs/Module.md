# Module Documentation

## Module VirtualDOM

### Types

     PatchObject represents an Array<VPatch>, where each VPatch is a patch 
     operation.  See virtual-dom/docs.jsig for details.                             

    data PatchObject :: *


### Type Class Instances


    instance showPatchObject :: Show PatchObject


### Values


    createElement :: VTree -> Node


    diff :: VTree -> VTree -> PatchObject


    patch :: forall e. PatchObject -> Node -> Eff (dom :: DOM | e) Node


## Module VirtualDOM.VTree

### Types


    type TagName = String


    data VHook :: *


    data VTree :: *


### Type Class Instances


    instance showVHook :: Show VHook


    instance showVTree :: Show VTree


### Values

     Render a VTree using custom logic function.  The logic can examine the 
     previous VTree before returning the new (or same) one.  The result of the 
     render function must be a vnode, vtext, or widget.  This constraint is not
     enforced by the types.

    thunk :: (Maybe VTree -> VTree) -> VTree


    vhook :: forall props. {  | props } -> VHook


    vnode :: forall props. TagName -> {  | props } -> [VTree] -> VTree


    vtext :: String -> VTree


    widget :: forall props. {  | props } -> VTree