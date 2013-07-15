{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell #-}

module PotionSoap where

------------------------------------------------------------------------------
import Control.Lens
import Data.Data
import Data.IxSet
import Data.SafeCopy
import PotionMaker
import Reagent



------------------------------------------------------------------------------
data PotionSoapState = PotionSoapState { _nextReagentId :: ReagentId
                                       , _reagents      :: IxSet Reagent
                                       , _potionMakers  :: IxSet PotionMaker
                                       }
                       deriving (Data, Typeable)

deriveSafeCopy 0 'base ''PotionSoapState
makeLenses ''PotionSoapState


------------------------------------------------------------------------------
initialPotionSoapState :: PotionSoapState
initialPotionSoapState = PotionSoapState { _nextReagentId = ReagentId 0
                                         , _reagents      = empty
                                         , _potionMakers  = empty
                                         }

                                         
------------------------------------------------------------------------------
