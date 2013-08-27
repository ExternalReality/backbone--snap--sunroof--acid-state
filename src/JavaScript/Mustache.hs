module JavaScript.Mustache (render, JSTemplateBindings) where

import Language.Sunroof
import Language.Sunroof.JS.Map

type JSTemplateBindings = JSMap JSString JSObject

render :: JSFunction (JSString, JSTemplateBindings) JSObject 
render = fun "Mustache.render"
