module Mixture.MixtureQueries where

------------------------------------------------------------------------------
import           Control.Lens
import           Control.Monad
import           Control.Monad.State
import           Data.Acid
import           Data.IxSet as IxSet
import           Data.Maybe (isJust)
import qualified Data.Set as S
------------------------------------------------------------------------------
import           Mixture
import           PotionMaker
import           PotionSoap
import           Reagent

------------------------------------------------------------------------------
saveMixture :: Mixture Validated -> PotionMakerId -> Update PotionSoapState ()
saveMixture mixture potionMakerId = do
  potionMakerState <- use potionMakers
  let maybePotionMaker = getOne $ potionMakerState @= (Just potionMakerId)
  case maybePotionMaker of
    (Just potionMaker) -> do
       let potionMaker' = potionMaker { _mixtures = S.insert mixture (_mixtures potionMaker) }
       potionMakers .= IxSet.updateIx potionMakerId potionMaker' potionMakerState
    Nothing -> return ()


------------------------------------------------------------------------------
validateMixture :: Mixture NotValidated -> 
                   Query PotionSoapState (Maybe (Mixture Validated))
validateMixture mixture = do
  reagents <- liftM toSet $ view reagents
  let mixtureReagents = Mixture._reagents mixture
  if S.isSubsetOf mixtureReagents reagents
     then return $ Just (Mixture mixtureReagents)
     else return Nothing 


------------------------------------------------------------------------------
