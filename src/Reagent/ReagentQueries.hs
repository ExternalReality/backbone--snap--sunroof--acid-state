{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RecordWildCards  #-}

module Reagent.ReagentQueries where

import Control.Lens
import Control.Monad

import Control.Monad.State
import Data.Acid
import Data.IxSet as IxSet
import Data.Maybe (isJust)
------------------------------------------------------------------------------
import PotionSoap
import Reagent

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
updateReagent reagent = 
  maybe (return ()) updateReagent' $ _reagentId reagent
  
  where
   updateReagent' = 
     return $ reagents %= updateIx (_reagentId reagent) reagent 
                
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
