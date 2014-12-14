module Test where

import VirtualDOM
import VirtualDOM.VTree
import Debug.Trace


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

main = do
  print doc1
  print doc2
  print doc3
  print doc4
  print doc5
  
  print $ diff doc1 doc2
  print $ diff doc1 doc3
