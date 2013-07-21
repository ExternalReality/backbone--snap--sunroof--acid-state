{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Data.ByteString.Char8 (ByteString)
import           Data.Text
import           Snap
import           Snap.Snaplet.AcidState
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist
import           Snap.Snaplet.Session.Backends.CookieSession
import           Snap.Util.FileServe
import           Text.Cassius (CssUrl, cassiusFile, cassiusFileReload, renderCssUrl)
------------------------------------------------------------------------------
import           Application
import qualified Authentication.Site as Auth
import qualified Mixture.Site as Mixture
import           Authentication.AcidStateBackend
import qualified Reagent.Site as Reagent
import           PotionSoap

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ (""      , serveDirectoryWith fancyDirectoryConfig "public")
         , ("tests" , serveFile "public/templates/tests.html")
         , ("reagent-icon.css",    css) 
         ]         


------------------------------------------------------------------------------
template :: CssUrl Text
template = $(cassiusFileReload "public/css/template.cassius")


------------------------------------------------------------------------------
mapping :: Text -> [(Text, Text)] -> Text
mapping css _ = "css"  


------------------------------------------------------------------------------
css :: Handler App App ()
css = do
  modifyResponse $ setContentType "text/css; charset=UTF-8"
  writeLazyText $ renderCssUrl mapping template


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
    addRoutes Mixture.routes
    addAuthSplices auth
    return $ App h s x a
