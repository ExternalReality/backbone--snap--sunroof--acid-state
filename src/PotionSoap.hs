{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell #-}

module PotionSoap where

------------------------------------------------------------------------------
import Control.Lens
import Data.Data
import Data.IxSet
import Data.SafeCopy
import Reagent.Reagent

------------------------------------------------------------------------------
data PotionSoapState = PotionSoapState { _nextReagentId :: ReagentId
                                       , _reagents      :: IxSet Reagent
                                       }
                       deriving (Data, Typeable)

deriveSafeCopy 0 'base ''PotionSoapState
makeLenses ''PotionSoapState

------------------------------------------------------------------------------
initialPotionSoapState :: PotionSoapState
initialPotionSoapState = PotionSoapState { _nextReagentId = ReagentId 0
                                         , _reagents      = empty 
                                         }
