{-#  LANGUAGE OverloadedStrings #-}

module JavaScript.Site (routes) where

import Application
import Data.Text
import Data.ByteString hiding (pack)
import Snap
------------------------------------------------------------------------------
import JavaScript.ReagentIconView
import JavaScript.ReagentModel
import JavaScript.ReagentCollection

------------------------------------------------------------------------------
writeJavaScriptModule :: IO String -> Handler App App ()
writeJavaScriptModule jsModule = do
  modifyResponse $ setContentType "text/javascript; charset=UTF-8"
  javascript <- liftIO jsModule
  writeText . pack $ javascript

------------------------------------------------------------------------------
reagentIconView :: Handler App App ()
reagentIconView = writeJavaScriptModule reagentIconViewModule

------------------------------------------------------------------------------
reagentCollection :: Handler App App ()
reagentCollection = writeJavaScriptModule reagentCollectionModule

------------------------------------------------------------------------------
reagentModel :: Handler App App ()
reagentModel = writeJavaScriptModule reagentModelModule

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("js/models/reagent-model.js",           reagentModel) 
         , ("js/collections/reagent-collection.js", reagentCollection)
         , ("js/foo.js", reagentIconView)
         ]
