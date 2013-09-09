{-#  LANGUAGE OverloadedStrings #-}

module JavaScript.Site (routes) where

import Application
import Data.Text
import Data.ByteString hiding (pack)
import Snap
------------------------------------------------------------------------------
import JavaScript.ReagentIconView
import JavaScript.ReagentModel

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
reagentModel :: Handler App App ()
reagentModel = writeJavaScriptModule reagentModelModule

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("js/views/reagentIconViewM.js", reagentIconView)
         , ("js/models/reagent-model.js",   reagentModel) 
         ]
