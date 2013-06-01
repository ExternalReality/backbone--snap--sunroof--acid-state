{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
module Site
  ( app
  ) where

------------------------------------------------------------------------------
--import Data.Acid hiding (query)
import Data.Aeson
import Data.ByteString.Char8 (ByteString, unpack)
import Data.Maybe
import Snap
import Snap.Snaplet.AcidState
import Snap.Snaplet.Heist
import Snap.Util.FileServe
------------------------------------------------------------------------------
import Application
import Data.Text.Encoding
import PotionSoap
import Reagent
import Snaplet.PotionSoapClient


------------------------------------------------------------------------------
setResponseContentTypeToJSON =
  modifyResponse $ setContentType "application/json"

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
routes = [ (""                 , serveDirectory "static")
         , ("api/reagents"     , allReagents <|> newReagent)
         , ("api/reagents/:id" , reagent) 
         ] 
         

------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    c <- nestSnaplet "PotionSoapClient" client potionSoapClientInitializer
    a <- nestSnaplet "" acid $ acidInit initialPotionSoapState
    addRoutes routes 
    return $ App h c a
