## Module VirtualDOM.VTree

#### `VTree`

``` purescript
data VTree
```

##### Instances
``` purescript
instance showVTree :: Show VTree
```

#### `showVTreeImpl`

``` purescript
showVTreeImpl :: VTree -> String
```

#### `TagName`

``` purescript
newtype TagName
  = TagName String
```

##### Instances
``` purescript
instance eqTagName :: Eq TagName
instance ordTagName :: Ord TagName
instance showTagName :: Show TagName
```

#### `Namespace`

``` purescript
newtype Namespace
  = Namespace String
```

##### Instances
``` purescript
instance eqNamespace :: Eq Namespace
instance ordNamespace :: Ord Namespace
instance showNamespace :: Show Namespace
```

#### `Key`

``` purescript
newtype Key
  = Key String
```

##### Instances
``` purescript
instance eqKey :: Eq Key
instance ordKey :: Ord Key
instance showKey :: Show Key
```

#### `vnode`

``` purescript
vnode :: forall props. TagName -> {  | props } -> Array VTree -> VTree
```

#### `vnode'`

``` purescript
vnode' :: forall props. Namespace -> TagName -> Key -> {  | props } -> Array VTree -> VTree
```

#### `vnodeImpl`

``` purescript
vnodeImpl :: forall props. Nullable Namespace -> TagName -> Nullable Key -> {  | props } -> Array VTree -> VTree
```

#### `vtext`

``` purescript
vtext :: String -> VTree
```


