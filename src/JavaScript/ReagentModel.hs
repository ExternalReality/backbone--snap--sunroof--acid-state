{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

module JavaScript.ReagentModel ( reagentModelModule
                               , name
                               , imageUrl
                               , imageNotFoundUrl
                               , ReagentModel
                               ) where

import Language.Sunroof
import Data.Boolean
import Language.Sunroof.JS.Bool ( jsIfB )
------------------------------------------------------------------------------
import JavaScript.Backbone
import JavaScript.Backbone.Model
import JavaScript.Require

------------------------------------------------------------------------------
newtype ReagentModel = ReagentModel JSBackboneModel

------------------------------------------------------------------------------
instance  Show ReagentModel where
  show (ReagentModel o) = show o

------------------------------------------------------------------------------
instance Sunroof ReagentModel where
  unbox (ReagentModel o) = unbox o
  box o = ReagentModel (box o)

------------------------------------------------------------------------------
instance IfB ReagentModel where
  ifB = jsIfB

------------------------------------------------------------------------------
type instance BooleanOf ReagentModel = JSBool

------------------------------------------------------------------------------
reagentModelModule :: IO String
reagentModelModule = defineModule "ReagentIconViewModule"
                                  moduleDependencies
                                  reagentModel
  where
    moduleDependencies = ["backbone"]

------------------------------------------------------------------------------
reagentModel :: Backbone -> JS t JSObject
reagentModel backbone = do
  reagent <- new "Object" ()
  reagent # url := ("/api/reagents" :: JSString)  
  extendModel backbone reagent

------------------------------------------------------------------------------
name :: ReagentModel -> JS t JSString
name (ReagentModel m) = get m ("name" :: JSString)

------------------------------------------------------------------------------
imageUrl :: ReagentModel -> JS t JSString
imageUrl (ReagentModel m) = get m ("imageUrl" :: JSString)

------------------------------------------------------------------------------
imageNotFoundUrl :: ReagentModel -> JS t JSString
imageNotFoundUrl (ReagentModel m) = get m ("imageNotFoundUrl" :: JSString)

------------------------------------------------------------------------------
url :: JSSelector JSString
url = attr "url"
