{-# LANGUAGE TypeFamilies #-}
module JavaScript.Backbone ( extendModel
                           , extendView
                           , Backbone
                           ) where

import Data.Boolean
import Language.Sunroof
import Language.Sunroof.JS.Bool ( jsIfB )
------------------------------------------------------------------------------
import JavaScript.Backbone.Model
import JavaScript.Backbone.View hiding (model)

------------------------------------------------------------------------------
newtype Backbone = Backbone JSObject

------------------------------------------------------------------------------
instance  Show Backbone where
    show (Backbone o) = show o

------------------------------------------------------------------------------
instance Sunroof Backbone where
    unbox (Backbone o) = unbox o
    box o = Backbone (box o)

------------------------------------------------------------------------------
instance IfB Backbone where
    ifB = jsIfB

------------------------------------------------------------------------------
type instance BooleanOf Backbone = JSBool

------------------------------------------------------------------------------
model :: JSSelector JSObject
model = attr "Model"

------------------------------------------------------------------------------
view :: JSSelector JSObject
view = attr "View"

------------------------------------------------------------------------------
extend :: JSObject -> JSObject -> JS t JSObject
extend = invoke "extend"

------------------------------------------------------------------------------
extendObject :: Backbone -> JSSelector JSObject -> JSObject -> JS t JSObject
extendObject backbone klass ob = extend ob (backbone ! klass) 

------------------------------------------------------------------------------
extendModel :: Backbone -> JSObject -> JS t JSBackboneModel
extendModel backbone ob = fmap JSBackboneModel $ extendObject backbone model ob

------------------------------------------------------------------------------
extendView :: Backbone -> JSObject -> JS t (JSBackboneView NotRendered)
extendView backbone = fmap createJSBackboneView . extendObject backbone view
