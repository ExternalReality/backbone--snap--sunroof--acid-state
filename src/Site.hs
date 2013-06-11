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
import           Authentication.AcidStateBackend
import qualified Reagent.Site as Reagent
import           PotionSoap


------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [(""      , serveDirectoryWith fancyDirectoryConfig "public")
         ,("tests" , serveFile "public/templates/tests.html")
         ]


------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    s <- nestSnaplet "sess" sess $
         initCookieSessionManager "site_key.txt" "sess" (Just 3600)
    x <- nestSnaplet "auth" auth $
         initAcidAuthManager defAuthSettings sess
    a <- nestSnaplet "" acid $ acidInit initialPotionSoapState

    addRoutes routes
    addRoutes Auth.routes
    addRoutes Reagent.routes
    addAuthSplices auth
    return $ App h s x a
