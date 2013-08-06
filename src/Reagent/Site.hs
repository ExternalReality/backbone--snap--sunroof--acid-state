{-# LANGUAGE OverloadedStrings #-}

module Reagent.Site where

import           Data.Aeson
import           Data.ByteString.Char8 (ByteString)
import qualified Data.ByteString.Lazy.Char8 as LBS
import           Data.Maybe
import           Snap
import           Snap.Snaplet.AcidState
import           Snap.Snaplet.Auth
------------------------------------------------------------------------------
import           Application

------------------------------------------------------------------------------
setResponseContentTypeToJSON :: Handler App App ()
setResponseContentTypeToJSON =
  modifyResponse $ setContentType "application/json"

------------------------------------------------------------------------------
bootstrap :: Handler App (AuthManager App) ()
bootstrap = method GET $ do
  userId   <- fromMaybe (error "error") `fmap` liftM (userId =<<) currentUser
  reagents <- query AllReagents
  mixtures <- query $ PotionMakersMixtures userId
  let reagentsInJsonFormat = encode reagents
  let mixturesInJsonFormat = encode mixtures
  modifyResponse $ setContentType "application/javascript; charset=UTF-8"
  writeLBS $ LBS.concat [ "var reagents =",  reagentsInJsonFormat, ";"
                        , "var mixtures =", mixturesInJsonFormat, ";"
                        ]

------------------------------------------------------------------------------
allReagents :: Handler App App ()
allReagents = method GET $ do
  reagents <- query AllReagents
  setResponseContentTypeToJSON
  writeLBS $ encode reagents

------------------------------------------------------------------------------
updateReagent :: Handler App App ()
updateReagent = method PUT $ do
  requestBody <- readRequestBody 2048
  case decode requestBody of 
    (Just reagent) -> update $ UpdateReagent reagent
    Nothing   -> error "this fell through"
                          
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
      when result $ modifyResponse $
          setResponseStatus 409 "Conflict: Resource already exists."
       
------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("api/reagents"     , allReagents <|> newReagent)
         , ("api/reagents/:id" , updateReagent)
         , ("js/bootstrap.js"  , with auth bootstrap)
         ]
