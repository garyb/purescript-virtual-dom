module Test where

import VirtualDOM
import VirtualDOM.VTree
import Debug.Trace
import Control.Monad.Eff
import Data.Maybe


doc1 :: VTree
doc1 = vnode "div" {} [vtext "hello"]

doc2 :: VTree
doc2 = vnode "div" {} [vtext "hello", vtext "world"]

doc3 :: VTree
doc3 = vtext "hello world"

doc4 :: VTree
doc4 = vnode "div" 
    { "namespace": "http://www.w3.org/2000/svg"
    , "key": "my key"
    } [vtext "Am I SVG?"]

doc5 :: VTree
doc5 = vnode "div"
    { "key": "another key"
    , "namespace": "http://www.w3.org/1999/xhtml"
    , "style": { "color":  "red"
               , "height": "10px"
               , "width":  "100px"
               }
           } [vtext "I do it with style."]

doc6 :: VTree
doc6 = vnode "div" {} [vtext "with invalid widget", widget {}]

doc7 :: VTree
doc7 = 
  let d = void
  in vnode "div" {} [ vtext "with valid widget and thunk"
                    , widget {init:d, update:d, destroy:d}
                    , thunk $ maybe 
                        (vnode "div" {} [vtext "inside thunk, doc 7 tree 1"])
                        (\_ -> vnode "div" {} [vtext "inside thunk, doc 7 tree 2"])
                    ]

-- Make an equivalent (to thunk) but not *identical* tree to force thunk 
-- evaluation when doing diff.
doc7B :: VTree
doc7B = 
  let d = void
  in vnode "div" {} [ vtext "with valid widget and thunk"
                    , widget {init:d, update:d, destroy:d}
                    , thunk $ maybe 
                        (vnode "div" {} [vtext "inside thunk, doc 7B tree 1"])
                        (\_ -> vnode "div" {} [vtext "inside thunk, doc 7B tree 2"])
                    ]


doc8 :: VTree
doc8 = 
  let d = void
  in vnode "div" {} [
      vnode "div" { hookProp: vhook { hook:d, unhook:d} 
                  , customProp: "my key" 
                  } 
                  [vtext "with hooks"]
      ]

printH :: forall eff a. (Show a) => String -> a -> Eff (trace :: Trace | eff) Unit
printH hdr o = do 
  print $ "=== " ++ hdr ++ " ===" 
  print o

main = do

  printH "doc1" doc1
  printH "doc2" doc2
  printH "doc3" doc3
  printH "doc4" doc4
  printH "doc5" doc5
  printH "doc6" doc6
  printH "doc7" doc7
  printH "doc8" doc8
  
  printH "diff doc1 doc2" $ diff doc1 doc2
  printH "diff doc1 doc3" $ diff doc1 doc3

  printH "diff doc6 doc7" $ diff doc6 doc7
  printH "diff doc7 doc7B"$ diff doc7 doc7B
  printH "diff doc6 doc8" $ diff doc6 doc8
