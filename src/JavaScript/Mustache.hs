module JavaScript.Mustache (render, TemplateBindings) where

import Language.Sunroof

type TemplateBindings = JSObject

render :: (JSString, TemplateBindings) -> JSObject -> JS t JSObject 
render = invoke "render"
