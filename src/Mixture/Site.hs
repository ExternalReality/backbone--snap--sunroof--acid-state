{-# LANGUAGE OverloadedStrings #-}

module Mixture.Site where

import           Authentication.AcidStateBackend
import           Control.Monad (liftM, (=<<))
import           Control.Monad.Trans
import           Data.Aeson
import           Data.ByteString (ByteString)
import           Data.Maybe
import qualified Data.Text as T
import qualified Heist.Interpreted as I
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.AcidState
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist
import           Data.Set
------------------------------------------------------------------------------
import           Application
import           Mixture
import           PotionMaker


------------------------------------------------------------------------------
saveMixture :: Handler App (AuthManager App) ()
saveMixture = method PUT $ do
  maybeMixture <- liftM decode $ readRequestBody 2048 
  case maybeMixture of
    (Just mixture) -> do
      maybeValidMixture <- query $ ValidateMixture mixture
      case maybeValidMixture of 
        (Just validMixture) -> saveMixtureForCurrentUser validMixture
        Nothing             -> modifyResponse $ setResponseStatus 400 ""
    Nothing -> modifyResponse $ setResponseStatus 400 ""

  where
    saveMixtureForCurrentUser mixture = do
      maybeUserId <- liftM (userId =<<) currentUser
      case maybeUserId of   
        (Just id) -> update $ SaveMixture mixture id
        Nothing   -> modifyResponse $ setResponseStatus 500 ""

------------------------------------------------------------------------------
routes :: [(ByteString, Handler App (AuthManager App) ())]
routes = [ ("api/mixtures", saveMixture) ]
          
