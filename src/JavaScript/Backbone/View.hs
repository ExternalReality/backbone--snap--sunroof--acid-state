{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeFamilies   #-}
{-# LANGUAGE EmptyDataDecls #-}

module JavaScript.Backbone.View ( el
                                , events
                                , render
                                , renderTemplate
                                , model
                                , viewObject
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
import           JavaScript.Backbone.Model

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
instance IfB (JSBackboneView t) where
  ifB = jsIfB

------------------------------------------------------------------------------
-- | Reference equality, not value equality.
instance EqB (JSBackboneView t) where
  (JSBackboneView a) ==* (JSBackboneView b) = a ==* b

------------------------------------------------------------------------------
-- | Create a new backbone js view object
viewObject :: JS t (JSBackboneView NotRendered)
viewObject = JSBackboneView `fmap` new "Object" () 

------------------------------------------------------------------------------
-- | Get DOM element from a rendered view
el :: JSBackboneView Rendered -> JSObject
el _view = _view ! attr "el"

------------------------------------------------------------------------------
renderTemplate :: JSBackboneView a -> JSObject -> JSString -> TemplateBindings -> JS t ()
renderTemplate _view templateRenderer template bindings = do
  renderedTemplate <- Mustache.render (template, bindings) templateRenderer
  setElement _view renderedTemplate 
  
------------------------------------------------------------------------------
setElement :: JSBackboneView a -> JSObject ->  JS t ()
setElement  _view element = invoke "setElement" element _view

------------------------------------------------------------------------------
-- | The render attribte of the view which is to be set to a JavaScript function
render :: JSSelector (JSFunction () (JSBackboneView Rendered))
render = attr "render"

------------------------------------------------------------------------------
-- | The model attribute of the view  
model :: JSSelector t
model = attr "model" 

------------------------------------------------------------------------------
-- | The events attribute of the view
events :: SunroofKey a => JSSelector (JSMap a (JSFunction () ()))
events = attr "events"
