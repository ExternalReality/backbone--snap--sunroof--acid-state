{-# LANGUAGE OverloadedStrings #-}

module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Data.ByteString.Char8                       (ByteString)
import qualified Data.Text as T
import           Snap
import           Snap.Snaplet.AcidState
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist
import           Snap.Snaplet.Session.Backends.CookieSession
import           Snap.Util.FileServe
import           Web.Routes
------------------------------------------------------------------------------
import           Application
import           Authentication.AcidStateBackend
import qualified Authentication.Site                         as Auth
import qualified CSS.Site                                    as CSS
import           Data.Monoid
import qualified JavaScript.Site                             as JavaScript
import qualified Mixture.Site                                as Mixture
import           PotionSoap
import qualified Reagent.Site                                as Reagent

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ (""      , serveDirectory "public")
         , ("tests" , serveFile "public/templates/tests.html")
         , ("icons" , serveDirectory "public/images/icons")
	 , ("wr"    , webRoute routeAppURL)
         ]

------------------------------------------------------------------------------
routeAppURL :: MonadSnap m => Route -> m ()
routeAppURL appURL =
  case appURL of
    (Count n) -> writeText $ "Count = " `T.append` T.pack (show n)
    (Msg s i) -> writeText $ "Msg = " <> T.pack s <> " " <> T.pack (show i)

------------------------------------------------------------------------------
webRoute :: (PathInfo url, MonadSnap m) => (url -> m ()) -> m ()
webRoute router =
    do rq <- getRequest
       case fromPathInfo $ rqPathInfo rq of
         (Left e) -> writeText (T.pack e)
         (Right url) -> router url

------------------------------------------------------------------------------
app :: SnapletInit App App
app = makeSnaplet "app" "Custom Organic Soap" Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    s <- nestSnaplet "sess" sess $
         initCookieSessionManager "site_key.txt" "sess" (Just 3600)
    x <- nestSnaplet "auth" auth $
         initAcidAuthManager defAuthSettings sess
    a <- nestSnaplet "" acid $ acidInit initialPotionSoapState
    
    let r u p = "/wr" `T.append` toPathInfoParams u p

    addRoutes routes
    addRoutes Auth.routes
    addRoutes CSS.routes
    addRoutes Mixture.routes
    addRoutes Reagent.routes
    addRoutes JavaScript.routes
    addAuthSplices h auth
    return $ App h s x a r
