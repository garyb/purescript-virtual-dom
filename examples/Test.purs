module Test where

import VirtualDOM
import VirtualDOM.VTree
import Debug.Trace
import Control.Monad.Eff
import Data.Maybe
import DOM

foreign import createDOMElement
  "function createDOMElement(name) {\
  \  return function() {\
  \    return document.createElement(name);\
  \  };\
  \}" :: forall eff. String -> Eff (dom :: DOM | eff) Node 

defVNode = 
  { namespace:  Nothing -- required by VNodeOpts type
  , key:        Nothing -- required by VNodeOpts type
  , attributes: Nothing -- required by VNodeOpts type
  , style:      Nothing -- required by VNodeOpts type
  , customHook: Nothing :: Maybe VHook
  , customProp: Nothing :: Maybe String
  }

doc1 :: VTree
doc1 = vnode "div" defVNode [vtext "hello"]

doc2 :: VTree
doc2 = vnode "div" defVNode [vtext "hello", vtext "world"]

doc3 :: VTree
doc3 = vtext "hello world"

doc4 :: VTree
doc4 = 
  vnode "div" defVNode
    { namespace = Just "http://www.w3.org/2000/svg"
    , key       = Just "my key"
    } [vtext "Am I SVG?"]

doc5 :: VTree
doc5 = 
  vnode "div" defVNode
    { key       = Just "another key"
    , namespace = Just "http://www.w3.org/1999/xhtml"
    , style     = Just { color:  "red"
                       , height: "10px"
                       , width:  "100px"
                       }
    } [vtext "I do it with style."]

basicWidget = 
  { init:     const $ createDOMElement "div" -- invoke widget code here 
  , update:   \_ _ -> return unit            -- update logic goes here
  , destroy:  \_   -> return unit            -- destroy logic goes here
  } :: WidgetOpts _ _ _

doc6 :: VTree
doc6 = vnode "div" defVNode [vtext "with widget", widget basicWidget]

doc7 :: VTree
doc7 = 
  vnode "div" defVNode 
      [ vtext "with valid widget and thunk"
      , widget basicWidget
      , thunk {}
      ]

doc8 :: VTree
doc8 = 
  let d = \node string -> return unit -- hook logic goes here
  in vnode "div" defVNode [
      vnode "div" defVNode
        { customHook = Just $ vhook { hook:d, unhook:d} 
        , customProp = Just "my customProp" 
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
  printH "diff doc6 doc8" $ diff doc6 doc8
