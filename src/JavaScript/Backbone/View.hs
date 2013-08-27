{-# LANGUAGE TypeFamilies #-}

module JavaScript.Backbone.View ( el
                                , events
                                , extend
                                , render
                                , renderTemplate
                                , model
                                , Rendered
                                , NotRendered
                                , JSBackboneView(..)
                                ) where

import Data.Boolean
import Language.Sunroof
import Language.Sunroof.JS.Bool ( jsIfB )
import Language.Sunroof.JS.Map
------------------------------------------------------------------------------
import           JavaScript.Mustache hiding (render)
import qualified JavaScript.Mustache as Mustache

------------------------------------------------------------------------------
data Rendered
data NotRendered

------------------------------------------------------------------------------
newtype JSBackboneView t = JSBackboneView { obj :: JSObject }

------------------------------------------------------------------------------
instance Show (JSBackboneView t) where
  show (JSBackboneView o) = show o

------------------------------------------------------------------------------
-- | First-class values in Javascript.
instance Sunroof (JSBackboneView t) where
  box = JSBackboneView . box
  unbox (JSBackboneView o) = unbox o

------------------------------------------------------------------------------
-- | Associated boolean is 'JSBool'.
type instance BooleanOf (JSBackboneView t) = JSBool

------------------------------------------------------------------------------
-- | Can be returned in branches.
instance IfB (JSBackboneView t) where
  ifB = jsIfB

------------------------------------------------------------------------------
-- | Reference equality, not value equality.
instance EqB (JSBackboneView t) where
  (JSBackboneView a) ==* (JSBackboneView b) = a ==* b

------------------------------------------------------------------------------
-- | Get HTML element from a rendered view
el :: JSBackboneView Rendered -> JSObject
el (JSBackboneView jso ) = jso ! attr "el"

------------------------------------------------------------------------------
renderTemplate :: JSBackboneView a -> JSString -> JSTemplateBindings -> JS t ()
renderTemplate view template bindings = do
  renderedTemplate <- Mustache.render $$ (template, bindings)
  setElement view renderedTemplate 
  
------------------------------------------------------------------------------
setElement :: JSBackboneView a -> JSObject ->  JS t ()
setElement  view element = invoke "setElement" element (obj view)

------------------------------------------------------------------------------
render :: JSSelector (JSFunction () (JSBackboneView Rendered))
render = attr "render"

------------------------------------------------------------------------------
model :: JSSelector JSObject
model = attr "model" 

------------------------------------------------------------------------------
events :: SunroofKey a => JSSelector (JSMap a (JSFunction () ()))
events = attr "events"

------------------------------------------------------------------------------
extend :: JSFunction JSObject (JSBackboneView NotRendered)
extend = fun "Backbone.View.extend" 
