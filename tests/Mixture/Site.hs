{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.Identity
import Control.Lens
import Control.Monad.State
import Data.Acid.Memory
import Data.Acid.Memory.Pure
import Data.Data
import Data.SafeCopy
import Data.Time
import Snap.Snaplet.Auth
import Test.Hspec
import Test.Hspec.HUnit
------------------------------------------------------------------------------
import Authentication.AcidStateBackend
import PotionSoap



 ------------------------------------------------------------------------------
data TestData = TestData { _potionSoapState :: AcidState PotionSoapState
                         , _authState       :: AcidState UserStore
                         }


------------------------------------------------------------------------------
testState = TestDate (openAcidState emptyUS)

------------------------------------------------------------------------------
type MixtureHandlerTest = State TestData Bool

------------------------------------------------------------------------------
mixutreSpec =
  describe "Mixture.Site" $
    it "can save a mixture for the current user" $ evalState testSaveMixture 
                                                             testState


------------------------------------------------------------------------------
testSaveMixture :: MixtureHandlerTest
testSaveMixture = do
  givenALogginInPotionMaker
  whenThatPotionMakerSavesAMixture
  thenTheMixtureShouldBeSavedForThatPotionMaker

------------------------------------------------------------------------------
givenALogginInPotionMaker :: (MonadState TestData m) => m ()
givenALogginInPotionMaker = undefined

------------------------------------------------------------------------------
whenThatPotionMakerSavesAMixture :: (MonadState TestData m) => m ()
whenThatPotionMakerSavesAMixture = undefined

------------------------------------------------------------------------------
thenTheMixtureShouldBeSavedForThatPotionMaker :: (MonadState TestData m) => m Bool
thenTheMixtureShouldBeSavedForThatPotionMaker = undefinedssssssssssssjjjj
