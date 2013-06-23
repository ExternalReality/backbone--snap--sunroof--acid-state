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
reagent :: Handler App App ()
reagent = method GET $ do
  maybeReagentName <- getParam "name"
  let reagentName = read . unpack $ fromMaybe (error "this sucks") maybeReagentName
  maybeReagent <- query $ ReagentByName $ ReagentName reagentName
  let reagent = fromMaybe (error "hah") maybeReagent
  setResponseContentTypeToJSON
  writeLBS $ encode reagent


------------------------------------------------------------------------------
newReagent :: Handler App App ()
newReagent = method PUT $ do
  requestBody <- readRequestBody 1024 --1K byte problably gonna need more than this soon
  let maybeReagentName  = decode requestBody
  case maybeReagentName of
    (Just reagentName) -> update $ NewReagent reagentName
    Nothing            -> error "this fell through"


------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("api/reagents"     , allReagents <|> newReagent)
         , ("api/reagents/:id" , reagent)
         , ("js/bootstrap.js"  , bootstrap)
         ]
