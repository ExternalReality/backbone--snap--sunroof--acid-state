{-# LANGUAGE OverloadedStrings #-}
module Mixture.MixtureQueries where

------------------------------------------------------------------------------
import           Control.Lens
import           Control.Monad
import           Data.Acid
import           Data.ByteString (ByteString)
import           Data.IxSet
import qualified Data.IxSet      as IxSet
import           Data.Set (Set)
import qualified Data.Set        as S
------------------------------------------------------------------------------
import           Mixture
import           PotionMaker
import           PotionSoap      hiding (_mixtures)
import qualified PotionSoap      as PS

------------------------------------------------------------------------------
saveMixture :: Mixture -> PotionMakerId -> Update PotionSoapState ()
saveMixture mixture pmId = do
  potionMakerState <- use potionMakers
  let maybePotionMaker = getOne $ potionMakerState @= pmId
  case maybePotionMaker of
    (Just potionMaker) -> do
      mixtureState <- use PS.mixtures
      let maybeExistingMixture = getOne $ mixtureState @= Mixture._reagents mixture
      case maybeExistingMixture of
        (Just mixture') -> do
          let potionMaker' = potionMaker { _mixtures = S.insert mixture' (_mixtures potionMaker) }
          potionMakers .= IxSet.updateIx pmId potionMaker' potionMakerState
        Nothing -> do
          nextId <- use nextMixtureId
          nextMixtureId += MixtureId 1
          let mixture' = mixture { _mixtureId = Just nextId }
          let potionMaker' = potionMaker { _mixtures = S.insert mixture' (_mixtures potionMaker) }
          potionMakers %= IxSet.updateIx pmId potionMaker'
          PS.mixtures %= IxSet.insert mixture'
    Nothing -> return ()

------------------------------------------------------------------------------
potionMakersMixtures :: PotionMakerId ->
                        Query PotionSoapState (Set Mixture)
potionMakersMixtures pmId = do
  potionMakerState <- view potionMakers
  let maybePotionMaker = getOne $ potionMakerState @= pmId
  return $ maybe (error "no potion maker") _mixtures maybePotionMaker
