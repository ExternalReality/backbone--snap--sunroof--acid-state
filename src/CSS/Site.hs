{-#  LANGUAGE OverloadedStrings #-}

module CSS.Site where

import Application
import Clay
import Data.ByteString
import Snap
------------------------------------------------------------------------------
import CSS.ReagentIcon

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("reagent-icon.css",   css) ]


------------------------------------------------------------------------------
css :: Handler App App ()
css = do
  modifyResponse $ setContentType "text/css; charset=UTF-8"
  writeLazyText $ renderWith compact [] styles
  
------------------------------------------------------------------------------
styles :: Css
styles = do          
  reagentIconCss
  mixtureCss
  buttonCss
  orangeGrandientCss 
                      
