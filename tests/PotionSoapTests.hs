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

------------------------------------------------------------------------------
data TestData = TestData { _acid           :: AcidState UserStore 
                         , _actualAuthUser :: AuthUser
                         } 
                           
makeLenses ''TestData

------------------------------------------------------------------------------
type AuthenticationTest = StateT TestData Identity Bool
type TestState = State TestData


------------------------------------------------------------------------------
testState = TestData (openAcidState emptyUS) defAuthUser
saveTime = UTCTime (ModifiedJulianDay 1) (secondsToDiffTime 1)


------------------------------------------------------------------------------
main :: IO ()
main = hspec $         
  describe "AcidStateBackend" $
    it "can persist a new user" $ evalState testPersistNewUser testState


------------------------------------------------------------------------------    
testPersistNewUser :: AuthenticationTest
testPersistNewUser = do
  givenAUserThatIsNotPersisted
  whenISaveTheUser
  thenTheUserShouldBePersistedInTheDataBase


------------------------------------------------------------------------------        
givenAUserThatIsNotPersisted :: (MonadState TestData m) => m ()
givenAUserThatIsNotPersisted = actualAuthUser .= defAuthUser
 
 
------------------------------------------------------------------------------        
whenISaveTheUser :: (MonadState TestData m) => m ()
whenISaveTheUser = do
  user   <- use actualAuthUser
  store  <- use acid
  let (acid', result) = update store $ SaveAuthUser user saveTime
  case result of
       Left (AuthError e) -> error e
       Right _ -> acid .= acid'

    
------------------------------------------------------------------------------
thenTheUserShouldBePersistedInTheDataBase :: (MonadState TestData m) => m Bool
thenTheUserShouldBePersistedInTheDataBase  = do
  store <- use acid
  let userCount = length $ query store AllLogins
  return $ userCount == 1
