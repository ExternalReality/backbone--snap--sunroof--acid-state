{-# LANGUAGE OverloadedStrings #-}

module Authentication.Site where

import           Data.ByteString (ByteString)
import           Data.Maybe
import qualified Data.Text as T
import qualified Heist.Interpreted as I
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist

------------------------------------------------------------------------------
import           Application

------------------------------------------------------------------------------
handleLogin :: Maybe T.Text -> Handler App (AuthManager App) ()
handleLogin authError = heistLocal (I.bindSplices errs) $ render "login"
  where
    errs = [("loginError", I.textSplice c) | c <- maybeToList authError]


------------------------------------------------------------------------------
handleLoginSubmit :: Handler App (AuthManager App) ()
handleLoginSubmit =
    loginUser "login" "password" Nothing
              (\_ -> handleLogin err) (redirect "/login")
  where
    err = Just "Unknown user or password"


------------------------------------------------------------------------------
handleLogout :: Handler App (AuthManager App) ()
handleLogout = logout >> redirect "/login"


------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("/login"        , with auth (handleLogin Nothing))
         , ("/login_submit" , with auth handleLoginSubmit)
         , ("/logout"       , with auth handleLogout)
         ]
