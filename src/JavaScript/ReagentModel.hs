{-# LANGUAGE TypeFamilies    #-}
-- 
module JavaScript.ReagentModel (reagentModelModule) where

import Language.Sunroof

import JavaScript.Backbone.Model
import JavaScript.Require


reagentModelModule :: IO String
reagentModelModule = defineModule "ReagentIconViewModule" 
                                  moduleDependencies
                                  reagentModel
  where
    moduleDependencies =  ["backbone"]

reagentModel :: JSObject -> JS t JSBackboneModel
reagentModel backbone = do
  reagent <- new "Object" () 
  (`extend` (backbone ! model)) reagent                  
