{-# LANGUAGE OverloadedStrings #-}

module Mixture.Site where

import           Control.Monad (liftM)
import           Data.Aeson
import           Data.ByteString (ByteString)
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.AcidState
import           Snap.Snaplet.Auth
------------------------------------------------------------------------------
import           Application

------------------------------------------------------------------------------
saveMixture :: Handler App (AuthManager App) ()
saveMixture = method PUT $ do
  maybeMixture <- liftM decode $ readRequestBody 2048 
  case maybeMixture of
    (Just mixture) -> do
      eitherErrorMixture <- query $ ValidateMixture mixture
      case eitherErrorMixture of 
        (Right validMixture) -> saveMixtureForCurrentUser validMixture
        (Left e)             -> modifyResponse $ setResponseStatus 400 e
    Nothing -> modifyResponse $ setResponseStatus 400 "Invalid Data"

  where
    saveMixtureForCurrentUser mixture = do
      maybeUserId <- liftM (userId =<<) currentUser
      case maybeUserId of   
        (Just uId) -> update $ SaveMixture mixture uId
        Nothing   -> modifyResponse $ setResponseStatus 500 "Invalid Request"

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("api/mixtures", with auth saveMixture) ]
