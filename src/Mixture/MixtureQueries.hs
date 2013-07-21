{-# LANGUAGE OverloadedStrings #-}
module Mixture.MixtureQueries where

------------------------------------------------------------------------------
import           Control.Lens
import           Control.Monad
import           Data.Acid
import           Data.ByteString (ByteString)
import           Data.IxSet
import qualified Data.IxSet as IxSet
import qualified Data.Set as S
------------------------------------------------------------------------------
import           Mixture
import           PotionMaker
import           PotionSoap

------------------------------------------------------------------------------
saveMixture :: Mixture Validated -> PotionMakerId -> Update PotionSoapState ()
saveMixture mixture pmId = do
  potionMakerState <- use potionMakers
  let maybePotionMaker = getOne $ potionMakerState @= pmId
  case maybePotionMaker of
    (Just potionMaker) -> do
      let potionMaker' = potionMaker { _mixtures = S.insert mixture (_mixtures potionMaker) }
      potionMakers .= IxSet.updateIx pmId potionMaker' potionMakerState
    Nothing -> return ()

------------------------------------------------------------------------------
validateMixture :: Mixture NotValidated -> 
                   Query PotionSoapState (Either ByteString (Mixture Validated))
validateMixture mixture = do
  allReagents <- liftM toSet $ view reagents
  let mixtureReagents = Mixture._reagents mixture
  return $ if S.isSubsetOf mixtureReagents allReagents
             then Right (Mixture mixtureReagents)
             else Left "Invalid Mixture" 
