{-# LANGUAGE OverloadedStrings #-}

module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Data.ByteString.Char8                       (ByteString)
import           Snap
import           Snap.Snaplet.AcidState
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist
import           Snap.Snaplet.Session.Backends.CookieSession
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application
import           Authentication.AcidStateBackend
import qualified Authentication.Site                         as Auth
import qualified CSS.Site                                    as CSS
import qualified Mixture.Site                                as Mixture
import           PotionSoap
import qualified Reagent.Site                                as Reagent


------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ (""      , serveDirectoryWith fancyDirectoryConfig "public")
         , ("tests" , serveFile "public/templates/tests.html")
         , ("icons", serveDirectory "public/images/icons")
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
    addRoutes CSS.routes
    addRoutes Mixture.routes
    addRoutes Reagent.routes
    addAuthSplices auth
    return $ App h s x a
