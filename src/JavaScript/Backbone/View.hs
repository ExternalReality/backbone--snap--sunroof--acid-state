{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeFamilies   #-}
{-# LANGUAGE EmptyDataDecls #-}

module JavaScript.Backbone.View ( el
                                , events
                                , render
                                , model
                                , bindings
                                , initialize
                                , createJSBackboneView
                                , Rendered
                                , NotRendered
                                , JSBackboneView
                                ) where

import Data.Boolean
import Language.Sunroof
import Language.Sunroof.JS.Bool ( jsIfB )
import Language.Sunroof.JS.Map
------------------------------------------------------------------------------
import           JavaScript.Mustache hiding (render)
import qualified JavaScript.Mustache as Mustache

------------------------------------------------------------------------------
-- | Any operation that manipulates the DOM elements associated with
-- a view must be operate on a `Rendered` view. Thus the phantom type.
data Rendered
data NotRendered

------------------------------------------------------------------------------
newtype JSBackboneView t = JSBackboneView  JSObject

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
createJSBackboneView :: JSObject -> JSBackboneView NotRendered
createJSBackboneView = JSBackboneView 

------------------------------------------------------------------------------
-- | Get DOM element from a rendered view
el :: JSBackboneView Rendered -> JSObject
el _view = _view ! attr "el"
  
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

------------------------------------------------------------------------------
bindings :: JSSelector (JSFunction () TemplateBindings)
bindings = attr "bindings"

------------------------------------------------------------------------------
initialize :: Sunroof a => JSSelector (JSFunction a ())
initialize = attr "bindings"
