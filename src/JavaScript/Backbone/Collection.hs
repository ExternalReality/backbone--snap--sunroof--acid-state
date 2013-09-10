{-# LANGUAGE TypeFamilies #-}
module JavaScript.Backbone.Collection ( model
                                      , url
                                      , JSBackboneCollection (..)
                                      ) where

import Data.Boolean
import Language.Sunroof
import Language.Sunroof.JS.Bool ( jsIfB )

------------------------------------------------------------------------------
newtype JSBackboneCollection = JSBackboneCollection JSObject

------------------------------------------------------------------------------
instance Show JSBackboneCollection where
  show (JSBackboneCollection o) = show o

------------------------------------------------------------------------------
-- | First-class values in Javascript.
instance Sunroof JSBackboneCollection where
  box = JSBackboneCollection . box
  unbox (JSBackboneCollection o) = unbox o

------------------------------------------------------------------------------
-- | Associated boolean is 'JSBool'.
type instance BooleanOf JSBackboneCollection = JSBool

------------------------------------------------------------------------------
instance IfB JSBackboneCollection where
  ifB = jsIfB

------------------------------------------------------------------------------
-- | Reference equality, not value equality.
instance EqB JSBackboneCollection where
  (JSBackboneCollection a) ==* (JSBackboneCollection b) = a ==* b

------------------------------------------------------------------------------
model :: JSSelector t
model = attr "model"

------------------------------------------------------------------------------
url :: JSSelector t
url = attr "url"
