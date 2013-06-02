{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import Control.Monad.Trans (lift)
import Data.Aeson
import Data.ByteString.Char8 (ByteString, unpack, pack)
import Data.Maybe
import qualified Data.Text.Lazy.Encoding as LE
import qualified Data.ByteString.Lazy.Char8 as LBS
import Heist.Interpreted
import Snap
import Snap.Snaplet.AcidState
import Snap.Snaplet.Heist
import Snap.Util.FileServe

------------------------------------------------------------------------------
import Application
import Data.Text hiding (unpack, pack)
import Data.Text.Encoding
import PotionSoap
import Reagent


------------------------------------------------------------------------------
setResponseContentTypeToJSON =
  modifyResponse $ setContentType "application/json"


------------------------------------------------------------------------------
bootstrap :: Handler App App ()
bootstrap = do
  reagents <- query AllReagents
  let reagentsInJsonFormat = LBS.unpack . encode $ reagents
  modifyResponse $ setContentType "text/javascript; charset=UTF-8"
  writeBS . pack $ "var reagents =" ++ reagentsInJsonFormat ++ ";"


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
routes = [ (""                 , serveDirectoryWith fancyDirectoryConfig "public")
         , ("api/reagents"     , allReagents <|> newReagent)
         , ("api/reagents/:id" , reagent)
         , ("js/bootstrap.js"     , bootstrap)
         ]


------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    a <- nestSnaplet "" acid $ acidInit initialPotionSoapState
    addRoutes routes
    return $ App h a
