{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies    #-}

module JavaScript.Backbone.Model (JSBackboneModel
                                 , model
                                 , extend
                                 , save
                                 ) where

import Data.Boolean
import Language.Sunroof
import Language.Sunroof.JS.Bool ( jsIfB )

newtype JSBackboneModel = JSBackboneModel JSObject

instance  Show JSBackboneModel where
    show (JSBackboneModel o) = show o

instance Sunroof JSBackboneModel where
    unbox (JSBackboneModel o) = unbox o
    box o = JSBackboneModel (box o)

instance IfB JSBackboneModel where
    ifB = jsIfB

type instance BooleanOf JSBackboneModel = JSBool

save :: JSBackboneModel -> JS t ()
save = invoke "save" ()

model :: JSSelector JSObject
model = attr "Model"

extend :: JSObject -> JSObject -> JS t JSBackboneModel
extend = invoke "extend"
