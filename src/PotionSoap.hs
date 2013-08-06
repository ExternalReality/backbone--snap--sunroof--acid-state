{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell #-}

module PotionSoap where

------------------------------------------------------------------------------
import Control.Lens
import Data.Data
import Data.IxSet
import Data.SafeCopy
------------------------------------------------------------------------------
import PotionMaker hiding (_mixtures)
import Reagent
import Mixture hiding (_reagents)

------------------------------------------------------------------------------
data PotionSoapState = PotionSoapState { _nextReagentId :: ReagentId
                                       , _nextMixtureId :: MixtureId
                                       , _reagents      :: IxSet Reagent
                                       , _mixtures      :: IxSet (Mixture Validated)
                                       , _potionMakers  :: IxSet PotionMaker
                                       }
                       deriving (Data, Typeable)

deriveSafeCopy 0 'base ''PotionSoapState
makeLenses ''PotionSoapState


------------------------------------------------------------------------------
initialPotionSoapState :: PotionSoapState
initialPotionSoapState = PotionSoapState { _nextReagentId = ReagentId 0
                                         , _nextMixtureId = MixtureId 0
                                         , _reagents      = empty
                                         , _mixtures      = empty
                                         , _potionMakers  = empty
                                         }

                                         
------------------------------------------------------------------------------
