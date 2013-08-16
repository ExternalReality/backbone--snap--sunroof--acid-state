{-# LANGUAGE OverloadedStrings #-}
module Mixture.MixtureQueries where

------------------------------------------------------------------------------
import           Control.Lens
import           Control.Monad
import           Data.Acid
import           Data.ByteString (ByteString)
import           Data.IxSet
import qualified Data.IxSet      as IxSet
import qualified Data.Set        as S
------------------------------------------------------------------------------
import           Mixture
import           PotionMaker
import           PotionSoap      hiding (_mixtures)
import qualified PotionSoap      as PS

------------------------------------------------------------------------------
saveMixture :: Mixture Validated -> PotionMakerId -> Update PotionSoapState ()
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
validateMixture :: Mixture NotValidated ->
                   Query PotionSoapState
                         (Either ByteString (Mixture Validated))
validateMixture mixture = do
  allReagents <- liftM toSet $ view PS.reagents
  let mixtureReagents = Mixture._reagents mixture
  return $ if S.isSubsetOf mixtureReagents allReagents
             then Right (Mixture Nothing mixtureReagents)
             else Left "Invalid Mixture"

------------------------------------------------------------------------------
potionMakersMixtures :: PotionMakerId ->
                        Query PotionSoapState (S.Set (Mixture Validated))
potionMakersMixtures pmId = do
  potionMakerState <- view potionMakers
  let maybePotionMaker = getOne $ potionMakerState @= pmId
  return $ maybe (error "no potion maker") _mixtures maybePotionMaker
