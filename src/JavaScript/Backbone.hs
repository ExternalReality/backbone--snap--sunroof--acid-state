{-# LANGUAGE TypeFamilies #-}
module JavaScript.Backbone ( extendModel
                           , extendView
                           , extendCollection
                           , Backbone
                           ) where

import Data.Boolean
import Language.Sunroof
import Language.Sunroof.JS.Bool ( jsIfB )

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
collection :: JSSelector JSObject
collection = attr "Collection"

------------------------------------------------------------------------------
extend :: JSObject -> JSObject -> JS t JSObject
extend = invoke "extend"

------------------------------------------------------------------------------
extendCollection :: Backbone
                 -> JSObject 
                 -> JS t JSObject
extendCollection backbone =  extendObject backbone collection

------------------------------------------------------------------------------
extendObject :: Backbone -> JSSelector JSObject -> JSObject -> JS t JSObject
extendObject backbone klass ob = extend ob (backbone ! klass) 

------------------------------------------------------------------------------
extendModel :: Backbone -> JSObject -> JS t JSObject
extendModel backbone = extendObject backbone model

------------------------------------------------------------------------------
extendView :: Backbone -> JSObject -> JS t JSObject
extendView backbone = extendObject backbone view
