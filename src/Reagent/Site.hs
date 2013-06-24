{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Reagent.Site where

import           Control.Monad.Trans (lift)
import           Data.Aeson
import           Data.ByteString.Char8 (ByteString, unpack, pack)
import           Data.Maybe
import           Data.Text hiding (unpack, pack)
import           Data.Text.Encoding
import           Snap
import           Snap.Snaplet.AcidState
import qualified Data.ByteString.Lazy.Char8 as LBS
------------------------------------------------------------------------------
import           Application
import           Reagent.Reagent

------------------------------------------------------------------------------
setResponseContentTypeToJSON =
  modifyResponse $ setContentType "application/json"


------------------------------------------------------------------------------
bootstrap :: Handler App App ()
bootstrap = method GET $ do
  reagents <- query AllReagents
  let reagentsInJsonFormat = encode $ reagents
  modifyResponse $ setContentType "application/javascript; charset=UTF-8"
  writeLBS $LBS.concat ["var reagents =", reagentsInJsonFormat, ";"]


------------------------------------------------------------------------------
allReagents :: Handler App App ()
allReagents = method GET $ do
  reagents <- query AllReagents
  setResponseContentTypeToJSON
  writeLBS $ encode reagents


------------------------------------------------------------------------------
newReagent :: Handler App App ()
newReagent = method POST $ do
  requestBody <- readRequestBody 2048
  let maybeReagent = decode requestBody
  case maybeReagent of
    (Just reagent ) -> makeNewReagent reagent 
    Nothing         -> error "this fell through"

  where
    makeNewReagent reagent = do 
      result <- update $ NewReagent reagent
      if result
        then modifyResponse $
              setResponseStatus 409 "Conflict: Resource already exists."
        else return ()  


------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("api/reagents"     , allReagents <|> newReagent)
         , ("js/bootstrap.js"  , bootstrap)
         ]
