module JavaScript.Mustache (render, JSTemplateBindings) where

import Language.Sunroof
import Language.Sunroof.JS.Map

type JSTemplateBindings = JSMap JSString JSObject

render ::  (JSString, JSTemplateBindings) -> JSObject -> JS t JSObject 
render = invoke "render"
