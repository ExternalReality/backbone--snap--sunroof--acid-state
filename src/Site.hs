{-# LANGUAGE OverloadedStrings #-}

module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Data.ByteString.Char8 (ByteString)
import           Snap
import           Snap.Snaplet.AcidState
import           Snap.Snaplet.Heist
import           Snap.Util.FileServe
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Auth.Backends.JsonFile
import           Snap.Snaplet.Session.Backends.CookieSession
------------------------------------------------------------------------------
import           Application
import qualified Authentication.Site as Auth
import qualified Reagent.Site as Reagent
import           PotionSoap

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [("", serveDirectoryWith fancyDirectoryConfig "public")]


------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    a <- nestSnaplet "" acid $ acidInit initialPotionSoapState
    s <- nestSnaplet "sess" sess $
         initCookieSessionManager "site_key.txt" "sess" (Just 3600)
    x <- nestSnaplet "auth" auth $
         initJsonFileAuthManager defAuthSettings sess "users.json"

    addRoutes routes
    addRoutes Auth.routes
    addRoutes Reagent.routes
    addAuthSplices auth  
    return $ App h a s x
