{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module Authentication.Site where

import           Authentication.AcidStateBackend
import           Control.Applicative ((<|>))
import           Control.Monad.Trans
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
import           Authentication.AcidStateBackend
import           Data.Acid


------------------------------------------------------------------------------
handleLogin :: Maybe T.Text -> Handler App (AuthManager App) ()
handleLogin authError = heistLocal (I.bindSplices errs) $ render "login"
  where
    errs = [("loginError", I.textSplice c) | c <- maybeToList authError]


------------------------------------------------------------------------------
handleLoginSubmit :: Handler App (AuthManager App) ()
handleLoginSubmit =
    loginUser "login" "password" Nothing
              (\e -> handleLogin (Just . T.pack . show $ e)) (redirect "/#reagents")
  where
    err = Just "Unknown user or password"


------------------------------------------------------------------------------
handleLogout :: Handler App (AuthManager App) ()
handleLogout = logout >> redirect "/login"


------------------------------------------------------------------------------
-- | Handle new user form submit
handleNewUser :: Handler App (AuthManager App) ()
handleNewUser = method GET handleForm <|> method POST handleFormSubmit
  where
    handleForm = render "new_user"
    handleFormSubmit = do 
    afu <- registerUser "login" "password" 
    case afu of
      Left error -> (liftIO $ print (show error)) >> redirect "/"
      Right user    -> (liftIO $ print (show user)) >> redirect "/"


------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("/login"        , with auth (handleLogin Nothing))
         , ("/login_submit" , with auth handleLoginSubmit)
         , ("/logout"       , with auth handleLogout)
         , ("/new_user"     , with auth handleNewUser)
         ]
