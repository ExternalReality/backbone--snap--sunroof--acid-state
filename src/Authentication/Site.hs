{-# LANGUAGE OverloadedStrings #-}

module Authentication.Site where

import           Authentication.AcidStateBackend
import           Control.Applicative ((<|>))
import           Control.Monad
import           Data.ByteString (ByteString)
import           Data.Maybe
import qualified Data.Text as T
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.AcidState
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist
import qualified Heist.Interpreted as I
------------------------------------------------------------------------------
import           Application
import           Authentication.AcidStateBackend

------------------------------------------------------------------------------
laboratoryURL :: ByteString
laboratoryURL = "/#laboratory"


------------------------------------------------------------------------------
handleLogin :: Maybe T.Text -> Handler App (AuthManager App) ()
handleLogin authError = heistLocal (I.bindSplices errs) $ render "login"
  where
    errs = [("loginError", I.textSplice c) | c <- maybeToList authError]


------------------------------------------------------------------------------
handleLoginSubmit :: Handler App (AuthManager App) ()
handleLoginSubmit =
    loginUser "login" "password" Nothing
              (\e -> handleLogin (Just . T.pack . show $ e)) 
              (redirect laboratoryURL)
  where
    err = Just "Unknown user or password"


------------------------------------------------------------------------------
handleLogout :: Handler App (AuthManager App) ()
handleLogout = logout >> redirect "/login"


------------------------------------------------------------------------------
handleNewUser :: Handler App (AuthManager App) ()
handleNewUser = method GET handleForm <|> method POST handleFormSubmit
  where
    handleForm = render "new_user"
    
    handleFormSubmit = do 
    eitherAuthFailureOrUser <- registerUser "login" "password" 
    case eitherAuthFailureOrUser of
      Left _     -> redirect "/"
       Right user -> do
         maybeRole <- getPostParam "role"
         case maybeRole of
           (Just role) -> do
             eitherErrorUser <- saveUser $ user { userRoles = [Role role] }
             case eitherErrorUser of
               (Right user) -> do
                 let id = (fromJust . userId $ user)
                 update (CreatePotionMaker id)
                 redirect "/"
               (Left _) -> error ""
           Nothing -> error "error"

                            
------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("/login"        , with auth (handleLogin Nothing))
         , ("/login_submit" , with auth handleLoginSubmit)
         , ("/logout"       , with auth handleLogout)
         , ("/new_user"     , with auth handleNewUser)
         ]
