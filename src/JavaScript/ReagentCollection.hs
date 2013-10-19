{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
module JavaScript.ReagentCollection (reagentCollectionModule) where

import Language.Sunroof
import Data.Boolean
import Language.Sunroof.JS.Bool ( jsIfB )
------------------------------------------------------------------------------
import JavaScript.Backbone
import JavaScript.Backbone.Collection
import JavaScript.ReagentModel
import JavaScript.Require

newtype ReagentCollection = ReagentCollection JSBackboneCollection

------------------------------------------------------------------------------
instance  Show ReagentCollection where
  show (ReagentCollection o) = show o

------------------------------------------------------------------------------
instance Sunroof ReagentCollection where
  unbox (ReagentCollection o) = unbox o
  box o = ReagentCollection (box o)

------------------------------------------------------------------------------
instance IfB ReagentCollection where
  ifB = jsIfB

------------------------------------------------------------------------------
type instance BooleanOf ReagentCollection = JSBool

------------------------------------------------------------------------------
reagentCollectionModule :: IO String
reagentCollectionModule = defineModule "ReagentCollectionModule"
                                       moduleDependencies
                                       reagentCollection
  where
    moduleDependencies = [ "backbone"
                         , "models/reagent-model"
                         ]

------------------------------------------------------------------------------
reagentCollection :: (Backbone, ReagentModel) -> JS t JSObject
reagentCollection (backbone, reagentModel) = do 
  collection <- new "Object" ()
  collection # url   := ("/api/reagents" :: JSString)
  collection # model := reagentModel
  extendCollection backbone collection
