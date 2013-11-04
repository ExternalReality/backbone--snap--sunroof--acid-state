{-# LANGUAGE OverloadedStrings #-}

module Mixture.Site where

import Control.Monad          (liftM)
import Control.Monad.Trans
import Data.Aeson
import Data.ByteString        (ByteString)
import Data.Set
import Prelude hiding (null)
import Snap.Core
import Snap.Snaplet
import Snap.Snaplet.AcidState
import Snap.Snaplet.Auth
------------------------------------------------------------------------------
import Application
import Mixture
import Reagent

------------------------------------------------------------------------------
saveMixture :: Handler App (AuthManager App) ()
saveMixture = method PUT $ do
  maybeByteString <-  getParam "reagents"
  let maybeReagentIds = decodeStrict =<< maybeByteString
  case maybeReagentIds of
    (Just reagentIds) -> do
      reagents <- query $ FindReagents reagentIds
      if null reagents
        then modifyResponse $ setResponseStatus 400 "invalid reagent id"
        else saveMixtureForCurrentUser reagents
    Nothing    -> modifyResponse $ setResponseStatus 500 "Invalid Request"
   
  where
    saveMixtureForCurrentUser :: Set Reagent -> Handler App (AuthManager App) ()
    saveMixtureForCurrentUser reagents = do
      maybeUserId <- liftM (userId =<<) currentUser
      case maybeUserId of
        (Just uId) -> update $ SaveMixture (Mixture (Just (-1)) reagents) uId
        Nothing    -> modifyResponse $ setResponseStatus 500 "Invalid Request"


------------------------------------------------------------------------------
potionMakersMixtures :: Handler App (AuthManager App) ()
potionMakersMixtures = method GET $ do
  maybePotionMakerId <- liftM (userId =<<) currentUser
  case maybePotionMakerId of
    (Just potionMakerId) -> do
      mixtures <- query $ PotionMakersMixtures potionMakerId
      writeLBS $ encode $ toList mixtures
    Nothing -> error "Error in potionMakerMixtures"


------------------------------------------------------------------------------
routes :: [(ByteString, Handler App App ())]
routes = [ ("api/mixtures", with auth saveMixture)
         , ("api/mixtures", with auth potionMakersMixtures)
         ]
