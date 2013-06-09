{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RecordWildCards #-}

module Reagent.ReagentQueries where

------------------------------------------------------------------------------
import Control.Monad
import Control.Lens
import Control.Monad.Reader (ask)
import Control.Monad.State
import Data.Acid
import Data.IxSet as IxSet
------------------------------------------------------------------------------
import PotionSoap
import Reagent.Reagent

------------------------------------------------------------------------------
newReagent :: ReagentName -> Update PotionSoapState ()
newReagent rn = do
  reagent <- createReagent rn
  incrementNextReagentId
  saveReagent reagent


------------------------------------------------------------------------------
allReagents :: Query PotionSoapState [Reagent]
allReagents = liftM toList (view reagents)


------------------------------------------------------------------------------
reagentById :: ReagentId -> Query PotionSoapState (Maybe Reagent)
reagentById reagentId = do
  reagentState <- view reagents
  return . getOne $ reagentState @= reagentId

  
------------------------------------------------------------------------------
reagentByName :: ReagentName -> Query PotionSoapState (Maybe Reagent)
reagentByName reagentName = do
  reagentState <- view reagents
  return . getOne $ reagentState @= reagentName


------------------------------------------------------------------------------
incrementNextReagentId :: (MonadState PotionSoapState m) => m ()
incrementNextReagentId = do
  nextReagentId.unReagentId += 1


------------------------------------------------------------------------------
createReagent :: (MonadState PotionSoapState m) => ReagentName -> m Reagent
createReagent = liftM2 Reagent (use nextReagentId) . return


------------------------------------------------------------------------------
saveReagent :: Reagent -> Update PotionSoapState ()
saveReagent reagent = do
  let name =  _name reagent
  reagentState <- use reagents
  reagents .= IxSet.updateIx name reagent reagentState
