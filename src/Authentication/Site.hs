{-# LANGUAGE OverloadedStrings #-}

module Authentication.Site where


import           Control.Applicative    ((<|>))

import           Control.Monad.Trans
import           Data.ByteString        (ByteString)
import           Data.Maybe
import qualified Data.Text              as T
import           Heist
import qualified Heist.Interpreted      as I
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.AcidState
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist
------------------------------------------------------------------------------
import           Application
import           Authentication.JanrainEngage

------------------------------------------------------------------------------
laboratoryURL :: ByteString
laboratoryURL = "/#laboratory"

------------------------------------------------------------------------------
handleLogin :: Maybe T.Text -> Handler App (AuthManager App) ()
handleLogin authError = heistLocal (I.bindSplices errs) $ render "login"
  where
    errs = maybe noSplices splice authError
    splice err = "loginError" ## I.textSplice err

------------------------------------------------------------------------------
handleLoginSubmit :: Handler App (AuthManager App) ()
handleLoginSubmit =
    loginUser "login" "password" Nothing
              (const $ handleLogin err)
              (redirect laboratoryURL)
  where
    err = Just "Unknown Username or Password"

------------------------------------------------------------------------------
handleSocialLoginSubmit :: Handler App (AuthManager App) ()
handleSocialLoginSubmit = do
  maybeAuthToken <- getPostParam "token" 
  case maybeAuthToken of
     Nothing    -> error "No token" 
     Just token -> do 
       response <- liftIO $ getAuthUserFromSocialNetwork token
       let  authUser = fromMaybe (error "") response
       z <- saveUser authUser
       case z of 
         (Left err) -> do
           error ((show err) ++ "RRRRRRRRRRRRRRRRRRRRRRR")
         (Right m) -> do
           p <- forceLogin m
           case p of       
             (Left err) -> writeText $ T.pack $ show err
             (Right _)  ->  redirect laboratoryURL
              


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
               (Right nu) -> do
                 let uid = fromJust . userId $ nu
                 update (CreatePotionMaker uid)
                 redirect "/"
               (Left _) -> error "error creating user"
           Nothing -> error "error"

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("/login"               , with auth (handleLogin Nothing))
         , ("/social_login_submit" , with auth handleSocialLoginSubmit)
         , ("/login_submit"        , with auth handleLoginSubmit)
         , ("/logout"              , with auth handleLogout)
         , ("/new_user"            , with auth handleNewUser)
         ]
