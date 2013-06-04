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
bootstrap = do
  reagents <- query AllReagents
  let reagentsInJsonFormat = encode $ reagents
  modifyResponse $ setContentType "text/javascript; charset=UTF-8"
  writeLBS $LBS.concat ["var reagents =", reagentsInJsonFormat, ";"]


------------------------------------------------------------------------------
allReagents :: Handler App App ()
allReagents = method GET $ do
  reagents <- query AllReagents
  setResponseContentTypeToJSON
  writeLBS $ encode reagents


------------------------------------------------------------------------------
reagent :: Handler App App ()
reagent = method GET $ do
  maybeReagentId <- getParam "id"
  let reagentId = read . unpack $ fromMaybe (error "this sucks") maybeReagentId
  maybeReagent <- query $ ReagentById $ ReagentId reagentId
  let reagent = fromMaybe (error "hah") maybeReagent
  setResponseContentTypeToJSON
  writeLBS $ encode reagent


------------------------------------------------------------------------------
newReagent :: Handler App App ()
newReagent = method POST $ do
  maybeName <- getParam "name"
  case maybeName of
    (Just name) -> update $ NewReagent (ReagentName $ decodeUtf8 name)
    (Nothing)   -> error $ "this fell through"


------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("api/reagents"     , allReagents <|> newReagent)
         , ("api/reagents/:id" , reagent)
         , ("js/bootstrap.js"  , bootstrap)
         ]
