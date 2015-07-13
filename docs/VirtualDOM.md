## Module VirtualDOM

#### `Patch`

``` purescript
data Patch
```

##### Instances
``` purescript
instance showPatchObject :: Show Patch
```

#### `createElement`

``` purescript
createElement :: forall eff. VTree -> Eff (dom :: DOM | eff) Node
```

#### `diff`

``` purescript
diff :: VTree -> VTree -> Patch
```

#### `patch`

``` purescript
patch :: forall eff. Patch -> Node -> Eff (dom :: DOM | eff) Node
```


