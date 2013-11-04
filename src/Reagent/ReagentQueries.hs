{-# LANGUAGE FlexibleContexts #-}

module Reagent.ReagentQueries where

import           Control.Lens
import           Control.Monad

import           Control.Monad.State
import           Data.Acid
import           Data.IxSet as IxSet 
import           Data.Maybe (isJust)  
import           Data.Set hiding (toList)
------------------------------------------------------------------------------
import           PotionSoap
import qualified PotionSoap as PS
import           Reagent

------------------------------------------------------------------------------
newReagent :: Reagent -> Update PotionSoapState Bool
newReagent reagent = do
  reagentState <- use reagents   
  let reagentNameExists = isJust . getOne $reagentState @= _name reagent
     
  if reagentNameExists
    then return True
    else do 
         reagent' <- createReagent reagent
         incrementNextReagentId
         saveReagent reagent'
         return False
               
------------------------------------------------------------------------------
updateReagent :: Reagent -> Update PotionSoapState ()
updateReagent reagent = reagents %= updateIx (_reagentId reagent) reagent 
                
------------------------------------------------------------------------------
allReagents :: Query PotionSoapState [Reagent]
allReagents = liftM toList (view reagents)

------------------------------------------------------------------------------
reagentById :: ReagentId -> Query PotionSoapState (Maybe Reagent)
reagentById rId = do
  reagentState <- view reagents
  return . getOne $ reagentState @= rId

------------------------------------------------------------------------------
reagentByName :: ReagentName -> Query PotionSoapState (Maybe Reagent)
reagentByName reagentName = do
  reagentState <- view reagents
  return . getOne $ reagentState @= reagentName

------------------------------------------------------------------------------
incrementNextReagentId :: (MonadState PotionSoapState m) => m ()
incrementNextReagentId = nextReagentId.unReagentId += 1

------------------------------------------------------------------------------
createReagent :: (MonadState PotionSoapState m) => Reagent            
                                                -> m Reagent
createReagent reagent = do
  nextId <- use nextReagentId
  return $ reagent { _reagentId = Just nextId }
                                  
------------------------------------------------------------------------------
saveReagent :: Reagent -> Update PotionSoapState ()
saveReagent reagent = do
  let reagentName =  _name reagent
  reagentState <- use reagents
  reagents .= IxSet.updateIx reagentName reagent reagentState

------------------------------------------------------------------------------
deleteReagent :: Reagent -> Update PotionSoapState ()
deleteReagent reagent = do
  let reagentName =  _name reagent
  reagentState <- use reagents
  reagents .= IxSet.deleteIx reagentName reagentState

------------------------------------------------------------------------------
deleteReagentByName :: ReagentName -> Update PotionSoapState ()
deleteReagentByName reagentName = do
  reagentState <- use reagents
  reagents .= IxSet.deleteIx reagentName reagentState


------------------------------------------------------------------------------
findReagents :: [ReagentId] -> Query PotionSoapState (Set Reagent)
findReagents reagentIds = do
  knownReagents <- view PS.reagents
  return $ toSet $ knownReagents @* reagentIds
