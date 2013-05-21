{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Control.Applicative
import           Control.Monad
import qualified Data.ByteString.Char8 as S
import           Data.Aeson
import           Data.Char
import           Data.ByteString (ByteString)
import           Data.Maybe
import qualified Data.Text as T
import           Heist
import qualified Heist.Interpreted as I
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Auth.Backends.JsonFile
import           Snap.Snaplet.Heist
import           Snap.Snaplet.Session.Backends.CookieSession
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application
import           Reagent

getR :: Handler App App ()
getR = method GET $ do
         let m = Reagent "Aloe"
         modifyResponse $ setContentType "application/json"
         writeLBS $ encode m

------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ 
           ("",          serveDirectory "static")
         , ("testR",     getR)
         ]


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"  
    addRoutes routes
    return $ App h
