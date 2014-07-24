module Test where

import Data.Maybe
import VirtualDOM
import VirtualDOM.VTree
import Debug.Trace

doc1 :: VTree
doc1 = vnode "div" {} [vtext "hello"] Nothing Nothing

doc2 :: VTree
doc2 = vnode "div" {} [vtext "hello", vtext "world"] Nothing Nothing

doc3 :: VTree
doc3 = vtext "hello world"

main = do
  print doc1
  print doc2
  print doc3
  print $ diff doc1 doc2
  print $ diff doc1 doc3
